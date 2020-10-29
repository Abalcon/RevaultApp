import 'package:flutter/material.dart';

// Change Password - After Verification
class ChangePassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("비밀번호 변경"),
      ),
      body: ChangePasswordForm()
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  @override
  ChangePasswordFormState createState() {
    return ChangePasswordFormState();
  }
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
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

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Start of password Change
              Form(
                key: _formKey1,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter your current password',
                          labelText: 'Current Password'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your currenct password';
                          }
                          else if (value != _passController.text) {
                            return 'Password is incorrect';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Enter your new password',
                          labelText: 'New Password'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your new password';
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
                          hintText: 'Enter your new password again',
                          labelText: 'Password Confirm'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your new password';
                          }
                          else if (value != _passController.text) {
                            return 'Password is not matching';
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
                            onPressed: () {
                              if (_formKey1.currentState.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Ready to Change password!')));
                              }
                            },
                            child: Text(
                              "Change Password",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              // End of password Change
            ],
          ),
        )
      )
    );
  }

}