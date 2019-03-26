package com.application.idea.fluttercustomwidget;

import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterView;

public class MainActivity extends FlutterActivity {
  private FlutterGalleryInstrumentation instrumentation;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);
/*
    instrumentation = new FlutterGalleryInstrumentation(this.getFlutterView());
    getFlutterView().addFirstFrameListener(new FlutterView.FirstFrameListener() {
      @Override
      public void onFirstFrame() {
        // Report fully drawn time for Play Store Console.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
          MainActivity.this.reportFullyDrawn();
        }
        MainActivity.this.getFlutterView().removeFirstFrameListener(this);
      }
    });*/
  }
}
