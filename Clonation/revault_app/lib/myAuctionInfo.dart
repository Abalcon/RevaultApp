import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/auctionGood.dart';
import 'package:revault_app/auctionResult.dart';
import 'package:revault_app/common/aux.dart';

List<AuctionGood> parseGoodList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionGood>((json) => AuctionGood.fromJson(json)).toList();
}

Future<List<AuctionGood>> fetchGoodList(String session, int status, String type) async {
  final String typeParam = (type == '') ? '' : '&is$type=1';
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionList?status=$status$typeParam',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    if (response.body == "")
      return [];
    print("Now Parsing!");
    return compute(parseGoodList, response.body);
  }
  else {
    // throw Exception('상품 정보를 불러오지 못했습니다');
    return [];
  }
}

List<AuctionResult> parseResultList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionResult>((json) => AuctionResult.fromJson(json)).toList();
}

Future<List<AuctionResult>> fetchResultList(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionResultList',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    if (response.body == "")
      return [];
    return compute(parseResultList, response.body);
  }

  return [];
}

class MyAuctionInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("나의 경매 정보"),
      ),
      body: MyAuctionInfoDetails(),
    );
  }
}

class MyAuctionInfoDetails extends StatefulWidget {

  @override
  MyAuctionInfoDetailsState createState() => MyAuctionInfoDetailsState();
}

class MyAuctionInfoDetailsState extends State<MyAuctionInfoDetails> {
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
        ongoingList = fetchGoodList(currUser.getSession(), 1, 'Bid');
        recordList = fetchGoodList(currUser.getSession(), 2, '');
        winningList = fetchResultList(currUser.getSession());
      });
    }
  }

  Future<List<AuctionGood>> ongoingList;
  Future<List<AuctionGood>> recordList;
  Future<List<AuctionResult>> winningList;
  Widget _listCountText(Future future, String route) {
    return FutureBuilder<List<AuctionGood>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RichText(
            text: TextSpan(
              text: '${snapshot.data.length}',
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold,
                color: Color(0xFF80F208),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pushNamed(context, route)
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget _getTotalDonation() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var donation = 0;
          var list = snapshot.data;
          list.forEach((good) => donation += (good.price * 0.1).toInt());

          return Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '누적 기부금액 ',
                      style: TextStyle(
                        fontSize: 16, 
                      )
                    ),
                    Text(
                      '$donation원',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      )
                    )
                  ],
                ),
                RichText(
                  text: TextSpan(
                    text: '자세히 보기',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.underline
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(context, '/mydonations')
                  ),
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

  Widget _buildWithList() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              autoPlay: false
            ),
            items: snapshot.data.map((good) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Table(
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.black,
                          ),
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                '제품정보',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )
                              )
                            )
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  'images/nike_black_hoodie1.jpeg',
                                  height: 60.0,
                                  width: 60.0, 
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      good.brand,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      )
                                    ),
                                    Text(
                                      good.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                    ),
                                  ],
                                )
                              ]
                            )
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '낙찰 금액',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '배송지 입력',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '잔금 처리',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )
                                  ),
                                )
                              ]
                            )
                          ]
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${good.price}원',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    )
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    textColor: Colors.grey,
                                    disabledColor: Colors.white,
                                    disabledTextColor: Colors.white,
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Text('입력하기',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                    ),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context, '/changeaddress',
                                        arguments: ReceiverArguments(
                                          currUser.getSession(),
                                          good.ref,
                                          good.receiver,
                                          good.phone,
                                          good.address,
                                        )
                                      );
                                      //if (result == "Changed") {
                                        setState(() {
                                          ongoingList = fetchGoodList(currUser.getSession(), 1, 'Bid');
                                          recordList = fetchGoodList(currUser.getSession(), 2, '');
                                          winningList = fetchResultList(currUser.getSession());
                                        });
                                      //}
                                    },
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0,
                                  alignment: Alignment.center,
                                  child: RaisedButton(
                                    color: Colors.white,
                                    textColor: Colors.grey,
                                    disabledColor: Colors.white,
                                    disabledTextColor: Colors.white,
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0))
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Text('결제하기',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                    ),
                                    onPressed: () async {
                                      await Navigator.pushNamed(
                                        context, '/purchasewindow',
                                        arguments: PurchaseArguments(
                                          currUser.getSession(),
                                          good.ref,
                                          good.name,
                                          good.price * 1.0,
                                        )
                                      );
                                    },
                                  ),
                                )
                              ]
                            )
                          ]
                        ),
                      ],
                    )
                  );
                },
              );
            }).toList(),
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
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: Column(
          children: [
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '진행중인 경매',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    _listCountText(ongoingList, '/myparticipations'),
                  ]
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 50,
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
                Column(
                  children: [
                    Text(
                      '이전 참여 경매',
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    _listCountText(recordList, '/myprevrecords'),
                  ]
                )
              ]
            ),
            Divider(),
            _getTotalDonation(),
            Container(
              color: Colors.grey[350],
              padding: EdgeInsets.only(left: 10, top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '최근 낙찰된 제품',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  _buildWithList(),
                ]
              ),
            ),
          ],
        ),
      )
    );
  }
}