import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test/route/route_constants.dart';
import 'package:test/route/router.dart' as router;
import 'package:test/theme/app_theme.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:http/http.dart' as http; // Add this dependency in pubspec.yaml
import 'dart:convert';
import 'package:test/main.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_startup/flutter_startup.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

var testIdx = 1;
@pragma('vm:entry-point')
void isolate2(String arg) {
  //FlutterStartup.startupReason.then((reason) {
  //  print("Isolate2 $reason");
  //});
  Timer.periodic(Duration(seconds: 10), (timer) {
    testIdx++;
    Utils.showNotification_backend(testIdx, 'pTitle', 'pBody');
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

/// The access token for the GL (Global) API.
/// This token is used to authenticate API requests.
var GL_access_token = '';

/// The ID token for the GL (Global) API.
/// This token is used to identify the user making the API requests.
var GL_id_token = '';
var Gl_user_name = '';

/// Flutter 應用程式的主入口點。
///
/// 此函數初始化應用程式，並調用 `runApp` 函數，
/// 傳入一個 `MyApp` 實例作為參數，
/// 該實例設置了小部件樹並啟動應用程式。
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('local_data');
  await FlutterIsolate.spawn(isolate2, "hello");

  // Timer(Duration(seconds: 5), () {
  //   print("Pausing Isolate 1");
  //   isolate.pause();
  // });
  // Timer(Duration(seconds: 10), () {
  //   print("Resuming Isolate 1");
  //   isolate.resume();
  // });
  // Timer(Duration(seconds: 20), () {
  //   print("Killing Isolate 1");
  //   isolate.kill();
  // });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 初始化應用程式
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '生產看板系統',
      // 設定主題
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,

      /// `onGenerateRoute` 屬性用於定義一個函數，當 `Navigator` 被要求導航到命名路由時，
      /// 會生成相應的路由。
      ///
      /// 在這個例子中，提供了來自 `router` 對象的 `generateRoute` 函數，
      /// 它將根據路由設置處理路由生成邏輯。
      onGenerateRoute: router.generateRoute,
      // 設定應用程式的初始路由 , 這裡是 onbordingScreenRoute ==  '/onbording'
      initialRoute: onbordingScreenRoute,
      //全局的訪問導航器（Navigator）
      navigatorKey: navigatorKey,
    );
  }
}

// 共同使用的工具函數，先放這邊
// FIXME: 這個類別應該放在一個獨立的文件中
class Utils {
  static Future<bool> loadEnv() async {
    await dotenv.load(fileName: "assets/.env");
    return true;
  }

  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$msg'),
      ),
    );
  }

  static void showError(BuildContext context, dynamic ex) {
    showMessage(context, ex.toString(), 'Error');
  }

  static void showMessage(BuildContext context, String text, String title_text) {
    var title_widget = Text('提示');
    if (title_text != '' && title_text != null && title_text == 'Error') {
      title_widget = Text(
        title_text,
        style: TextStyle(
          fontSize: 18.0, // 設置字體大小為較小
          color: Colors.red, // 設置字體顏色為紅色
        ),
      );
    } else {
      title_widget = Text(
        title_text,
        style: TextStyle(
          fontSize: 18.0, // 設置字體大小為較小
          color: const Color.fromARGB(255, 13, 182, 50), // 設置字體顏色為紅色
        ),
      );
    }
    var alert = AlertDialog(
        title: title_widget,
        content: Text(
          text,
          style: TextStyle(
            fontSize: 12.0, // 設置字體大小為較小
            color: const Color.fromARGB(255, 87, 33, 236), // 設置字體顏色為紅色
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              })
        ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  static Future<void> showMessage_Future(BuildContext context, String text, String title_text) {
    var title_widget = Text('提示');
    if (title_text != '' && title_text != null && title_text == 'Error') {
      title_widget = Text(
        title_text,
        style: TextStyle(
          fontSize: 18.0, // 設置字體大小為較小
          color: Colors.red, // 設置字體顏色為紅色
        ),
      );
    } else {
      title_widget = Text(
        title_text,
        style: TextStyle(
          fontSize: 18.0, // 設置字體大小為較小
          color: const Color.fromARGB(255, 13, 182, 50), // 設置字體顏色為紅色
        ),
      );
    }
    var alert = AlertDialog(
        title: title_widget,
        content: Text(
          text,
          style: TextStyle(
            fontSize: 12.0, // 設置字體大小為較小
            color: const Color.fromARGB(255, 87, 33, 236), // 設置字體顏色為紅色
          ),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              })
        ]);
    return showDialog(context: context, builder: (BuildContext context) => alert);
  }

  static Future<void> showNotification(BuildContext context, int showNotificationId, String pTitle, String pBody) async {
    // 檢查是否有通知權限
    final bool? granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();

    // 如果有通知權限，則顯示通知
    if (granted == true) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '世界先進',
        '即時通知',
        channelDescription: '世界先進（即時通知）',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(showNotificationId, pTitle, pBody, platformChannelSpecifics);
    } else {
      // 如果沒有通知權限，可以顯示一個提示訊息或執行其他操作
      Utils.showMessage(context, 'Notification permission not granted', 'Permission');
    }
  }

  static Future<void> showNotification_backend(int showNotificationId, String pTitle, String pBody) async {
    // 檢查是否有通知權限
    final bool? granted = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled();

    // 如果有通知權限，則顯示通知
    if (granted == true) {
      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '世界先進',
        '即時通知',
        channelDescription: '世界先進（即時通知）',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(showNotificationId, pTitle, pBody, platformChannelSpecifics);
    } else {
      // 如果沒有通知權限，可以顯示一個提示訊息或執行其他操作
      //Utils.showMessage(context, 'Notification permission not granted', 'Permission');
    }
  }
}
