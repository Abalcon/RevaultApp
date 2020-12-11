import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/userInfo.dart';

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
  SessionNamePair currUser;
  Future<UserInfo> currInfo;
  bool isSwitched1 = true;
  bool isSwitched2 = false;
  bool isSwitched3 = false;

  _checkUser() async {
    currUser = await isLogged();
    print(currUser);
    if (currUser.getName() == null) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('로그인 정보가 만료되었습니다. 다시 로그인하시기 바랍니다')));
      Navigator.pushReplacementNamed(context, '/login');
    }

    setState(() {
      currInfo = getInfo(currUser.getSession());
      currInfo.then((info) {
        isSwitched1 = (info.alarmPrice == null) ? true : info.alarmPrice;
        isSwitched2 = (info.alarmComment == null) ? true : info.alarmComment;
        isSwitched3 = (info.alarmStatus == null) ? true : info.alarmStatus;
      });
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currInfo,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              debugPrint("${snapshot.error}");
              return Text("${snapshot.error}");
            }
            var info = snapshot.data;

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
                      onPressed: () => Navigator.pushNamed(
                        context, '/changepassword',
                        arguments: currUser.getSession(),
                      ),
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
                      onPressed: () => Navigator.pushNamed(
                        context, '/changeaddress',
                        arguments: ReceiverArguments(
                          currUser.getSession(),
                          -1,
                          info.name,
                          info.phone,
                          info.address,
                        )
                      ),
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
                        onPressed: () async {
                          var changeResponse = await tryModifyUserAlarms(
                            currUser.getSession(), isSwitched1, isSwitched2, isSwitched3);

                          if (changeResponse.statusCode == 200 || changeResponse.statusCode == 201) {
                            if (changeResponse.body == "-1") {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('알림 설정 변경에 실패했습니다. 다시 시도해주세요')));
                              return;
                            }

                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('알림 설정 변경에 성공했습니다')));
                            Navigator.pop(context);
                          }
                          else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                          }
                        },
                        child: Text(
                          "알림 설정 저장하기",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    )
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
    );
  }
}