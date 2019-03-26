import 'package:flutter/material.dart';
import 'package:flutter_custom_widget/database/country_database.dart';
import 'package:flutter_custom_widget/model/country_list.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
//    changeStatusColor(Colors.black);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          title: Text('Sample Demo'),
        ),
        body: MyHomePage(),
      ),
    );
  }

  changeStatusColor(Color color) async {
//    try {
    await FlutterStatusbarcolor.setStatusBarColor(color);
//    } on PlatformException catch (e) {
//      print(e);
//    }
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  List<String> country = CountryDetails().getCountry();
  List<int> code = CountryDetails().getCode();
  bool showProgressBar = true;
  List<int> saveFav;

  /* = CountryDetails().getSavedFav();*/
  AppDatabaseHelper dbHelper;

  @override
  Widget build(BuildContext context) {
    dbHelper = AppDatabaseHelper.instance;
    _query().then((newValue) {
      setState(() {
        saveFav = newValue as List<int>;
        showProgressBar = false;
      });
    });
    return showProgressBar
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: country.length,
            itemBuilder: (context, position) {
              return _itemCartWidget(
                  position, code[position], country[position]);
            },
          );
  }

  bool alreadySaved = false;

  Widget _itemCartWidget(int pos, int countryCode, String countryName) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: new GestureDetector(
          onTap: () {
            showInSnackBar("$pos" + ' $countryName ' + 'code is $countryCode');
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("$pos. " + ' $countryName ' + ' ( + $countryCode )'),
                  Spacer(),
//                Round(image: NetworkImage('https://randomuser.me/api/portraits/women/69.jpg'),)
                  InkWell(
                    onTap: () {
//                      alreadySaved = saveFav.contains(countryCode);
                      setState(() {
                        if (saveFav.contains(countryCode)) {
                          _delete(countryCode);
                          _query().then(
                              (newValue) => saveFav = newValue as List<int>);
                        } else {
                          _insert(countryCode);
                          _query().then(
                              (newValue) => saveFav = newValue as List<int>);
                        }
                      });
                    },
                    child: Icon(
                     saveFav.contains(countryCode)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ));
  }

  void _insert(int iCountryCode) async {
    // row to insert
    Map<String, dynamic> row = {
      AppDatabaseHelper.countryCode: iCountryCode,
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id < $iCountryCode >');
  }

  Future<List<int>> _query() async{
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:  $allRows');
    List<int> list = [];
    for (int i = 0; allRows.length > i; i++) {
      Map<String, dynamic> row = allRows[i];
      int code = row[AppDatabaseHelper.countryCode];
      list.add(code);
    }
    return list;
  }

/*
  List<int> getSavedList() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:  $allRows');
    List<int> list = [];
    allRows.forEach((row) {
      print('------------$row');
      list.add(row)
    });
  }*/

  void _delete(int countryCode) async {
    final rowsDeleted = await dbHelper.delete(countryCode);
    print(
        '∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞ deleted $rowsDeleted row(s): row $countryCode\n--------------------------\n ');
  }

  iconTapped() {}
}
