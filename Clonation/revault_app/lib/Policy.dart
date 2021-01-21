import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("사업자 정보 확인"),
      ),
      body: PolicyDetail(),
    );
  }
}

class PolicyDetail extends StatefulWidget{

  @override
  _PolicyDetailState createState() => _PolicyDetailState();
}

class _PolicyDetailState extends State<PolicyDetail> {

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: 'https://www.ftc.go.kr/bizCommPop.do?wrkr_no=1508601889',
    );
  }
}