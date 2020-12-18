import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
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
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              divider,
              Text(
                'Login with Social Accounts',
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Color(0xFF1877F2),
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {
                    // TODO: Implement Facebook Login Attempt
                    ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Facebook Login Unimplemented')));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/facebook_login_icon.png',
                        //color: Color(0xFF1877F2),
                        width: 30.0,
                        fit: BoxFit.cover,
                      ),
                      VerticalDivider(width: 12.0),
                      Text(
                        "페이스북으로 로그인",
                        style: TextStyle(fontSize: 20.0),
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
                  onPressed: () {
                    // TODO: Implement Kakao Login Attempt
                    ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Kakao Login Unimplemented')));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/kakao_login_icon.png',
                        width: 30.0,
                        fit: BoxFit.cover,
                      ),
                      VerticalDivider(width: 12.0),
                      Text(
                        "카카오 계정으로 로그인",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
              ),
              divider,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '회원가입',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
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
                        fontSize: 16,
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
                        fontSize: 16,
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