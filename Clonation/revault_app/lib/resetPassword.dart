import 'package:flutter/material.dart';
import 'package:revault_app/common/common.dart';

// Reset Password - After Verification
class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String userID = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "비밀번호 재설정",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
      ),
      body: ResetPasswordForm(userID: userID),
      backgroundColor: Colors.white,
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  final String userID;
  ResetPasswordForm({Key key, @required this.userID}) : super(key: key);

  @override
  ResetPasswordFormState createState() {
    return ResetPasswordFormState();
  }
}

class ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey1 = GlobalKey<FormState>();

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

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

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 0),
          child: Form(
            key: _formKey1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    '새 비밀번호 입력',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    )
                  ),
                ),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '영소문자/영대문자/숫자/특수문자 3종류 이상 포함하여 8글자 이상',
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '새로운 비밀번호를 입력하세요';
                    }
                    else if (!passwordValidation(value)) {
                      return '사용할 수 없는 비밀번호: 영소문자/영대문자/숫자/특수문자 중에\n3종류 이상을 포함하여 8글자 이상';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 5),
                  child: Text(
                    '새 비밀번호 확인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '새 비밀번호 확인',
                    border: inputBorder,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return '새로운 비밀번호를 입력하세요';
                    }
                    else if (value != _passController.text) {
                      return '비밀번호가 일치하지 않습니다';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      shape: Border(),
                      color: revaultGreen,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: revaultBlack,
                      padding: EdgeInsets.all(16.0),
                      splashColor: Colors.greenAccent,
                      onPressed: () async {
                        if (_formKey1.currentState.validate()) {
                          var resetResponse = await tryResetUserPassword(
                            widget.userID, _passController.text);

                          if (resetResponse.statusCode == 200 || resetResponse.statusCode == 201) {
                            if (resetResponse.body == "-1") {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('비밀번호 재설정에 실패했습니다. 다시 시도해주세요')));
                              return;
                            }

                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('비밀번호 재설정에 성공했습니다')));
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                          else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                          }
                        }
                      },
                      child: Text(
                        "비밀번호 재설정",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

}