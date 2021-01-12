import 'package:flutter/material.dart';
import 'package:iamport_flutter/Iamport_certification.dart';
import 'package:iamport_flutter/model/certification_data.dart';
//import 'package:revault_app/common/aux.dart';

class PhoneVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final PhoneVerifyArguments purchaseInfo = ModalRoute.of(context).settings.arguments;
    return IamportCertification(
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/revault_square_logo.jpg'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: 'imp94921777',
      data: CertificationData.fromJson({
        'merchantUid': 'RV${DateTime.now().millisecondsSinceEpoch}',
        // 'company': 'Revault',
        // 'carrier': 'SKT',
        // 'name': '김덕주',
        // 'phone': '01031312806',
      }),
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/resetpassword',
          arguments: result,
        );
      },
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: Text("휴대폰 본인인증"),
    //   ),
    //   body: PhoneVerifyDetail(
    //     session: purchaseInfo.session,
    //     username: purchaseInfo.username,
    //   ),
    // );
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

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return IamportCertification(
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/revault_square_logo.jpg'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      userCode: 'Revault',
      data: CertificationData.fromJson({
        'merchantUid': 'RV${DateTime.now().millisecondsSinceEpoch}',
        'company': 'Revault',
        'carrier': 'SKT',
        'name': '김덕주',
        'phone': '01031312806',
      }),
      callback: (Map<String, String> result) {
        Navigator.pushReplacementNamed(
          context,
          '/resetpassword',
          arguments: result,
        );
      },
    );
  }
}