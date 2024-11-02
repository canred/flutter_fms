import 'package:flutter/material.dart';
import 'package:test/constants.dart';
import 'package:test/route/route_constants.dart';
// import 'components/login_form.dart';
import 'dart:developer';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http; // Add this dependency in pubspec.yaml
import 'dart:convert';
import 'package:test/models/my_user.dart';
import 'package:test/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  //const LoginScreen({Key? key},globalkey:GlobalKey ) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // var navigatorKey = GlobalKey<NavigatorState>();
  static final Config config = Config(
    tenant: '3e7e3a11-2a69-4cad-9463-ea92f2fed6c0',
    clientId: 'c6dcb0ea-1509-4d4a-9fe1-0df47e8bb707',
    scope: 'openid profile offline_access User.Read',
    //scope: 'User.Read',
    redirectUri: "msauth://com.vis.test/%2Frn0m6TJIR79gIT%2BHb%2FZVR1V3%2Bc%3D",
    // msauth://com.example/%2Frn0m6TJIR79gIT%2BHb%2FZVR1V3%2Bc%3D

    navigatorKey: navigatorKey,
    //loader: SizedBox(),
    // appBar: AppBar(
    //   title: Text('AAD OAuth Demo'),
    // ),
    // onPageFinished: (String url) {
    //   log('onPageFinished: $url');
    // },
  );
  final AadOAuth oauth = AadOAuth(config);
  MyUser? myUser;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // config = Config(
    //   tenant: '3e7e3a11-2a69-4cad-9463-ea92f2fed6c0',
    //   clientId: 'c6dcb0ea-1509-4d4a-9fe1-0df47e8bb707',
    //   scope: 'openid profile offline_access User.Read',
    //   redirectUri: 'msauth://com.vis.test/%2Frn0m6TJIR79gIT%2BHb%2FZVR1V3%2Bc%3D',
    //   navigatorKey: navigatorKey,
    //   //webUseRedirect: true,
    //   //loader: const SizedBox(),
    //   // appBar: AppBar(
    //   //   title: const Text('AAD OAuth Demo'),
    //   // ),
    //   onPageFinished: (String url) {
    //     final Uri uri = Uri.parse(url);
    //     final String? code = uri.queryParameters['code'];
    //     final String? session_state = uri.queryParameters['session_state'];
    //     log('code: $code, session_state: $session_state');
    //     log('onPageFinished: $url');
    //   },
    // );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image.asset(
            //   "assets/images/login_dark.png",
            //   fit: BoxFit.cover,
            // ),
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
                  // LogInForm(formKey: _formKey),
                  // Align(
                  //   child: TextButton(
                  //     child: const Text("Forgot password"),
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, passwordRecoveryScreenRoute);
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: size.height > 700 ? size.height * 0.02 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login(false);
                      //if (_formKey.currentState!.validate()) {
                      //Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute));
                      //}
                    },
                    child: const Text("Log in with Azure AD"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      GL_access_token = 'Canred Test';
                      Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute), arguments: GL_access_token);
                      // }
                    },
                    child: const Text("Open App Home"),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Don't have an account?"),
                  //     TextButton(
                  //       onPressed: () {
                  //         Navigator.pushNamed(context, signUpScreenRoute);
                  //       },
                  //       child: const Text("Sign up"),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showError(dynamic ex) {
    showMessage(ex.toString());
  }

  void showMessage(String text) {
    var alert = AlertDialog(content: Text(text), actions: <Widget>[
      TextButton(
          child: const Text('Ok'),
          onPressed: () {
            // Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  void login(bool redirect) async {
    config.webUseRedirect = redirect;
    final result = await oauth.login();
    GL_access_token = result.toString();
    result.fold(
      (l) => showError(l.toString()),
      (r) async => await fetchAzureUserDetails(r.accessToken).then((onValue) => {
            if (myUser != null)
              {
                Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute))
                // showMessage(onValue),
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => WelcomePage(user: myUser!),
                //   ),
                // ),
              }
            else
              {showError("Microsoft Authentication Failed!")}
          }),
      //(r) async => showMessage("Microsoft Authentication Success!"),
    );
    var accessToken = await oauth.getAccessToken();
    if (accessToken != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(accessToken)));
    }
  }

  Future azureSignInApi(bool redirect) async {
    final AadOAuth oauth = AadOAuth(config);

    config.webUseRedirect = redirect;
    final result = await oauth.login();

    result.fold(
      (l) => showError("Microsoft Authentication Failed!"),
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

  void hasCachedAccountInformation() async {
    var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('HasCachedAccountInformation: $hasCachedAccountInformation'),
      ),
    );
  }

  void logout() async {
    await oauth.logout();
    showMessage('Logged out');
  }
}
