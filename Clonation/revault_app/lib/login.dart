import 'package:flutter/material.dart';
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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

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
                          // TODO: Password validation with back-end
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
                              if (_formKey.currentState.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Login Success')));
                                //_moveTo(context, AuctionList());
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