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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "낙찰 과정중인 상품",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyProceedingsDetail(),
      backgroundColor: backgroundGrey,
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = snapshot.data[i];
                bool isBillingRequired = (good.status == '입금대기');
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/nike_black_hoodie1.jpeg',
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '[${good.brand}]${good.name}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                              Text(
                                '${putComma(good.price)}원',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                              Text(
                                good.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.lightGreen,
                                  letterSpacing: -1.0,
                                )
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          shape: Border(),
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
                          onPressed: isBillingRequired ? () async {
                            await Navigator.pushNamed(
                              context, '/purchasewindow',
                              arguments: PurchaseArguments(
                                currUser.getSession(),
                                good.ref,
                                good.name,
                                good.price * 1.0,
                              )
                            );
                          } : null,
                        ),
                      ],
                    ),
                  )
                );
              }
            );
          }

          return Container(
            height: 200,
            color: Colors.white,
            child: Center(
              child: Text(
                "현재 낙찰된 상품이 없습니다",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
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
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
                bottom: BorderSide(
                  width: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '배송지 정보',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      (user.name == null) ? '미입력' : user.name,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      (user.phone == null) ? '미입력' : user.phone,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
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
                        (user.address == null) ? '미입력' : user.address,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: -1.0,
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
              color: revaultBlack,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                '제품정보',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
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