import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:revault_app/auctionResult.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/userInfo.dart';
import 'package:url_launcher/url_launcher.dart';

class MyProceedings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "낙찰 과정중인 상품",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          ),
        ),
      ),
      body: MyProceedingsDetail(),
      backgroundColor: backgroundGrey,
    );
  }
}

class MyProceedingsDetail extends StatefulWidget {

  @override
  MyProceedingsDetailState createState() => MyProceedingsDetailState();
}

class MyProceedingsDetailState extends State<MyProceedingsDetail> {
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
        winningList = fetchWinningList(currUser.getSession());
        currInfo = getInfo(currUser.getSession());
      });
    }
  }

  Future<List<AuctionResult>> winningList;
  Widget _buildWinningSummary() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var pending = snapshot.data.where((item) => item.status == '입금대기').length;
          var billed = snapshot.data.where((item) => item.status == '결제완료').length;
          var prepare = snapshot.data.where((item) => item.status == '배송준비').length;
          var shipping = snapshot.data.where((item) => item.status == '배송중').length;
          var complete = snapshot.data.where((item) => item.status == '배송완료').length;

          return Container(
            padding: EdgeInsets.fromLTRB(25, 20, 21, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '입금',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '대기',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '$pending',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: revaultGreen,
                      )
                    )
                  ]
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 32),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '결제',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '$billed',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: revaultGreen,
                      )
                    )
                  ]
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 32),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '배송',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '준비',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '$prepare',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: revaultGreen,
                      )
                    )
                  ]
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 32),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '배송',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '진행',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '$shipping',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: revaultGreen,
                      )
                    )
                  ]
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 32),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 40
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '배송',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '완료',
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      '$complete',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.bold,
                        color: revaultGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildWinningList() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext _context, int i) {
                var good = snapshot.data[i];
                bool isBillingRequired = (good.status == '입금대기');
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/nike_black_hoodie1.jpeg',
                          height: 70.0,
                          width: 70.0, 
                          fit: BoxFit.cover,
                        ),
                        VerticalDivider(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '[${good.brand}]${good.name}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                              Text(
                                '${putComma(good.price)}원',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: -1.0,
                                )
                              ),
                              Text(
                                good.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.lightGreen,
                                  letterSpacing: -1.0,
                                )
                              ),
                            ],
                          ),
                        ),
                        FlatButton(
                          shape: Border(),
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
                          onPressed: isBillingRequired ? () async {
                            await Navigator.pushNamed(
                              context, '/purchasewindow',
                              arguments: PurchaseArguments(
                                currUser.getSession(),
                                good.ref,
                                good.name,
                                good.price * 1.0,
                              )
                            );
                          } : null,
                        ),
                      ],
                    ),
                  )
                );
              }
            );
          }

          return Container(
            height: 200,
            color: Colors.white,
            child: Center(
              child: Text(
                "현재 낙찰된 상품이 없습니다",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildRecentList() {
    return FutureBuilder<List<AuctionResult>>(
      future: winningList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 250.0,
              child: Center(
                child: Text(
                  "낙찰중인 제품이 없습니다",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            );
          }

          return CarouselSlider(
            options: CarouselOptions(
              height: 230.0,
              enableInfiniteScroll: false,
              autoPlay: false
            ),
            items: snapshot.data.map((good) {
              bool isBillingRequired = (good.status == '입금대기');

              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Table(
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: revaultBlack,
                          ),
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
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
                                // TODO: 낙찰된 상품의 경우 Image URL에 해당하는 항목이 없다
                                Image.asset(
                                  'images/nike_black_hoodie1.jpeg',
                                  height: 70.0,
                                  width: 70.0, 
                                  fit: BoxFit.cover,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      good.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: -1.0,
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
                            border: Border(
                              top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                            ),
                            color: Colors.white,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '낙찰 금액',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      isBillingRequired ? '배송지 입력' : '배송 조회',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      isBillingRequired ? '잔금 처리' : '결제 완료',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                  )
                                ]
                              ),
                            ),
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
                                    '${putComma(good.price)}원',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0 - 20,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  child: FlatButton(
                                    color: Colors.white,
                                    textColor: Colors.grey,
                                    disabledColor: Colors.transparent,
                                    disabledTextColor: Colors.transparent,
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      side: BorderSide(color: Color(0xFFE0E0E0),),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      isBillingRequired ? '입력하기' : '조회하기',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      )
                                    ),
                                    onPressed: isBillingRequired ? () async {
                                      await Navigator.pushNamed(
                                        context, '/changeaddress',
                                        arguments: ReceiverArguments(
                                          currUser.getSession(),
                                          good.ref,
                                          good.receiver,
                                          good.phone,
                                          good.address,
                                        )
                                      );
                                      //if (result == "Changed") {
                                        setState(() {
                                          winningList = fetchWinningList(currUser.getSession());
                                        });
                                      //}
                                    } : () async {
                                      if (good.trackNumber == null) {
                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('아직 송장번호가 등록되지 않았습니다')));
                                      }
                                      else {
                                        final String url = 'https://www.cjlogistics.com/ko/tool/parcel/tracking?gnbInvcNo=${good.trackNumber}';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        }
                                        else {
                                           ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('현재 배송 조회를 할수 없습니다. 나중에 다시 시도해주세요')));
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.0 - 20,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  child: FlatButton(
                                    color: Colors.white,
                                    textColor: Colors.grey,
                                    disabledColor: Colors.white,
                                    disabledTextColor: Colors.white,
                                    splashColor: Colors.grey,
                                    shape: isBillingRequired ? RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      side: BorderSide(color: Color(0xFFE0E0E0),),
                                    ) : null,
                                    padding: EdgeInsets.all(10),
                                    child: Text('결제하기',
                                      style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      )
                                    ),
                                    onPressed: isBillingRequired ? () async {
                                      await Navigator.pushNamed(
                                        context, '/purchasewindow',
                                        arguments: PurchaseArguments(
                                          currUser.getSession(),
                                          good.ref,
                                          good.name,
                                          good.price * 1.0,
                                        )
                                      );

                                      setState(() {
                                        winningList = fetchWinningList(currUser.getSession());
                                      });
                                    } : null,
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
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }

  Future<UserInfo> currInfo;
  Widget _buildAddressPart() {
    return FutureBuilder<UserInfo>(
      future: currInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data;
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
                bottom: BorderSide(
                  width: 1.0,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '배송지 정보',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      (user.name == null) ? '미입력' : user.name,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(
                      width: 20
                    ),
                    Text(
                      (user.phone == null) ? '미입력' : user.phone,
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: -1.0,
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
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(
                      width: 33
                    ),
                    new Container(
                      constraints: new BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 2 / 3
                      ),
                      child: Text(
                        (user.address == null) ? '미입력' : user.address,
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: -1.0,
                        )
                      ),
                    ),
                  ],
                ),
              ]
            )
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
      child: Center(
        child: Column(
          children: [
            _buildWinningSummary(),
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
                  letterSpacing: -1.0,
                ),
              ),
            ),
            _buildWinningList(),
            Container(
              color: backgroundGrey,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      '최근 낙찰된 제품',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.0,
                      )
                  ),
                  ),
                  Divider(color: Colors.transparent, height: 12),
                  _buildRecentList(),
                ]
              ),
            ),
            _buildAddressPart(),
          ]
        ),
      ),
    );
  }
}