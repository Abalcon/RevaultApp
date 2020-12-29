import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:revault_app/common/aux.dart';

// Login
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("로그인"),
      ),
      body: LoginForm()
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

  static final storage = new FlutterSecureStorage();
  String currSession = "";
  String loginResult = "-1";

  Future<http.Response> tryLogin(String id, String pw, String token) async {
    debugPrint(token);
    var map = new Map<String, dynamic>();
    map['user_id'] = id;
    map['passwd'] = pw;
    map['user_token'] = token;
    
    http.Response response = await http.post(
      'https://ibsoft.site/revault/login',
      body: map,
    );

    print(response.headers); // set-cookie: JSESSIONID=blahblah
    print(response.body); // string: "1" or "-1"
    if (response.statusCode == 200) {
      return response;
    } else {

      throw Exception('오류가 발생했습니다. 다시 시도해주세요');
    }
  }

  dynamic getFacebookInfo(String token) async {
    final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,email&access_token=$token'
    );
    // {name: your_name, email: your@email.com id: your_id}
    return jsonDecode(graphResponse.body);
  }

  Future<void> _showEnterPhoneModal(String session) async {
    TextEditingController _phoneController = new TextEditingController();

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
            child: Column(
              children: [
                Icon(Icons.verified, size: 100, color: Colors.black),
                Text(
                  'Revault에 오신 것을 환영합니다!\n',
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.bold
                  )
                ),
                Text(
                  '기본 배송지에 들어갈 전화번호를 입력하시기 바랍니다\n나중에 환경설정에서 입력하거나 변경할 수 있습니다',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  )
                ),
                Divider(
                  indent: 50,
                  endIndent: 50,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: '전화번호 입력',
                    border: inputBorder,
                    focusedBorder: inputBorder,
                  ),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        //Navigator.pushReplacementNamed(context, '/auctionList');
                        Navigator.pop(context);
                      },
                      child: Text(
                        '건너뛰기',
                        style: TextStyle(fontSize: 16.0)
                      ),
                    ),
                    VerticalDivider(),
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
                        if (_phoneController.text != '') {
                          http.Response response = await tryModifyUserPhone(
                            currSession, _phoneController.text);
                          if (response.statusCode == 200 && response.body == "1") {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('전화번호가 등록되었습니다')));
                            //Navigator.pushReplacementNamed(context, '/auctionList');
                            Navigator.pop(context);
                          }
                          else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                          }
                        }
                      },
                      child: Text(
                        '등록하기',
                        style: TextStyle(fontSize: 16.0)
                      ),
                    ),
                  ],
                ),
              ]
            ),
          ),
        );
      }
    );
  }

  bool _isKakaoTalkInstalled = false;
  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('Kakao Install: $installed');

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  Future<AccessTokenResponse> _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);
      print(token);
      //Navigator.pushReplacementNamed(context, '/auctionlist');
      return token;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AccessTokenResponse> _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      var response = await _issueAccessToken(code);
      return response;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<AccessTokenResponse> _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      var response = await _issueAccessToken(code);
      return response;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initKakaoTalkInstalled();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _idController = new TextEditingController();
    TextEditingController _pwController = new TextEditingController();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          //icon: Icon(Icons.person),
                          //hintText: 'Enter your username',
                          labelText: '아이디 입력',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      Divider(color: Colors.white),
                      TextFormField(
                        controller: _pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          //icon: Icon(Icons.lock),
                          //hintText: 'Enter your password',
                          labelText: '비밀번호 입력',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.black,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var fcmToken = await storage.read(key: "fcm");
                                var loginResponse = await tryLogin(_idController.text, _pwController.text, fcmToken);
                                setState(() {
                                  loginResult = loginResponse.body;
                                });
                                if(loginResult == "-1") {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('아이디 또는 비밀번호가 일치하지 않습니다')));
                                  return;
                                }

                                await storage.write(
                                  key: "session",
                                  value: loginResponse.headers['set-cookie'].split(';')[0]
                                );

                                Navigator.pushReplacementNamed(context, '/auctionlist');
                              }
                            },
                            child: Text(
                              "로그인",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              // divider,
              // Text(
              //   'Login with Social Accounts',
              // ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Color(0xFF1877F2),
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    final facebookLogin = FacebookLogin();
                    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

                    final isLogged = await facebookLogin.isLoggedIn;
                    if (isLogged) {
                      final currToken = await facebookLogin.currentAccessToken;
                      final userInfo = await getFacebookInfo(currToken.token);
                      print(userInfo);
                      // 여기는 로그인만
                      var fcmToken = await storage.read(key: "fcm");
                      var loginResponse = await tryLogin(userInfo['email'], userInfo['id'], fcmToken);
                      setState(() {
                        loginResult = loginResponse.body;
                      });
                      if(loginResult == "-1") {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('아이디 또는 비밀번호가 일치하지 않습니다')));
                        return;
                      }

                      await storage.write(
                        key: "session",
                        value: loginResponse.headers['set-cookie'].split(';')[0]
                      );
                      
                      Navigator.pushReplacementNamed(context, '/auctionlist');
                      return;
                    }

                    final result = await facebookLogin.logIn(['email']);
                    // accessToken errorMessage status
                    switch (result.status) {
                      case FacebookLoginStatus.loggedIn:
                        final token = result.accessToken;
                        final userInfo = await getFacebookInfo(token.token);
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('페이스북 로그인 성공')));
                        print(userInfo);
                        
                        final signupResult = await trySignUp(
                          userInfo['email'], userInfo['id'], userInfo['email'], '');
                        String session = signupResult.headers['set-cookie'].split(';')[0];
                        await storage.write(
                          key: "session",
                          value: session
                        );

                        if (signupResult.statusCode == 200 || signupResult.statusCode == 200) {
                          // 이미 페이스북 계정으로 가입했을 경우
                          if (signupResult.body == "-1") {
                            var fcmToken = await storage.read(key: "fcm");
                            var loginResponse = await tryLogin(userInfo['email'], userInfo['id'], fcmToken);
                            setState(() {
                              loginResult = loginResponse.body;
                            });
                            if(loginResult == "-1") {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('아이디 또는 비밀번호가 일치하지 않습니다')));
                              return;
                            }

                            await storage.write(
                              key: "session",
                              value: loginResponse.headers['set-cookie'].split(';')[0]
                            );
                            
                            Navigator.pushReplacementNamed(context, '/auctionlist');
                            return;
                          }

                          // 신규 가입했을 경우
                          await _showEnterPhoneModal(session);
                          Navigator.pushReplacementNamed(context, '/auctionlist');
                        }
                        break;
                      case FacebookLoginStatus.cancelledByUser:
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('페이스북 로그인 취소')));
                        break;
                      case FacebookLoginStatus.error:
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('페이스북 로그인 실패: ${result.errorMessage}')));
                        break;
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/facebook_login_icon.png',
                        //color: Color(0xFF1877F2),
                        width: 28.0,
                        fit: BoxFit.cover,
                      ),
                      VerticalDivider(width: 12.0),
                      Text(
                        "페이스북으로 로그인",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ]
                  ),
                ),
              ),
              Divider(color: Colors.white),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Color(0xFFFEE500),
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () async {
                    // TODO: Implement Kakao Login Attempt
                    try {
                      if (_isKakaoTalkInstalled) {
                        var token = await AccessTokenStore.instance.fromStore();
                        if (token.refreshToken == null) {
                          var result = await _loginWithTalk();
                          //print(result.toJson());
                          print(result.accessToken);
                        }
                      }
                      else {
                        //AuthCodeClient.instance.retrieveAuthCode();
                        var token = await AccessTokenStore.instance.fromStore();
                        if (token.refreshToken == null) {
                          var result = await _loginWithKakao();
                          //print(result.toJson());
                          print(result.accessToken);
                        }
                      }
                      User currUser = await UserApi.instance.me();
                      print(currUser.toString());
                      var currUserJson = currUser.toJson();
                      String email = currUserJson['kakao_account']['email'];
                      String id = currUserJson['id'].toString();

                      final signupResult = await trySignUp(
                        email, id, email, '');
                        String session = signupResult.headers['set-cookie'].split(';')[0];
                        await storage.write(
                          key: "session",
                          value: session
                        );

                      if (signupResult.statusCode == 200 || signupResult.statusCode == 200) {
                        // 이미 카카오 계정으로 가입했을 경우
                        if (signupResult.body == "-1") {
                          var fcmToken = await storage.read(key: "fcm");
                          var loginResponse = await tryLogin(email, id, fcmToken);
                          setState(() {
                            loginResult = loginResponse.body;
                          });
                          if(loginResult == "-1") {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('아이디 또는 비밀번호가 일치하지 않습니다')));
                            return;
                          }

                          await storage.write(
                            key: "session",
                            value: loginResponse.headers['set-cookie'].split(';')[0]
                          );
                          
                          Navigator.pushReplacementNamed(context, '/auctionlist');
                          return;
                        }

                        // 신규 가입했을 경우
                        await _showEnterPhoneModal(session);
                        Navigator.pushReplacementNamed(context, '/auctionlist');
                        return;
                      }

                      throw Exception('서비스 로그인에 실패했습니다. 다시 시도해주세요');
                    }
                    catch (e) {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('카카오 로그인 실패: $e')));
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/kakao_login_icon.png',
                        width: 28.0,
                        fit: BoxFit.cover,
                      ),
                      VerticalDivider(width: 12.0),
                      Text(
                        "카카오 계정으로 로그인",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '회원가입',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/signup')
                    ),
                  ),
                  VerticalDivider(thickness: 5, color: Colors.grey,),
                  RichText(
                    text: TextSpan(
                      text: '계정찾기',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/verifyemail')
                    ),
                  ),
                  VerticalDivider(thickness: 5, color: Colors.grey,),
                  RichText(
                    text: TextSpan(
                      text: '비밀번호 재설정',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/verifyemail')
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}