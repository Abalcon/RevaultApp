import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';
import 'resetPassword.dart';

// Reset Password - E-mail Verify
class EmailVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 50.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("계정찾기"),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: Color(0xFF80F208),
                    tabs: [
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("아이디",),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("비밀번호",),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget> [
              Center(child: FindUsername()),
              Center(child: EmailVerifyForm()),
            ],
          )
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class FindUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '본인인증을 통해 아이디(이메일) 확인 및'
          + '\n비밀번호를 변경하실 수 있습니다.'
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Colors.black,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(15.0),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/phoneverify',
                  //arguments: PhoneVerifyArguments('forgot', 'forgot'),
                );
              },
              child: Text(
                "본인인증하기",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          )
        ),
      ],
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
                            color: Color(0xFF80F208),
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
            ],
          ),
        )
      )
    );
  }

}