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
  String findUserResult;
  String foundUserID;
  bool isSNS;

  _enableCode() {
    setState(() {
      isCodeEnabled = true;
    });
  }

  Widget showFindUserResult() {
    if (findUserResult == null) return Text('');

    return Padding(
      padding: EdgeInsets.only(
        bottom: 10.0,
      ),
      child: Column(
        children: [
          Text(
            findUserResult,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          isSNS ? Text('') :
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Color(0xFF80F208),
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/passwordreset',
                      arguments: foundUserID,
                    );
                  },
                  child: Text(
                    "비밀번호 재설정",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
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
                          var otpResult = otp.resultChecker(int.parse(_putOTPController.text));
                          if (otpResult) {
                            var userResult = await findUserInfo(_phoneController.text);
                            if (userResult.userID == null) {
                              setState(() {
                                findUserResult = '해당 번호를 가진 사용자가 없습니다';
                              });
                              return;
                            }

                            switch (userResult.snsCode) {
                              case 1:
                                setState(() {
                                  findUserResult = '해당 사용자는 페이스북 로그인으로 가입했고 페이스북 아이디는 ${userResult.userID}입니다';
                                  isSNS = true;
                                });
                                break;
                              case 2:
                                setState(() {
                                  findUserResult = '해당 사용자는 카카오 로그인으로 가입했고 카카오 아이디는 ${userResult.userID}입니다';
                                  isSNS = true;
                                });
                                break;
                              default:
                                setState(() {
                                  findUserResult = '해당 사용자의 아이디는 ${userResult.userID}입니다';
                                  foundUserID = userResult.userID;
                                  isSNS = false;
                                });
                                break;
                            }

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
          showFindUserResult(),
          Divider(
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}