import 'package:flutter/material.dart';

// Reset Password - After Verification
class ResetPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: ResetPasswordForm()
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  @override
  ResetPasswordFormState createState() {
    return ResetPasswordFormState();
  }
}

class ResetPasswordFormState extends State<ResetPasswordForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey1 = GlobalKey<FormState>();

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

  // _letsReset(context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: ((BuildContext context) => ResetPassword()), // ...to here.
  //     ),
  //   );
  // }

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
              // Start of password reset
              Form(
                key: _formKey1,
                  child: Column(
                    children: <Widget>[
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
                                // If the form is valid, display a Snackbar.
                                Scaffold.of(context)
                                    .showSnackBar(SnackBar(content: Text('Ready to reset password!')));
                              }
                            },
                            child: Text(
                              "Reset Password",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              // End of password reset
            ],
          ),
        )
      )
    );
  }

}