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

Future<List<AuctionGood>> fetchFailures(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionList?status=2&isLost=1',
    headers: <String, String>{
      'Cookie': session,
    },
  );
  if (response.statusCode == 200) {
    if (response.body == "")
      return [];
    return compute(parseGoodList, response.body);
  }

  return [];
}

class MyFailures extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "실패한 경매",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: MyFailuresDetail(),
    );
  }
}

class MyFailuresDetail extends StatefulWidget {

  @override
  MyFailuresDetailState createState() => MyFailuresDetailState();
}

class MyFailuresDetailState extends State<MyFailuresDetail> {
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
        failList = fetchFailures(currUser.getSession());
      });
    }
  }

  Future<List<AuctionGood>> failList;
  Widget _buildWithList() {
    return FutureBuilder<List<AuctionGood>>(
      future: failList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = snapshot.data[i];
                return Column(
                  children: [
                    Row(
                      children: [
                        Image.network(
                          good.imageUrlList[0],
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '[${good.brand}]',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ),
                              Text('${good.goodName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                )
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '최종 금액',
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
                    Divider(),
                  ]
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
      //padding: EdgeInsets.only(top: 20),
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