import 'package:flutter/material.dart';
import 'package:test/components/my_form/my_form_card.dart';
import 'package:test/models/my_form_model.dart';
import 'package:test/route/screen_export.dart';
import 'package:test/main.dart';
import '../../../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // 添加這行來導入 dart:convert 庫
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';

class MyRequestList extends StatefulWidget {
  const MyRequestList({super.key});
  @override
  _MyRequestListState createState() => _MyRequestListState();
}

class _MyRequestListState extends State<MyRequestList> {
  // 由於這個有使用者登入的功能，所以需要使用 Azure Active Directory (AAD) 的 OAuth 2.0 來進行登入
  late Config config;
  late AadOAuth oauth;

  @override
  void initState() {
    super.initState();
    // 讀取 .env 檔案中的設定
    Utils.loadEnv().then((value) => {
          config = Config(
            tenant: dotenv.env['azure_tenant_id']!,
            clientId: dotenv.env['azure_client_id']!,
            scope: dotenv.env['azure_aad_scope']!,
            redirectUri: dotenv.env['azure_redirect_uri']!,
            navigatorKey: navigatorKey,
          ),
          oauth = AadOAuth(config)
        });
  }

  Future<void> _callApi(BuildContext context) async {
    try {
      var API_IP = dotenv.env['api_validate_token_uri']!;
      final response = await http.get(
        Uri.parse(API_IP),
        headers: <String, String>{
          'Authorization': 'Bearer $GL_id_token',
        },
      );
      if (response.statusCode == 200) {
        Utils.showMessage(context, response.body, 'Reture Value');
        try {
          var jsonResponse = jsonDecode(response.body); // 將 response.body 轉換為 JSON 物件
          if (jsonResponse['error'] != null) {
            Utils.showError(context, jsonResponse['error']);
            Navigator.pushReplacementNamed(context, onbordingScreenRoute);

            return;
          } else if (jsonResponse['preferred_username'] != null) {
            Gl_user_name = jsonResponse['preferred_username'];
            Utils.showMessage(context, jsonResponse['preferred_username'] + '你好！', 'Welcome');
          }
        } catch (e) {
          Utils.showError(context, 'response.body 轉換為 JSON 物件失敗');
        }
      } else {
        Utils.showMessage(context, 'API呼叫失敗, 狀態碼: ${response.statusCode}', 'Error');
      }
    } catch (e) {
      Utils.showError(context, 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              SizedBox(
                width: 100, // 設置按鈕的寬度
                height: 30, // 設置按鈕的高度
                child: ElevatedButton(
                  onPressed: () {
                    //Utils.showError(context, GL_id_token);
                    if (GL_id_token == '') {
                      Utils.showError(context, '請先登入');
                      return;
                    }
                    Utils.showMessage(context, GL_id_token, 'Your ID Token');
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // 減少按鈕的內邊距
                      backgroundColor: Colors.green),
                  child: const Text("Show IdToken", style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12), // 設置按鈕之間的間隔
              SizedBox(
                width: 80, // 設置按鈕的寬度
                height: 30, // 設置按鈕的高度
                child: ElevatedButton(
                  onPressed: () {
                    if (GL_id_token == '') {
                      Utils.showError(context, '請先登入');
                      return;
                    } else {
                      _callApi(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // 減少按鈕的內邊距
                      backgroundColor: Colors.green),
                  child: const Text("Call API", style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 12), // 設置按鈕之間的間隔
              SizedBox(
                width: 80, // 設置按鈕的寬度
                height: 30, // 設置按鈕的高度
                child: ElevatedButton(
                  onPressed: () async {
                    await oauth.logout();
                    Navigator.pushReplacementNamed(context, onbordingScreenRoute);
                    // Utils.showMessage(context, 'Logged out', 'Logout');
                    // Navigator.pushNamedAndRemoveUntil(context, entryPointScreenRoute, ModalRoute.withName(logInScreenRoute));
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0), // 減少按鈕的內邊距
                      backgroundColor: const Color.fromARGB(255, 235, 104, 104)),
                  child: const Text("Logout", style: TextStyle(fontSize: 12)),
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            "我的簽核單",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        // While loading use 👇
        // const ProductsSkelton(),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // Find demoPopularProducts on models/ProductModel.dart
            itemCount: demoFlashMyForm.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == demoFlashMyForm.length - 1 ? defaultPadding : 0,
              ),
              child: MyFormCard(
                image: demoFlashMyForm[index].image,
                brandName: demoFlashMyForm[index].brandName,
                title: demoFlashMyForm[index].title,
                subTitle: demoFlashMyForm[index].subTitle,
                urgentLevel: demoFlashMyForm[index].urgentLevel,
                urgentLevelText: demoFlashMyForm[index].urgentLevelText,
                press: () {
                  Navigator.pushNamed(context, productDetailsScreenRoute, arguments: index.isEven);
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
