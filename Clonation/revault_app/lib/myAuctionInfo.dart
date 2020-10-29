import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyAuctionInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("나의 경매 정보"),
      ),
      body: SingleChildScrollView(
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
                      RichText(
                        text: TextSpan(
                          text: '1',
                          style: TextStyle(
                            fontSize: 40, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, '/myparticipations')
                        ),
                      ),
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
                      RichText(
                        text: TextSpan(
                          text: '3',
                          style: TextStyle(
                            fontSize: 40, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, '/myprevrecords')
                        ),
                      ),
                    ]
                  )
                ]
              ),
              Divider(),
              Stack(
                children: [
                  Container(
                    height: 100.0,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      child: Icon(
                        Icons.monetization_on_outlined,
                        size: 60,
                        color: Colors.grey[300]
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '나의 충전금 ',
                              style: TextStyle(
                                fontSize: 16, 
                              )
                            ),
                            Text(
                              '210,000원',
                              style: TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              )
                            )
                          ],
                        ),
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
                              '80,000원',
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
                            text: '충전금 사용내역 보기',
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(context, '/mystackinfo')
                          ),
                        )
                      ]
                    )
                  ),
                ]
              ),
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
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        enableInfiniteScroll: false,
                        autoPlay: false
                      ),
                      items: [1,2,3].map((i) {
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
                                            'images/nike_black_hoodie$i.jpeg',
                                            height: 60.0,
                                            width: 60.0, 
                                            fit: BoxFit.cover,
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'NIKE ACG',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                )
                                              ),
                                              Text('Jacket With Gloves',
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
                                              '250,000원',
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
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/changeaddress');
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
                                              onPressed: () {
                                                // TODO: 낙찰 상품 결제창 만들기
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
                    ),
                  ]
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}