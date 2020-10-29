import 'package:flutter/material.dart';
import 'auctionGood.dart';

class MyDonations extends StatelessWidget {
  final List<AuctionGood> items = [
    AuctionGood(
      seller: 'KIDMILLE',
      condition: 'B',
      size: 'S',
      startDate: '2020-10-12',
      endDate: '2020-10-16',
      brand: 'NIKE ACG',
      goodName: 'Black Hoodie',
      price: '230000원',
      sellState: '경매 진행중'
    ),
    AuctionGood(
      seller: 'KIDMILLE',
      condition: 'A',
      size: 'M',
      startDate: '2020-10-12',
      endDate: '2020-10-16',
      brand: 'NIKE ACG',
      goodName: 'Jacket With Gloves',
      price: '200000원',
      sellState: '경매 진행중'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("기부금 사용내역"),
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
                              Text('${items[i].price}',
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
              ),
            ]
          ),
        ),
      ),
    );
  }
}