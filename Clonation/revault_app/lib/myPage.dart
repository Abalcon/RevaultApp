import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:revault_app/auctionGood.dart';
import 'package:revault_app/auctionResult.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/userInfo.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "마이페이지",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
      ),
      body: MyPageDetails(),
      backgroundColor: backgroundGrey,
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
        ongoingList = fetchGoodList(currUser.getSession(), 1, 'Bid');
        recordList = fetchGoodList(currUser.getSession(), 2, '');
        winningList = fetchWinningList(currUser.getSession());
      });
    }
  }

  Future<List<AuctionGood>> ongoingList;
  Future<List<AuctionGood>> recordList;
  Future<List<AuctionResult>> winningList;
  Widget _listCountText(Future future, String route) {
    return FutureBuilder<List>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RichText(
            text: TextSpan(
              text: '${snapshot.data.length}',
              style: TextStyle(
                fontSize: 56, 
                fontWeight: FontWeight.bold,
                color: revaultGreen,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, route)
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text(
            "${snapshot.error}",
          );
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }

  // Widget _getTotalDonation() {
  //   return FutureBuilder<List<AuctionResult>>(
  //     future: winningList,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         var donation = 0;
  //         var list = snapshot.data;
  //         list.forEach((good) => donation += (good.price * 0.1).toInt());

  //         return Container(
  //           padding: EdgeInsets.symmetric(vertical: 15),
  //           decoration: BoxDecoration(
  //             border: Border(
  //               bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
  //             ),
  //             color: Colors.white,
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text(
  //                     '누적 기부액  ',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       letterSpacing: -1.0,
  //                     ),
  //                   ),
  //                   Text(
  //                     '${putComma(donation)}원',
  //                     style: TextStyle(
  //                       fontSize: 18, 
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.red,
  //                       letterSpacing: -1.0,
  //                     )
  //                   )
  //                 ],
  //               ),
  //               Divider(color: Colors.transparent, height: 8),
  //               RichText(
  //                 text: TextSpan(
  //                   text: '자세히 보기',
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontWeight: FontWeight.bold,
  //                     decoration: TextDecoration.underline
  //                   ),
  //                   recognizer: TapGestureRecognizer()
  //                     ..onTap = () => Navigator.pushNamed(context, '/mydonations')
  //                 ),
  //               ),
  //             ]
  //           )
  //         );
  //       }

  //       else if (snapshot.hasError) {
  //         return Text("${snapshot.error}");
  //       }

  //       return Center(child: CircularProgressIndicator());
  //     }
  //   );
  // }

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
              return Text(
                "${snapshot.error}",
                style: TextStyle(
                  color: Colors.transparent,
                ),
              );
            }
            var user = snapshot.data[0];

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 110.0,
                            height: 110.0,
                            padding: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Color(0xFFA4A4A4),
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 55.0,
                              backgroundImage:
                                (user.profile == null || user.profile == [])
                                ? NetworkImage('https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg')
                                : NetworkImage(user.profile),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Container(
                            width: 110.0,
                            height: 110.0,
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: revaultBlack),
                                shape: BoxShape.circle
                              ),
                              width: 28.0,
                              height: 28.0,
                              child: FloatingActionButton(
                                onPressed: () => Navigator.pushNamed(
                                  context, '/changeprofile',
                                  arguments: ProfileArguments(
                                    currUser.getSession(),
                                    user.profile
                                  )
                                ),
                                backgroundColor: revaultBlack,
                                child: Icon(Icons.photo_camera_outlined)
                              )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.userID,
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.0,
                            )
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, size: 20),
                            iconSize: 20,
                            onPressed: () => {}
                            // TODO: 사용자 정보 변경
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 18),
                        child: Text(
                          '가입날짜 2020.10.20',
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: -1.0,
                          )
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '진행중인 경매',
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -1.0,
                                    )
                                  ),
                                  _listCountText(ongoingList, '/myparticipations'),
                                ]
                              ),
                              VerticalDivider(
                                color: Color(0xFF828282),
                                width: 56,
                                thickness: 5,
                                indent: 20,
                                endIndent: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '낙찰된 경매',
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  _listCountText(winningList, '/myproceedings'),
                                ],
                              ),
                              VerticalDivider(
                                color: Color(0xFF828282),
                                width: 56,
                                thickness: 5,
                                indent: 20,
                                endIndent: 20,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '이전 참여 경매',
                                    style: TextStyle(
                                      fontSize: 16, 
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  _listCountText(recordList, '/myprevrecords'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //_getTotalDonation(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                          ),
                        ),
                        child: FlatButton(
                          shape: Border(),
                          padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                          textColor: Colors.grey[600],
                          onPressed: () => Navigator.pushNamed(context, '/myproceedings'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "낙찰 과정중인 상품",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: -1.0,
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
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                          ),
                        ),
                        child: FlatButton(
                          shape: Border(),
                          padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                          textColor: Colors.grey[600],
                          onPressed: () => Navigator.pushNamed(context, '/myproceedings'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "배송조회",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                          ),
                        ),
                        child: FlatButton(
                          shape: Border(),
                          padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                          color: Colors.white,
                          textColor: Colors.grey[600],
                          onPressed: () => Navigator.pushNamed(context, '/mysettings'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "환경설정",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: -1.0,
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
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                          ),
                        ),
                        child: FlatButton(
                          shape: Border(),
                          padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                          textColor: Colors.grey[600],
                          onPressed: () => Navigator.pushNamed(context, '/helpdesk'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "고객센터",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: -1.0,
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
                            top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                          ),
                        ),
                        child: FlatButton(
                          shape: Border(),
                          padding: EdgeInsets.fromLTRB(21, 10, 0, 10),
                          textColor: Colors.grey[600],
                          onPressed: () => Navigator.pushNamed(context, '/policy'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "사업자 정보 확인",
                              style: TextStyle(
                                fontSize: 14.0,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: backgroundGrey,
                        padding: EdgeInsets.only(top: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: FlatButton(
                            shape: Border(),
                            color: Colors.white,
                            textColor: revaultBlack,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 18.0,),
                            splashColor: revaultBlack,
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
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            );
        }
      }
    );
  }
}