import 'package:flutter/material.dart';
import 'auctionGood.dart';

class MyProceedings extends StatelessWidget {
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
      aucState: '배송중'
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
      aucState: '배송준비'
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
      aucState: '입금대기'
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
      aucState: '배송완료'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("낙찰 과정중인 상품"),
      ),
      body: SingleChildScrollView(
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
                  bool isPayingEnabled = (items[i].aucState != '배송완료');

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
                                  '[${items[i].brand}] ${items[i].goodName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )
                                ),
                                Text('Size ${items[i].size} Condition ${items[i].condition}',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )
                                ),
                                Text('${items[i].price}원',
                                  style: TextStyle(
                                    fontSize: 14,
                                  )
                                ),
                                Text('${items[i].aucState}',
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
              ),
              Container(
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
                          '홍길동',
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
                          '010-1234-5678',
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
                        Text(
                          '서울특별시 서초구 신반포로45길 54 B1F',
                          style: TextStyle(
                            fontSize: 14, 
                          )
                        )
                      ],
                    ),
                  ]
                )
              ),
            ]
          ),
        ),
      ),
    );
  }
}