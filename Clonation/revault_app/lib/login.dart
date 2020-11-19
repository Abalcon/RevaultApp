import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/signup.dart';
import 'emailVerify.dart';

// Login
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
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

  Future<http.Response> tryLogin(String id, String pw) async {
    var map = new Map<String, dynamic>();
    map['user_id'] = id;
    map['passwd'] = pw;
    
    http.Response response = await http.post(
      'https://ibsoft.site/revault/login',
      body: map,
    );

    if (response.statusCode == 200) {
      print(response.headers); // set-cookie: JSESSIONID=blahblah
      print(response.body); // string: "1" or "-1"
      return response;
    } else {
      throw Exception('오류가 발생했습니다. 다시 시도해주세요');
    }
  }

  // 2020-09-22 djkim: Navigation Refactor
  _letsSignUp(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((BuildContext context) => SignUp()), // ...to here.
      ),
    );
  }

  _forgotPassword(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((BuildContext context) => EmailVerify()), // ...to here.
      ),
    );
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
              // Start of Login Form
              Form(
                key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter your username',
                          labelText: 'Username'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter your password',
                          labelText: 'Password'
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
                            color: Colors.green,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.greenAccent,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var loginResponse = await tryLogin(_idController.text, _pwController.text);
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
                              "Login",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.grey,
                          textColor: Colors.white,
                          disabledColor: Colors.black,
                          disabledTextColor: Colors.grey,
                          padding: EdgeInsets.all(8.0),
                          splashColor: Colors.blueGrey,
                          onPressed: () => _forgotPassword(context),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )
                      )
                    ]
                )
              ),
              // End of Login Form
              divider,
              Text(
                'Login with Social Accounts',
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.blue,
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
                  child: Text(
                    "Login with Facebook",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              divider,
              Text(
                'Not a member yet?',
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.redAccent,
                  onPressed: () => _letsSignUp(context),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        )
      )
    );
  }

  
}