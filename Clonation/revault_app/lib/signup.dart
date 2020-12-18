import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/common/aux.dart';

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
  TextEditingController _idController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _mailController = new TextEditingController();

  File selectedImage;
  Widget currentProfile() {
    if (selectedImage == null) {
      return Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 60.0,
          child: Icon(
            Icons.camera_alt_outlined,
            size: 60.0,
          ),
          foregroundColor: Colors.green,
        ),
      );
    }

    List<int> imageBytes = selectedImage.readAsBytesSync();
    String base64 = base64Encode(imageBytes);
    Uint8List bytes = base64Decode(base64);

    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 60.0,
        backgroundImage: MemoryImage(bytes),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  static final storage = new FlutterSecureStorage();

  Future<http.Response> trySignUp(String id, String pw, String email) async {
    var map = new Map<String, dynamic>();
    map['user_id'] = id;
    map['passwd'] = pw;
    map['email'] = email;

    http.Response response = await http.post(
      'https://ibsoft.site/revault/addUser',
      body: map,
    );

    print(response.headers); // set-cookie: JSESSIONID=blahblah
    print(response.body); // string: "1" or "-1"
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  currentProfile(),
                  Container(
                    width: 120.0,
                    height: 120.0,
                    color: Colors.transparent,
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle
                      ),
                      width: 30.0,
                      height: 30.0,
                      child: FloatingActionButton(
                        onPressed: () async {
                          var result = await Navigator.pushNamed(context, '/addprofile');
                          if (result != null) {
                            setState(() {
                              selectedImage = result;
                            });
                          }
                        },
                        backgroundColor: Colors.black,
                        child: Icon(Icons.photo_camera_outlined)
                      )
                    ),
                  ),
                ]
              ),
              Divider(color: Colors.transparent),
              TextFormField(
                controller: _mailController,
                decoration: InputDecoration(
                  labelText: '이메일 주소 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
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
              Divider(color: Colors.white),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
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
              Divider(color: Colors.white),
              TextFormField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
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
              Divider(color: Colors.white),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  border: inputBorder,
                  focusedBorder: inputBorder,
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
              Divider(color: Colors.white),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '이름 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              Divider(color: Colors.white),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '전화번호 입력',
                  border: inputBorder,
                  focusedBorder: inputBorder,
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

                        if ((signupResponse.statusCode == 200 || signupResponse.statusCode == 201)
                          && (signupResponse.body == "-1" || signupResponse.body == "-2")) {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('회원가입에 실패했습니다. 아이디가 이미 등록되어있습니다')));
                          return;
                        }

                        if (signupResponse.statusCode != 200 && signupResponse.statusCode != 201) {
                          ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                        }
                        
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('회원가입에 성공했습니다. REVAULT에 오신 것을 환영합니다!')));
                        String session = signupResponse.headers['set-cookie'].split(';')[0];
                        await storage.write(
                          key: "session",
                          value: session
                        );

                        if (selectedImage != null)
                          await tryModifyUserProfile(session, selectedImage);

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
      )
    );
  }
}