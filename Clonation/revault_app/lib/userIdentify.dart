import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'common/common.dart';

class UserIdentify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String session = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("본인인증"),
      ),
      body: UserIdentifyDetail(
        session: session,
      ),
    );
  }
}

class UserIdentifyDetail extends StatefulWidget{
  final String session;

  UserIdentifyDetail({Key key, @required this.session}) : super(key: key);

  @override
  _UserIdentifyDetailState createState() => _UserIdentifyDetailState();
}

class _UserIdentifyDetailState extends State<UserIdentifyDetail> {
  WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://ibsoft.site/revault/ident/checkplus_main',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (webViewController) {
        _webViewController = webViewController;
      },
      onPageFinished: (String str) async {
        debugPrint(str); // Current URL
        if (str.contains('https://ibsoft.site/revault/ident/checkplus_success')) {
          var result = await _webViewController.evaluateJavascript(
            "document.getElementById('di_value').innerHTML");
          if (Platform.isAndroid)
            result = result.substring(1, result.length - 1);
          print(result);

          // DI로 계정 체크
          var verifyResult = await userVerify(widget.session, result);
          if (widget.session != null && verifyResult.userID != null) {
            // 첫 경매 참여 시나리오에서 중복 발견
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('이미 본인인증 정보가 등록된 계정이 있습니다. 해당 계정으로 로그인하여 경매에 참여하시기 바랍니다')));
            Navigator.pop(context);
            return;
          }
          else if (widget.session == null && verifyResult.userID != null) {
            // 계정 찾기 시나리오에서 맞는 계정 발견
            String resultText;
            switch (verifyResult.snsCode) {
              case 1:
                resultText = '해당 사용자는 페이스북 로그인으로 가입했고 페이스북 아이디는 ${verifyResult.userID}입니다';
                break;
              case 2:
                resultText = '해당 사용자는 카카오 로그인으로 가입했고 카카오 아이디는 ${verifyResult.userID}입니다';
                break;
              default:
                resultText = '해당 사용자의 아이디는 ${verifyResult.userID}입니다';
                break;
            }
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(resultText)));
            Navigator.pushReplacementNamed(
              context,
              '/useridentifyresult',
              arguments: UserIdentifyArguments(verifyResult.snsCode, verifyResult.userID),
            );
            return;
          }
          else if (widget.session == null && verifyResult.userID == null) {
            // 계정 찾기 시나리오에서 계정 발견 실패
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('해당하는 계정이 없습니다')));
            Navigator.pop(context);
            return;
          }
          
          // 첫 경매 참여 시나리오에서 본인인증 정보를 계정에 등록
          var registerResult = await trySaveVerification(widget.session, result);
          if (registerResult.statusCode == 200 && registerResult.body == "1") {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('본인인증에 성공했습니다. 이제 경매 참여를 진행할 수 있습니다')));

            Navigator.pop(context);
          }
          else if (registerResult.statusCode == 200 && registerResult.body == "-1") {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('본인인증 정보 등록에 실패했습니다. 다시 시도해주세요')));

            Navigator.pop(context);
          }
          else {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));

            Navigator.pop(context);
          }
        }
        else if (str.contains('https://ibsoft.site/revault/ident/checkplus_fail')) {
          ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('본인인증에 실패했습니다. 다시 시도해주세요')));

          Navigator.pop(context);
        }
      },
    );
  }
}