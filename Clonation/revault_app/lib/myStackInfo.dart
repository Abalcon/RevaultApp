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
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => Navigator.pushNamed(context, '/mybillings'),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "충전금 사용 내역",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 1, thickness: 3),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => Navigator.pushNamed(context, '/mydonations'),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "기부 내역",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                color: Colors.grey[350],
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    onPressed: () => Navigator.pushNamed(context, '/mydonations'),
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      "충전하기",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}