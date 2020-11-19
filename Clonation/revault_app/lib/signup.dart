import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

usernameValidation(String value) {
  RegExp regexp = RegExp(r"[^A-Za-z0-9.-_]");
  return regexp.hasMatch(value) || value.length < 3 || value.length > 16;
}

passwordValidation(String value) {
  var count = 0;
  if (value.length > 7) {
    RegExp digit = RegExp(r"\d");
    RegExp uppercase = RegExp(r"[A-Z]");
    RegExp lowercase = RegExp(r"[a-z]");
    RegExp special = RegExp(r"[*.!@#$%^&(){}\[\]:'<>,.?/~`_+-=|\\]");

    if (digit.hasMatch(value))
      count++;
    if (uppercase.hasMatch(value))
      count++;
    if (lowercase.hasMatch(value))
      count++;
    if (special.hasMatch(value))
      count++;
  }

  return count >= 3;
}

// Sign Up
class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SignUpForm(),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  SignUpFormState createState() {
    return SignUpFormState();
  }
}

class SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  static final storage = new FlutterSecureStorage();
  String currSession = "";
  String signupResult = "-1";

  Future<http.Response> trySignUp(String id, String pw, String email) async {
    http.Response response = await http.post(
      'https://ibsoft.site/revault/addUser',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'user_id': id,
        'passwd': pw,
        'email': email
      }),
    );

    if (response.statusCode == 201) {
      print(response.headers); // set-cookie: JSESSIONID=blahblah
      print(response.body); // string: "1" or "-1"
      return response;
    } else {
      print(response.headers);
      print(response.body);
      throw Exception('오류가 발생했습니다. 다시 시도해주세요');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _idController = new TextEditingController();
    TextEditingController _passController = new TextEditingController();
    TextEditingController _mailController = new TextEditingController();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _mailController,
              decoration: InputDecoration(
                icon: Icon(Icons.mail),
                hintText: 'Enter your E-mail address',
                labelText: 'E-mail'
              ),
              validator: (email) {
                if (email.isEmpty) {
                  return 'Please enter your E-mail address';
                }
                else if (!EmailValidator.validate(email)) {
                  return 'Invalid E-mail address';
                }
                return null;
              },
            ),
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
                else if (usernameValidation(value)) {
                  return 'Invalid username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passController,
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
                else if (!passwordValidation(value)) {
                  return 'Invalid password: 영소문자/영대문자/숫자/특수문자 중에\n3종류 이상을 포함하여 8글자 이상';
                }
                return null;
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Enter your password again',
                labelText: 'Password Confirm'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your password';
                }
                else if (value != _passController.text) {
                  return 'Password is not matching';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.label),
                hintText: 'Enter your name',
                labelText: 'Name'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                hintText: 'Enter your phone number',
                labelText: 'Phone'
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0
              ),
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
                      var signupResponse = await trySignUp(
                        _idController.text, _passController.text, _mailController.text);
                      setState(() {
                        signupResult = signupResponse.body;
                      });
                      if (signupResult == "-1") {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('회원가입에 실패했습니다. 아이디가 이미 등록되어있습니다')));
                        return;
                      }
                      
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('회원가입에 성공했습니다. REVAULT에 오신 것을 환영합니다!')));
                      await storage.write(
                        key: "session",
                        value: signupResponse.headers['set-cookie'].split(';')[0]
                      );

                      Navigator.pushReplacementNamed(context, '/auctionlist');
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 20.0)
                  ),
                ),
              )
            ),
          ]
      )
      )
    );
  }
}