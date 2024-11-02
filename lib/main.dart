import 'package:flutter/material.dart';
import 'package:test/route/route_constants.dart';
import 'package:test/route/router.dart' as router;
import 'package:test/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// The access token for the GL (Global) API.
/// This token is used to authenticate API requests.
var GL_access_token = '';

/// The ID token for the GL (Global) API.
/// This token is used to identify the user making the API requests.
var GL_id_token = '';

/// Flutter 應用程式的主入口點。
///
/// 此函數初始化應用程式，並調用 `runApp` 函數，
/// 傳入一個 `MyApp` 實例作為參數，
/// 該實例設置了小部件樹並啟動應用程式。
void main() {
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
