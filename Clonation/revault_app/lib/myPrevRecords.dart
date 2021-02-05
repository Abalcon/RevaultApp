import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'auctionGood.dart';
import 'package:revault_app/common/aux.dart';

List<AuctionGood> parseGoodList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionGood>((json) => AuctionGood.fromJson(json)).toList();
}

Future<List<AuctionGood>> fetchWinningsFromRecords(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionList?status=2&isWin=1',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    return compute(parseGoodList, response.body);
  }
  else {
    return [];
  }
}

Future<List<AuctionGood>> fetchPreviousRecords(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionList?status=2',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    return compute(parseGoodList, response.body);
  }
  else {
    // throw Exception('상품 정보를 불러오지 못했습니다');
    return [];
  }
}

class MyPrevRecords extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "이전 참여 경매",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyPrevRecordsDetail(),
      backgroundColor: backgroundGrey,
    );
  }
}

class MyPrevRecordsDetail extends StatefulWidget {

  @override
  MyPrevRecordsDetailState createState() => MyPrevRecordsDetailState();
}

class MyPrevRecordsDetailState extends State<MyPrevRecordsDetail> {
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
        winningList = fetchWinningsFromRecords(currUser.getSession());
        auctionList = fetchPreviousRecords(currUser.getSession());
      });
    }
  }

  Future<List<AuctionGood>> winningList;
  Future<List<AuctionGood>> auctionList;
  Widget _buildWithList() {
    return FutureBuilder(
      future: Future.wait([winningList, auctionList]),
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
            var win = snapshot.data[0].map((good) => good.auctionID).toList();
            var all = snapshot.data[1];

            if (all.length == 0) {
              return Text(
                "이전에 참여한 경매가 없습니다",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              //padding: const EdgeInsets.all(0),
              itemCount: all.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = all[i];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]),
                    ),
                    color: win.contains(good.auctionID) ?
                      Colors.transparent : Colors.grey[350],
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 8, 18, 8),
                    child: Row(
                      children: [
                        good.imageUrlList.length > 0 ?
                        Image.network(
                          good.imageUrlList[0],
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                          color: win.contains(good.auctionID) ?
                            Colors.white : Colors.grey[350],
                          colorBlendMode: BlendMode.darken,
                        ) :
                        Image.asset(
                          'images/revault_square_logo.jpg',
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                          color: win.contains(good.auctionID) ?
                            Colors.white : Colors.grey,
                          colorBlendMode: BlendMode.darken,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '[${good.brand}]${good.goodName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: -1.0,
                                  )
                                ),
                                Text('Size ${good.size}  Condition ${good.condition}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    letterSpacing: -1.0,
                                  )
                                ),
                                Text('${putComma(good.price)}원',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: -1.0,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 60.0,
                          height: 60.0,
                          child: win.contains(good.auctionID) ?
                            Icon(
                              Icons.verified,
                              size: 40,
                              color: Colors.yellow
                            ) :
                            Icon(
                              Icons.block,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                        )
                      ],
                    ),
                  ),
                );
              }
            );
          }
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
      //padding: EdgeInsets.only(top: 20),
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
            _buildWithList(),
          ]
        ),
      ),
    );
  }
}