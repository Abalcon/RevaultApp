import 'package:flutter/material.dart';
import 'auctionGood.dart';

class MyPrevRecords extends StatelessWidget {
  final List<AuctionGood> items = [
    AuctionGood(
      auctionID: 1,
      seller: 'KIDMILLE',
      condition: 'B',
      size: 'S',
      startDate: DateTime.fromMillisecondsSinceEpoch(1603285200000),
      endDate: DateTime.fromMillisecondsSinceEpoch(1603612800000),
      brand: 'NIKE ACG',
      goodName: 'Black Hoodie',
      price: 230000,
      sellState: '낙찰 성공'
    ),
    AuctionGood(
      auctionID: 2,
      seller: 'KIDMILLE',
      condition: 'A',
      size: 'M',
      startDate: DateTime.fromMillisecondsSinceEpoch(1603285200000),
      endDate: DateTime.fromMillisecondsSinceEpoch(1603612800000),
      brand: 'NIKE ACG',
      goodName: 'Jacket With Gloves',
      price: 200000,
      sellState: '낙찰 실패'
    ),
    AuctionGood(
      auctionID: 3,
      seller: 'KIDMILLE',
      condition: 'S',
      size: 'L',
      startDate: DateTime.fromMillisecondsSinceEpoch(1603285200000),
      endDate: DateTime.fromMillisecondsSinceEpoch(1603612800000),
      brand: 'NIKE ACG',
      goodName: 'Black Hoodie',
      price: 230000,
      sellState: '낙찰 성공'
    ),
    AuctionGood(
      auctionID: 4,
      seller: 'KIDMILLE',
      condition: 'NEW',
      size: 'XL',
      startDate: DateTime.fromMillisecondsSinceEpoch(1603285200000),
      endDate: DateTime.fromMillisecondsSinceEpoch(1603612800000),
      brand: 'NIKE ACG',
      goodName: 'Jacket With Gloves',
      price: 200000,
      sellState: '낙찰 성공'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("이전 참여 경매"),
      ),
      body: SingleChildScrollView(
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
              ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: items.length,
                itemBuilder: (BuildContext _context, int i) {
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
                                  '${items[i].brand}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )
                                ),
                                Text('${items[i].goodName}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )
                                ),
                                Text('${items[i].price}원',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.red
                                  )
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 60.0,
                            height: 60.0,
                            child: (items[i].sellState == '낙찰 실패') ?
                              Icon(
                                Icons.block,
                                size: 40,
                                color: Colors.grey[400]
                              ) :
                              Icon(
                                Icons.verified,
                                size: 40,
                                color: Colors.yellow
                              ),
                          )
                        ],
                      ),
                      Divider()
                    ]
                  );
                }
              ),
            ]
          ),
        ),
      ),
    );
  }
}