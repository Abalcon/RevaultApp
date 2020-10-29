import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MySettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("환경설정"),
      ),
      body: MySettingsBody()
    );
  }
}

class MySettingsBody extends StatefulWidget {
  @override
  MySettingsBodyState createState() {
    return MySettingsBodyState();
  }
}

class MySettingsBodyState extends State<MySettingsBody> {
  bool isSwitched1 = true;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Divider(
              color: Colors.grey[250],
              thickness: 15,
              height: 15
            ),
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                color: Colors.white,
                textColor: Colors.grey[600],
                onPressed: () => Navigator.pushNamed(context, '/changepassword'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "비밀번호 변경",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                color: Colors.white,
                textColor: Colors.grey[600],
                onPressed: () => Navigator.pushNamed(context, '/changeaddress'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "배송지 변경",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                color: Colors.white,
                textColor: Colors.grey[600],
                onPressed: () => Navigator.pushNamed(context, '/languageselect'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Language Setting",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[250],
              thickness: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '경매 입찰가 변동시 알림',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      )
                    ),
                  ),
                  Switch(
                    value: isSwitched1,
                    onChanged: (value) {
                      setState(() {
                        isSwitched1 = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ]
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '누군가 내글에 댓글을 달았을 때 알림',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      )
                    ),
                  ),
                  Switch(
                    value: isSwitched2,
                    onChanged: (value) {
                      setState(() {
                        isSwitched2 = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ]
              ),
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '경매가 시작/종료되었을 때 알림',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      )
                    ),
                  ),
                  Switch(
                    value: isSwitched3,
                    onChanged: (value) {
                      setState(() {
                        isSwitched3 = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ]
              ),
            ),
            Divider(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100.0,
              padding: EdgeInsets.only(left: 10, top: 10),
              color: Colors.grey[300],
              child: RichText(
                text: TextSpan(
                  text: '회원탈퇴하기',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => {
                      // TODO: 회원 탈퇴 화면 만들기
                    }
                ),
              )
            )
          ],
        ),
      )
    );
  }
}