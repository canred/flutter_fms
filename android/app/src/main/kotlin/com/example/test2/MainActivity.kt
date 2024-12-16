package com.vis.test
import androidx.annotation.NonNull

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity()
//class MainActivity: FlutterActivity() {
//  private val CHANNEL = "samples.flutter.dev/battery"

//  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//    super.configureFlutterEngine(flutterEngine)
//    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//      call, result ->
//      // This method is invoked on the main thread.
//      // TODO
//    }
//  }
//}

// 看這個文章 https://github.com/microsoftconnect/Taskr-Sample-Intune-Android-App/blob/master/ReactMAM/android/app/src/main/java/com/microsoft/intune/samples/taskr/MainApplication.java
