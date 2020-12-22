import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class MyProceedings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("낙찰 과정중인 상품"),
      ),
      body: MyProceedingsDetail(),
    );
  }
}

class MyProceedingsDetail extends StatefulWidget {

  @override
  MyProceedingsDetailState createState() => MyProceedingsDetailState();
}

class MyProceedingsDetailState extends State<MyProceedingsDetail> {
  SessionNamePair currUser;
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
        winningList = fetchWinningList(currUser.getSession());
        currInfo = getInfo(currUser.getSession());
      });
    }
  }

  Future<List<AuctionResult>> winningList;
  Widget _buildWinningList() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = snapshot.data[i];
                bool isPayingEnabled = (good.status == '입금대기');
                return Column(
                  children: [
                    Row(
                      children: [
                        // image section
                        Image.asset(
                          'images/nike_black_hoodie1.jpeg',
                          height: 60.0,
                          width: 60.0, 
                          fit: BoxFit.cover,
                        ),
                        // text section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '[${good.brand}]${good.name}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ),
                              // Text('Size ${good.size} Condition ${good.condition}',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //   )
                              // ),
                              Text(
                                '${good.price}원',
                                style: TextStyle(
                                  fontSize: 14,
                                )
                              ),
                              Text(
                                good.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.lightGreen
                                )
                              ),
                            ],
                          ),
                        ),
                        // buttonSection
                        RaisedButton(
                          color: Colors.white,
                          textColor: Colors.grey,
                          disabledColor: Colors.transparent,
                          disabledTextColor: Colors.transparent,
                          splashColor: Colors.grey,
                          padding: EdgeInsets.all(10),
                          child: Text('결제하기',
                            style: TextStyle(
                              fontSize: 14,
                            )
                          ),
                          onPressed: isPayingEnabled ? () {
                            // TODO: 상품 결제 부분 만들기
                          } : null,
                        ),
                      ],
                    ),
                    Divider()
                  ]
                );
              }
            );
          }

          return Text(
            "현재 낙찰된 상품이 없습니다",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<UserInfo> currInfo;
  Widget _buildAddressPart() {
    return FutureBuilder<UserInfo>(
      future: currInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data;
          return Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  '배송지 정보',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  )
                ),
                Divider(
                  color: Colors.white,
                  height: 15
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '수령인',
                      style: TextStyle(
                        fontSize: 14, 
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 14, 
                      )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '연락처',
                      style: TextStyle(
                        fontSize: 14, 
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      user.phone,
                      style: TextStyle(
                        fontSize: 14, 
                      )
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '주소',
                      style: TextStyle(
                        fontSize: 14, 
                      )
                    ),
                    VerticalDivider(
                      width: 33
                    ),
                    new Container(
                      constraints: new BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 2 / 3
                      ),
                      child: Text(
                        user.address,
                        style: TextStyle(
                          fontSize: 14, 
                        )
                      ),
                    ),
                  ],
                ),
              ]
            )
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      }
    );
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
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                '제품정보',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildWinningList(),
            _buildAddressPart(),
          ]
        ),
      ),
    );
  }
}