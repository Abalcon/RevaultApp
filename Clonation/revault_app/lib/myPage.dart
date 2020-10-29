import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("마이페이지"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage:
                      NetworkImage(
                        'https://www.go4thetop.net/assets/images/Staff_Ryunan.jpg'
                      ),
                    backgroundColor: Colors.transparent,
                  ),
                  Container(
                    width: 160.0,
                    height: 160.0,
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.circle
                      ),
                      width: 40.0,
                      height: 40.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          // TODO: 프로필 사진 변경
                        },
                        backgroundColor: Colors.black,
                        child: Icon(Icons.photo_camera_outlined)
                      )
                    ),
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Unknown',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, size: 20),
                    iconSize: 20,
                    onPressed: () => {}
                    // TODO: 닉네임 변경
                  )
                ]
              ),
              Text(
                '가입날짜 2020.10.20',
                style: TextStyle(
                  fontSize: 14, 
                )
              ),
              Divider(),
              Container(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '낙찰 과정중인 상품',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    VerticalDivider(
                      width: 10,
                    ),
                    RaisedButton(
                      color: Colors.white,
                      textColor: Colors.grey,
                      padding: EdgeInsets.all(10.0),
                      splashColor: Colors.grey,
                      onPressed: () => Navigator.pushNamed(context, '/myproceedings'),
                      child: Text(
                        "자세히 보기",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )
                  ]
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          '입금',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '대기',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )
                        )
                      ]
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 48
                    ),
                    Column(
                      children: [
                        Text(
                          '결제',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )
                        )
                      ]
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 48
                    ),
                    Column(
                      children: [
                        Text(
                          '배송',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '준비',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '2',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )
                        )
                      ]
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 48
                    ),
                    Column(
                      children: [
                        Text(
                          '배송',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '진행',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )
                        )
                      ]
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 48
                    ),
                    Column(
                      children: [
                        Text(
                          '배송',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          )
                        )
                      ]
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 12
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => Navigator.pushNamed(context, '/myauctioninfo'),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "나의 경매정보",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => {
                    // TODO: 배송조회 화면 진행중
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "배송조회",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => {
                    // TODO: 충전금 관리 화면 진행중
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "충전금 관리",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => Navigator.pushNamed(context, '/mysettings'),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "환경설정",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  color: Colors.white,
                  textColor: Colors.grey[600],
                  onPressed: () => Navigator.pushNamed(context, '/helpdesk'),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "고객센터",
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 12
              ),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.white,
                  textColor: Colors.black,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.0,),
                  splashColor: Colors.black,
                  onPressed: () => {
                    // TODO: 로그아웃 절차 진행, 로그인 화면으로 돌리기
                  },
                  child: Text(
                    "LOGOUT",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}