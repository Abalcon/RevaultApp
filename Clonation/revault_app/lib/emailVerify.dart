import 'package:flutter/material.dart';
import 'resetPassword.dart';

// Reset Password - E-mail Verify
class EmailVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("E-mail Verification"),
      ),
      body: EmailVerifyForm()
    );
  }
}

class EmailVerifyForm extends StatefulWidget {
  @override
  EmailVerifyFormState createState() {
    return EmailVerifyFormState();
  }
}

class EmailVerifyFormState extends State<EmailVerifyForm> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool isCodeEnabled = false;

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

  _enableCode() {
    setState(() => isCodeEnabled = true);
  }

  _letsReset(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((BuildContext context) => ResetPassword()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Start of E-mail input Form
              Form(
                key: _formKey1,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.mail),
                          hintText: 'Enter your e-mail address',
                          labelText: 'E-mail'
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your username';
                          }
                          // TODO: 이메일이 등록되어있는지 확인하기
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
                                _enableCode();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Flying Confirmation Code')));
                              }
                            },
                            child: Text(
                              "Send Confirmation Code",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              // End of E-mail input
              divider,
              Text(
                'Confirmation Code',
              ),
              Form(
                key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline),
                          hintText: 'Enter your confirmation code',
                          labelText: 'Confirmation Code'
                        ),
                        enabled: isCodeEnabled,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your confirmation code';
                          }
                          // TODO: 인증 코드가 맞는지 확인하기
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.blueAccent,
                            
                            onPressed: isCodeEnabled ? () {
                              if (_formKey2.currentState.validate()) {
                                _letsReset(context);
                              }
                            } : null,
                            child: Text(
                              "Verify Code",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
              // End of confirmation code input
            ],
          ),
        )
      )
    );
  }

}