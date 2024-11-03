import 'package:flutter/material.dart';
import 'package:test/constants.dart';
import 'package:test/route/route_constants.dart';
import 'dart:developer';
import 'package:test/models/my_user.dart';
import 'package:test/main.dart';

/// 一個代表應用程式登入畫面的 `StatefulWidget`。
/// 這個 widget 負責顯示登入介面並處理與登入相關的使用者互動。
/// `LoginScreen` widget 會創建一個對應的 `_LoginScreenState` 物件來管理其狀態。
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 用來儲存從 Microsoft Graph API 取得的使用者資料
  late MyUser? myUser = null;

  @override
  Widget build(BuildContext context) {
    // 取得裝置的螢幕尺寸
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/security.jpeg",
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Authentication with Microsoft Entra ID and Precautions",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: defaultPadding / 2),
                  const Text(
                    "Microsoft Entra ID offers a secure and reliable way to authenticate your identity. When using Microsoft Entra ID for authentication",
                  ),
                  const SizedBox(height: defaultPadding),
                  SizedBox(
                    height: size.height > 700 ? size.height * 0.02 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 這裡是登入按鈕的事件處理函式
                      login(false);
                    },
                    child: const Text("Log in with Azure AD"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // FIXME: 這個變量要在正式的環境中刪除
                      GL_access_token = 'Canred Test';
                      Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute), arguments: GL_id_token);
                    },
                    child: const Text("Open App Home"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 登入使用者並選擇性地將他們重定向到另一個畫面。
  /// 此函式執行登入操作，並根據 [redirect] 的值，在成功登入後可能會將使用者導航到不同的畫面。
  /// [redirect] 決定使用者在登入後是否應該被重定向。
  /// 如果為 `true`，使用者將被重定向到另一個畫面。
  /// 如果為 `false`，使用者將留在當前畫面。
  /// 此函式是異步的，應該等待它完成登入過程後再進行進一步的操作。
  void login(bool redirect) async {
    GL_config.webUseRedirect = redirect;
    final result = await oauth.login();
    GL_access_token = result.toString();
    result.fold(
      (l) async {
        Utils.showError(context, l.toString());
      },
      (r) async {
        // 登入完成後，可用在r中取得使用者的資訊
        // 其中 r.idToken 是用來取得使用者資訊的 token
        if (r.idToken != null) {
          log('azure id token:' + (r.idToken ?? ''));
        }
        GL_id_token = r.idToken ?? '';
        if (GL_id_token != '') {
          Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute));
        } else {
          Utils.showError(context, "Microsoft Authentication Failed!");
        }
      },
    );

    // 這裡是登入成功後的提示訊息
    var _idToken = await oauth.getIdToken();
    if (_idToken != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('登入成功')));
    }
  }

  // // 其他的Case可能會使用到的，這個函式用來從 Microsoft Graph API 取得使用者的資訊
  // Future<MyUser?> fetchAzureUserDetails(accessToken) async {
  //   GL_access_token = accessToken;
  //   http.Response response;
  //   log(accessToken);
  //   response = await http.get(
  //     Uri.parse("https://graph.microsoft.com/v1.0/me"),
  //     headers: {"Authorization": "Bearer $accessToken"},
  //   );

  //   dynamic returnValue = json.decode(response.body);
  //   myUser = MyUser.fromJson(returnValue);
  //   log(returnValue.toString());
  //   return myUser;
  // }

  // 這個函式用來檢查是否有緩存的帳戶資訊
  Future<bool> has_Cached_Account_Information() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return hasCachedAccountInformation;
  }

  // 這個函式用來登出
  void logout() async {
    await oauth.logout();
    Utils.showMessage(context, 'Logged out');
  }
}
