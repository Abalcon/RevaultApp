import 'dart:convert';

import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';

class PhoneVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PhoneVerifyArguments purchaseInfo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("휴대폰 본인인증"),
      ),
      body: PhoneVerifyDetail(
        session: purchaseInfo.session,
        username: purchaseInfo.username,
      ),
    );
  }
}

class PhoneVerifyDetail extends StatefulWidget {
  final String session;
  final String username;

  PhoneVerifyDetail({Key key, @required this.session,
    @required this.username}) : super(key: key);

  @override
  PhoneVerifyDetailState createState() {
    return PhoneVerifyDetailState();
  }
}

class PhoneVerifyDetailState extends State<PhoneVerifyDetail> {
  
  Widget billingResultBody(int result, String value) {
    if (result == 200) {
      switch (value) {
        case "1":
          return Column(
            children: [
              Icon(Icons.verified, size: 100, color: Color(0xFF80F208)),
              Text(
                '결제가 완료되었습니다!',
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                )
              ),
              Divider(
                indent: 50,
                endIndent: 50,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)
                ),
                color: Colors.black,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 16.0)
                ),
              ),
            ]
          );
        case "-1":
          return Column(
            children: [
              Icon(Icons.warning, size: 100, color: Colors.red),
              Text(
                '결제가 이루어지지 않았습니다. 다시 시도해주세요',
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                )
              ),
              Divider(
                indent: 50,
                endIndent: 50,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)
                ),
                color: Colors.black,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '돌아가기',
                  style: TextStyle(fontSize: 16.0)
                ),
              ),
            ]
          );
        case "-2":
          return Column(
            children: [
              Icon(Icons.warning, size: 100, color: Colors.yellow),
              Text(
                '결제가 완료되었으나 완납이 되지 않았습니다. 고객센터에 문의하시기 바랍니다',
                style: TextStyle(
                  fontSize: 22, 
                  fontWeight: FontWeight.bold
                )
              ),
              Divider(
                indent: 50,
                endIndent: 50,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)
                ),
                color: Colors.black,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 16.0)
                ),
              ),
            ]
          );
        default:
          throw Exception('서버로부터 비정상적인 값이 들어왔습니다');
      }
    }

    return Column(
      children: [
        Icon(Icons.warning, size: 100, color: Colors.red),
        Text(
          '결제 확인 과정에서 오류가 발생했습니다\n',
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold
          )
        ),
        Divider(
          indent: 50,
          endIndent: 50,
        ),
        RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.black)
          ),
          color: Colors.black,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: Colors.transparent,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text(
            '다시 시도',
            style: TextStyle(fontSize: 16.0)
          ),
        ),
      ],
    );
  }


  Future<void> _showBillingResult(int result, String value) async {
    return showModalBottomSheet<void>(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.only(
            top: 10
          ),
          child: Center(
            child: billingResultBody(result, value),
          ),
        );
      }
    );
  }

  Future<void> verifyBilling(String json) async {
    Map<String, dynamic> result = jsonDecode(json);
    String receiptID = result['receipt_id'];
    var response = await tryCheckBilling(widget.session, 1, receiptID);

    if (response.statusCode == 200) {
      await _showBillingResult(response.statusCode, response.body);
    }
    else {
      await _showBillingResult(response.statusCode, "");
      verifyBilling(json);
    }
  }

  void goBootpayRequest(BuildContext context) async {
    Payload payload = Payload();
    payload.androidApplicationId = '5ff40d4b5b294800202a0e49';
    payload.iosApplicationId = '5ff40d4b5b294800202a0e4a';
    
    payload.pg = 'danal';
    payload.method = 'auth';
    payload.orderId = "RV${DateTime.now().millisecondsSinceEpoch.toString()}";

    Extra extra = Extra();
    extra.appScheme = 'bootpaySample';

    BootpayApi.request(
      context,
      payload,
      extra: extra,
      onDone: (String json) async {
        print('onDone: $json');
        // TODO: 본인인증 검증 요청 보내기
        await verifyBilling(json);
        Navigator.pop(context);
      },
      onReady: (String json) {
        //flutter는 가상계좌가 발급되었을때  onReady가 호출되지 않는다. onDone에서 처리해주어야 한다.
        print('onReady: $json');
      },
      onCancel: (String json) {
        print('onCancel: $json');
      },
      onError: (String json) {
        print('onError: $json');
      },
    );
  }


  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          goBootpayRequest(context);
        },
        child: Text("부트페이 결제요청"),
      ),
    );
  }
}