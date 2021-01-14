import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/common/simpleOtp.dart';

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
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _putOTPController = new TextEditingController();
  SimpleOtp otp = SimpleOtp();
  bool isCodeEnabled = false;
  int enteredOtp;

  _enableCode() {
    setState(() {
      isCodeEnabled = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey1,
          child: Column(
            children: [
              TextFormField(
                key: Key('phoneNumber'),
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '휴대폰 번호 입력: 010으로 시작',
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '전화번호를 입력하세요';
                  }

                  var result = int.tryParse(value);
                  if (result == null) {
                    return '전화번호 형식에 맞게 입력하세요';
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(20.0),
                    onPressed: () async {
                      if (_formKey1.currentState.validate()) {
                        otp.sendOtp(_phoneController.text.substring(1));
                        _enableCode();
                      }
                    },
                    child: Text(
                      "인증번호 받기",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Form(
          key: _formKey2,
          child: Column(
            children: [
              TextFormField(
                key: Key('phoneNumber'),
                controller: _putOTPController,
                enabled: isCodeEnabled,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '인증번호 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '인증번호를 입력하세요';
                  }

                  var result = int.tryParse(value);
                  if (result == null) {
                    return '인증번호 형식에 맞게 입력하세요';
                  }

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Color(0xFF80F208),
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(20.0),
                    onPressed: isCodeEnabled ? () async {
                      if (_formKey2.currentState.validate()) {
                        var result = otp.resultChecker(int.parse(_putOTPController.text));
                        if (result) {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('휴대폰 인증에 성공했습니다')));
                          //Navigator.pushReplacementNamed(context, '/changepassword');
                          return;
                        }

                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('휴대폰 인증에 실패했습니다. 다시 시도해 주세요')));
                      }
                    } : null,
                    child: Text(
                      "인증하기",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}