import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'auctionGood.dart';
import 'package:revault_app/common/common.dart';

List<AuctionGood> parseGoodList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionGood>((json) => AuctionGood.fromJson(json)).toList();
}

Future<List<AuctionGood>> fetchParticipations(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionList?status=1&isBid=1',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    if (response.body == "")
      return [];
    return compute(parseGoodList, response.body);
  }
  else {
    // throw Exception('상품 정보를 불러오지 못했습니다');
    return [];
  }
}

class MyParticipations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "진행중인 경매",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyParticipationsDetail(),
      backgroundColor: backgroundGrey,
    );
  }
}

class MyParticipationsDetail extends StatefulWidget {

  @override
  MyParticipationsDetailState createState() => MyParticipationsDetailState();
}

class MyParticipationsDetailState extends State<MyParticipationsDetail> {
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
        auctionList = fetchParticipations(currUser.getSession());
      });
    }
  }

  Future<List<AuctionGood>> auctionList;
  Widget _buildWithList() {
    return FutureBuilder<List<AuctionGood>>(
      future: auctionList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = snapshot.data[i];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onPressed: () async {
                      await Navigator.pushNamed(
                        context, '/auctiongooddetail',
                        arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
                      );
                      setState(() {
                        auctionList = fetchParticipations(currUser.getSession());
                      });
                    },
                    child: Row(
                      children: [
                        Image.network(
                          good.imageUrlList[0],
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                        ),
                        VerticalDivider(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                good.brand,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                              Text(
                                good.goodName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '현재 금액',
                              style: TextStyle(
                                fontSize: 14,
                              )
                            ),
                            Text('${putComma(good.price)}원',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.red
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            );
          }
          
          return Text(
            "현재 참여하고있는 경매가 없습니다",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10,),
          child: Center(
            child: CircularProgressIndicator()
          ),
        );
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