import 'package:flutter/material.dart';
import 'package:test/constants.dart';
import 'package:test/route/route_constants.dart';
import 'dart:developer';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:http/http.dart' as http; // Add this dependency in pubspec.yaml
import 'dart:convert';
import 'package:test/models/my_user.dart';
import 'package:test/main.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  //const LoginScreen({Key? key},globalkey:GlobalKey ) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Config config;
  late AadOAuth oauth;
  int messageId = 0;
  MyUser? myUser;

  @override
  void initState() {
    super.initState();
    _loadEnv().then((value) => {
          config = Config(
            tenant: dotenv.env['azure_tenant_id']!,
            clientId: dotenv.env['azure_client_id']!,
            scope: dotenv.env['azure_aad_scope']!,
            redirectUri: dotenv.env['azure_redirect_uri']!,
            navigatorKey: navigatorKey,
          ),
          oauth = AadOAuth(config),
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // 這裡的代碼會在 widget 的第一幀渲染完成後執行
            _afterViewInit();
          }),
        });
  }

  void _afterViewInit() {
    // 這裡可以執行一些初始化的操作
    // 例如加載數據、獲取設備信息等
    // 這裡是一個示例，用來加載數據
    //Utils.showMessage(context, 'afterview', 'title_text');
    hasCachedAccountInformation().then((hasCache) async {
      if (hasCache) {
        var __token = await oauth.getIdToken();
        GL_id_token = __token ?? '';
        if (GL_id_token != '') {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome back!'),
            ),
          );
          Navigator.pushNamed(context, entryPointScreenRoute);
        }
      }
    });
  }

  Future<bool> _loadEnv() async {
    try {
      await dotenv.load(fileName: "assets/.env");
      return true;
    } catch (e) {
      Utils.showError(context, e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height / 2, // 設置圖片的高度為螢幕高度的三分之一
              child: Image.asset(
                "assets/images/security.jpeg",
                fit: BoxFit.cover,
                width: double.infinity, // 確保圖片寬度填滿
              ),
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
                      login(false);
                    },
                    child: const Text("Log in with Azure AD"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text("Open App Home"),
                    onPressed: () {
                      hasCachedAccountInformation().then((hasCache) async {
                        if (hasCache) {
                          Utils.showMessage_Future(context, 'Cache is available', 'Info');
                        } else {
                          Utils.showMessage_Future(context, 'Cache is not available', 'Warming');
                          // showError("No Cached Account Information");
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text("Open App Home(Test)"),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute));
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    child: const Text("notifications test"),
                    onPressed: () {
                      // 使用 flutter_local_notifications
                      messageId++;
                      Utils.showNotification(context, messageId, '即時股價', '挑空漲停（150）');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // void showError(dynamic ex) {
  //   showMessage(ex.toString());
  // }

  // void showMessage(String text) {
  //   var alert = AlertDialog(content: Text(text), actions: <Widget>[
  //     TextButton(
  //         child: const Text('Ok'),
  //         onPressed: () {
  //           // Navigator.pop(context);
  //         })
  //   ]);
  //   showDialog(context: context, builder: (BuildContext context) => alert);
  // }

  void login(bool redirect) async {
    config.webUseRedirect = redirect;
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

  Future azureSignInApi(bool redirect) async {
    final AadOAuth oauth = AadOAuth(config);
    config.webUseRedirect = redirect;
    final result = await oauth.login();
    result.fold(
      (l) {
        Utils.showMessage(context, "Microsoft Authentication Failed!", 'Login Fail');
      },
      (r) async {
        await fetchAzureUserDetails(r.accessToken);
      },
    );
  }

  Future<MyUser?> fetchAzureUserDetails(accessToken) async {
    GL_access_token = accessToken;
    http.Response response;
    log(accessToken);
    response = await http.get(
      Uri.parse("https://graph.microsoft.com/v1.0/me"),
      headers: {"Authorization": "Bearer $accessToken"},
    );

    dynamic returnValue = json.decode(response.body);
    myUser = MyUser.fromJson(returnValue);
    log(returnValue.toString());
    return myUser;
  }

  Future<bool> hasCachedAccountInformation() async {
    var _hasCache = false;
    try {
      _hasCache = await oauth.hasCachedAccountInformation;
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('HasCachedAccountInformation: $_hasCache'),
      //   ),
      // );
      return _hasCache;
    } catch (e) {
      Utils.showError(context, e);
      return false;
    }
  }
}
