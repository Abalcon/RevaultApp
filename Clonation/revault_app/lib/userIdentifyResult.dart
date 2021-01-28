import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';

class UserIdentifyResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserIdentifyArguments arguments = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("계정찾기 결과"),
      ),
      body: UserIdentifyResultDetail(
        snsCode: arguments.snsCode,
        userID: arguments.userID,
      )
    );
  }
}

class UserIdentifyResultDetail extends StatefulWidget {
  final int snsCode;
  final String userID;

  UserIdentifyResultDetail({Key key, @required this.snsCode,
    @required this.userID}) : super(key: key);

  @override
  UserIdentifyResultDetailState createState() {
    return UserIdentifyResultDetailState();
  }
}

class UserIdentifyResultDetailState extends State<UserIdentifyResultDetail> {

  String findUserResult() {
    switch (widget.snsCode) {
      case 1:
        return '해당 사용자는 페이스북 로그인으로 가입했고 페이스북 아이디는 ${widget.userID}입니다';
      case 2:
        return '해당 사용자는 카카오 로그인으로 가입했고 카카오 아이디는 ${widget.userID}입니다';
      default:
        return '해당 사용자의 아이디는 ${widget.userID}입니다';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
          child: Text(
            findUserResult(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        (widget.snsCode == 1) || (widget.snsCode == 2) ?
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Color(0xFF80F208),
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(20.0),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                );
              },
              child: Text(
                "로그인으로 돌아가기",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ) :
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              color: Color(0xFF80F208),
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(20.0),
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/passwordreset',
                  arguments: widget.userID,
                );
              },
              child: Text(
                "비밀번호 재설정",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}