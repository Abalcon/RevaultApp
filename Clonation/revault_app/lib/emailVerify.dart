import 'package:flutter/material.dart';
import 'package:revault_app/common/common.dart';

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
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "계정찾기",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 1,
                    labelColor: revaultBlack,
                    unselectedLabelColor: Colors.grey[400],
                    tabs: [
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: Text("아이디",),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
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
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        children: [
          Text(
            '본인인증을 통해 아이디(이메일) 확인 및'
            + '\n비밀번호를 변경하실 수 있습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0),
            child: SizedBox(
              width: double.infinity,
              child: FlatButton(
                shape: Border(),
                color: revaultBlack,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: revaultBlack,
                padding: EdgeInsets.all(16.0),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/useridentify',
                    arguments: null,
                  );
                },
                child: Text(
                  "본인인증하기",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ),
          Divider(height: 30.0),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9 - 20,
            ),
            child: Text(
              '본인인증 내역이 없어 계정을 찾을 수 없는 경우 고객센터(1544-1544)로 문의하시기 바랍니다.',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
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
  //final _formKey2 = GlobalKey<FormState>();
  TextEditingController _emailController = new TextEditingController();
  bool isCodeEnabled = false;

  final divider = Divider(
    color: Colors.grey,
    height: 20,
    thickness: 3,
    indent: 0,
    endIndent: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey1,
            child: Column(
              children: <Widget>[
                Text(
                  '본인인증을 통해 아이디(이메일) 확인 및'
                  + '\n비밀번호를 변경하실 수 있습니다.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: '아이디 / 이메일 주소 입력',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return '아이디 또는 이메일을 입력하세요';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FlatButton(
                      shape: Border(),
                      color: revaultBlack,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: revaultBlack,
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {
                        if (_formKey1.currentState.validate()) {
                          Navigator.pushNamed(
                            context,
                            '/useridentify',
                            arguments: null,
                          );
                        }
                      },
                      child: Text(
                        "본인인증하기",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ),
                Divider(height: 30.0),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9 - 20,
                  ),
                  child: Text(
                    '본인인증 내역이 없어 계정을 찾을 수 없는 경우 고객센터(1544-1544)로 문의하시기 바랍니다.',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ]
            )
          ),
        ],
      ),
    );
  }
}