import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyStackInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("충전금 관리"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Divider(),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '나의 충전금',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        RichText(
                          text: TextSpan(
                            text: '180,000원',
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(context, '/mybillings')
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
                          '누적 기부 금액',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        RichText(
                          text: TextSpan(
                            text: '85,000원',
                            style: TextStyle(
                              fontSize: 32, 
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamed(context, '/mydonations')
                          ),
                        ),
                      ]
                    )
                  ]
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100.0,
                padding: EdgeInsets.only(left: 10, bottom: 10),
                alignment: Alignment.bottomLeft,
                color: Colors.grey[300],
                child: Text(
                  '충전금 사용내역 보기',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: '충전금 사용내역',
                    style: TextStyle(
                      color: Colors.black,
                      //decoration: TextDecoration.underline
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(context, '/mybillings')
                  ),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: '기부 내역',
                    style: TextStyle(
                      color: Colors.black,
                      //decoration: TextDecoration.underline
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(context, '/mydonations')
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                color: Colors.grey[350],
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  child: RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: MediaQuery.of(context).size.width / 3),
                    splashColor: Colors.black,
                    onPressed: () => {
                      // TODO: 충전하기 화면 진행중
                    },
                    child: Text(
                      "충전하기",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}