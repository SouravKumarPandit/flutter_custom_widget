import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabaseHelper {

  static final _databaseName = "country_database.db";
  static final _databaseVersion = 1;
  static final table = 'fav_country';

  static final countryCode = '_country_code';


  AppDatabaseHelper._privateConstructor();
  static final AppDatabaseHelper instance = AppDatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $countryCode INTEGER NOT NULL
          )
          ''');
  }
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }


  Future<List<Map<String, dynamic>>>  queryCountryCode(int iCountryCode) async {
    Database db = await instance.database;
    return await db.query(table,where: '$countryCode = ?', whereArgs: [iCountryCode]);

  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> delete(int iContryCode) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$countryCode = ?', whereArgs: [iContryCode]);
  }
}