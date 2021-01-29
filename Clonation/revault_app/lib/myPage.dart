import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:revault_app/auctionResult.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/userInfo.dart';

List<AuctionResult> parseWinningList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionResult>((json) => AuctionResult.fromJson(json)).toList();
}

Future<List<AuctionResult>> fetchWinningList(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionResultList',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    if (response.body == "")
      return [];
    return compute(parseWinningList, response.body);
  }

  return [];
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "마이페이지",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyPageDetails(),
    );
  }
}

class MyPageDetails extends StatefulWidget {

  @override
  MyPageDetailsState createState() => MyPageDetailsState();
}

class MyPageDetailsState extends State<MyPageDetails> {
  SessionNamePair currUser;
  Future<UserInfo> currInfo;
  Future<List<AuctionResult>> winningList;

  _checkUser() async {
    currUser = await isLogged();
    print(currUser);
    if (currUser.getName() == null) {
      ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('로그인 정보가 만료되었습니다. 다시 로그인하시기 바랍니다')));
      Navigator.pushReplacementNamed(context, '/login');
    }
    else {
      setState(() {
        currInfo = getInfo(currUser.getSession());
        winningList = fetchWinningList(currUser.getSession());
      });
    }
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
      future: Future.wait([currInfo, winningList]),
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
            var user = snapshot.data[0];
            var list = snapshot.data[1];
            var pending = list.where((item) => item.status == '입금대기').length;

            return SingleChildScrollView(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                            (user.profile == null || user.profile == [])
                            ? NetworkImage('https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg')
                            : NetworkImage(user.profile),
                          backgroundColor: Colors.transparent,
                        ),
                        Container(
                          width: 120.0,
                          height: 120.0,
                          alignment: Alignment.topRight,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              shape: BoxShape.circle
                            ),
                            width: 30.0,
                            height: 30.0,
                            child: FloatingActionButton(
                              onPressed: () => Navigator.pushNamed(
                                context, '/changeprofile',
                                arguments: ProfileArguments(
                                  currUser.getSession(),
                                  user.profile
                                )
                              ),
                              backgroundColor: Colors.black,
                              child: Icon(Icons.photo_camera_outlined)
                            )
                          ),
                        ),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user.userID,
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, size: 20),
                          iconSize: 20,
                          onPressed: () => {}
                          // TODO: 사용자 정보 변경
                        )
                      ]
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 21),
                      child: Text(
                        '가입날짜 2020.10.20',
                        style: TextStyle(
                          fontSize: 14, 
                        )
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.only(left: 21, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '낙찰 과정중인 상품',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          VerticalDivider(
                            width: 10,
                          ),
                          RaisedButton(
                            color: Colors.white,
                            textColor: Colors.grey,
                            padding: EdgeInsets.all(10.0),
                            splashColor: Colors.grey,
                            onPressed: () => Navigator.pushNamed(context, '/myproceedings'),
                            child: Text(
                              "자세히 보기",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ]
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(21, 10, 21, 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                '입금',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '대기',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '$pending',
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF80F208),
                                )
                              )
                            ]
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(3, 0, 3, 32),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 48
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '결제',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '완료',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF80F208),
                                )
                              )
                            ]
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(3, 0, 3, 32),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 48
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '배송',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '준비',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '2',
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF80F208),
                                )
                              )
                            ]
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(3, 0, 3, 32),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 48
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '배송',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '진행',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF80F208),
                                )
                              )
                            ]
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(3, 0, 3, 32),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 48
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                '배송',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '완료',
                                style: TextStyle(
                                  fontSize: 16, 
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 26, 
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF80F208),
                                )
                              )
                            ]
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                        textColor: Colors.grey[600],
                        onPressed: () => Navigator.pushNamed(context, '/myauctioninfo'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "나의 경매정보",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                        textColor: Colors.grey[600],
                        onPressed: () => Navigator.pushNamed(context, '/myproceedings'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "배송조회",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                        textColor: Colors.grey[600],
                        onPressed: () => Navigator.pushNamed(context, '/mysettings'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "환경설정",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                        textColor: Colors.grey[600],
                        onPressed: () => Navigator.pushNamed(context, '/helpdesk'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "고객센터",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                        ),
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                        textColor: Colors.grey[600],
                        onPressed: () => Navigator.pushNamed(context, '/policy'),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "사업자 정보 확인",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 42),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          color: Colors.white,
                          textColor: Colors.black,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18.0,),
                          splashColor: Colors.black,
                          onPressed: () async {
                            final storage = new FlutterSecureStorage();
                            http.Response response = await http.get(
                              'https://ibsoft.site/revault/whoami',
                              headers: <String, String>{
                                'Cookie': currUser.getSession(),
                              },
                            );
                            print(response.statusCode);
                            print(response.body);
                            if (response.statusCode == 200 && response.body != null && response.body != "") {
                              await storage.delete(
                                key: "session",
                              );
                              // 로그아웃하여 로그인 화면으로
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                            else if (response.statusCode == 200 && response.body == "") {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('세션이 만료되었습니다. 로그인 화면으로 넘어갑니다')));
                              await storage.delete(
                                key: "session",
                              );
                              Navigator.pushReplacementNamed(context, '/login');
                            }
                            else {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                            }
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            );
        }
      }
    );
  }
}