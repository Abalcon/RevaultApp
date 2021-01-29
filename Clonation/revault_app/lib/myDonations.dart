import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'auctionResult.dart';
import 'package:revault_app/common/aux.dart';

List<AuctionResult> parseGoodList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionResult>((json) => AuctionResult.fromJson(json)).toList();
}

Future<List<AuctionResult>> fetchDonations(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getAuctionResultList',
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

class MyDonations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("기부금 사용내역"),
      ),
      body: MyDonationsDetail(),
    );
  }
}

class MyDonationsDetail extends StatefulWidget {

  @override
  MyDonationsDetailState createState() => MyDonationsDetailState();
}

class MyDonationsDetailState extends State<MyDonationsDetail> {
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
        resultList = fetchDonations(currUser.getSession());
      });
    }
  }

  Future<List<AuctionResult>> resultList;
  Widget _buildWithList() {
    return FutureBuilder<List<AuctionResult>>(
      future: resultList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                return Column(
                  children: [
                    Row(
                      children: [
                        // TODO: 낙찰된 상품의 경우 Image URL에 해당하는 항목이 없다
                        Image.asset(
                          'images/nike_black_hoodie1.jpeg',
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '[${snapshot.data[i].brand}]',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ),
                              Text('${snapshot.data[i].name}',
                                style: TextStyle(
                                  fontSize: 14,
                                )
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '기부 금액',
                              style: TextStyle(
                                fontSize: 14,
                              )
                            ),
                            Text('${putComma((snapshot.data[i].price / 10).ceil())}원',
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
                    Divider()
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