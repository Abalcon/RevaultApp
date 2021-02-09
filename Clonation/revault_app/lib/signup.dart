import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
    RegExp special = RegExp(r"[*.!@#$%^&(){}\[\]:'<>,.?/~`_+=|\\-]");

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("회원가입"),
      ),
      body: SignUpForm(),
      backgroundColor: Colors.white,
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
  TextEditingController _phoneController = new TextEditingController();

  File selectedImage;
  Widget currentProfile() {
    if (selectedImage == null) {
      return GestureDetector(
        onTap: () async {
          var result = await Navigator.pushNamed(context, '/addprofile');
          if (result != null) {
            setState(() {
              selectedImage = result;
            });
          }
        },
        child: Container(
          width: 110.0,
          height: 110.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: revaultGreen,
              width: 2, 
            ),
          ),
          child: CircleAvatar(
            radius: 55.0,
            child: Icon(
              Icons.camera_alt_outlined,
              size: 50.0,
              color: revaultGreen,
            ),
            backgroundColor: Colors.white,
            //foregroundColor: revaultGreen,
          ),
        ),
      );
    }

    List<int> imageBytes = selectedImage.readAsBytesSync();
    String base64 = base64Encode(imageBytes);
    Uint8List bytes = base64Decode(base64);

    return Container(
      width: 110.0,
      height: 110.0,
      decoration: BoxDecoration(
        color: revaultGreen,
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: <Widget>[
              currentProfile(),
              Divider(color: Colors.transparent),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _idController,
                      decoration: InputDecoration(
                        hintText: '아이디 입력',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        enabledBorder: signUpBorder,  
                        focusedBorder: signUpBorder,
                        border: signUpBorder
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '아이디를 입력하세요';
                        }
                        else if (usernameValidation(value)) {
                          return '사용할 수 없는 아이디입니다';
                        }
                        return null;
                      },
                    ),
                    Divider(color: Colors.white, height: 12,),
                    TextFormField(
                      controller: _mailController,
                      decoration: InputDecoration(
                        hintText: '이메일 주소 입력',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        enabledBorder: signUpBorder,  
                        focusedBorder: signUpBorder,
                        border: signUpBorder
                      ),
                      validator: (email) {
                        if (email.isEmpty) {
                          return '이메일 주소를 입력하세요';
                        }
                        else if (!EmailValidator.validate(email)) {
                          return '이메일 주소 형식에 맞지 않습니다';
                        }
                        return null;
                      },
                    ),
                    Divider(color: Colors.white, height: 12,),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: '전화번호 입력',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        enabledBorder: signUpBorder,  
                        focusedBorder: signUpBorder,
                        border: signUpBorder
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return '전화번호를 입력하세요';
                        }
                        return null;
                      },
                    ),
                    Divider(color: Colors.white, height: 12,),
                    TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호 입력',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        enabledBorder: signUpBorder,  
                        focusedBorder: signUpBorder,
                        border: signUpBorder
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        else if (!passwordValidation(value)) {
                          return '사용할 수 없는 비밀번호: 영소문자/영대문자/숫자/특수문자 중에\n3종류 이상을 포함하여 8글자 이상';
                        }
                        return null;
                      },
                    ),
                    Divider(color: Colors.white, height: 12,),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: '비밀번호 확인',
                        hintStyle: TextStyle(
                          color: Color(0xFFBDBDBD),
                        ),
                        enabledBorder: signUpBorder,  
                        focusedBorder: signUpBorder,
                        border: signUpBorder
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return '비밀번호를 입력하세요';
                        }
                        else if (value != _passController.text) {
                          return '비밀번호가 일치하지 않습니다';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Color(0xFF828282),
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: '회원가입하면 ',
                      ),
                      TextSpan(
                        text: '이용약관',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextSpan(
                        text: ' 및 ',
                      ),
                      TextSpan(
                        text: '개인정보처리방침',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      // TextSpan(
                      //   text: ', and ',
                      // ),
                      // TextSpan(
                      //   text: 'Revault Account Agreement',
                      //   style: TextStyle(
                      //     color: Colors.red,
                      //   ),
                      // ),
                      TextSpan(
                        text: '에 동의하는 것으로 간주됩니다.',
                      ),
                    ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    shape: Border(),
                    color: revaultBlack,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: revaultBlack,
                    padding: EdgeInsets.all(20),
                    splashColor: Colors.greenAccent,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        var signupResponse = await trySignUp(
                          _idController.text, _passController.text, _mailController.text, _phoneController.text);

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
                      '가입하기',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
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