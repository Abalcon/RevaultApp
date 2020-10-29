import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
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
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
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