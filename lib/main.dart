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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  await Hive.initFlutter();
  await Hive.openBox('local_data');
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
}
