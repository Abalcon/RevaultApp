import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/common/aux.dart';
import 'auctionGood.dart';

List<AuctionGood> parseGoodList(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<AuctionGood>((json) => AuctionGood.fromJson(json)).toList();
}

Future<List<AuctionGood>> fetchGoodList(int status) async {
  final response = await http.get('https://ibsoft.site/revault/getAuctionList?status=$status');
  if (response.statusCode == 200) {
    return compute(parseGoodList, response.body);
  }
  else {
    // throw Exception('상품 정보를 불러오지 못했습니다');
    return [];
  }
}

class AuctionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 20.0,
                floating: false,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    "REVAULT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                actions: [
                  Expanded(
                    child: Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          icon: Icon(Icons.info_outline),
                          onPressed: () => Navigator.pushNamed(context, '/mysettings'),
                        ),
                        Text('a', style: TextStyle(color: Colors.white))
                      ]
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.person_outline_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/mypage'),
                  ),
                ],
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorWeight: 3,
                    indicatorColor: revaultGreen,
                    tabs: [
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("LIVE",),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("UPCOMING",),
                          ),
                        ),
                      ),
                      Tab(
                        child: SizedBox.expand(
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.white,
                            child: Text("ENDED",),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget> [
              Center(child: AuctionGoods(status: 1)),
              Center(child: AuctionGoods(status: 0)),
              Center(child: AuctionGoods(status: 2)),
            ],
          )
        ),
      )
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// 상품 리스트
class AuctionGoods extends StatefulWidget {
  final int status;
  AuctionGoods({Key key, @required this.status}) : super(key: key);

  @override
  _AuctionGoodsState createState() => _AuctionGoodsState();
}

class _AuctionGoodsState extends State<AuctionGoods> {
  Future<List<AuctionGood>> auctionList;

  Widget _buildWithList() {
    return FutureBuilder<List<AuctionGood>>(
      future: auctionList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext _context, int i) {
              return _buildItem(snapshot.data[i]);
            }
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildItem(AuctionGood good) {
    return Column(
      children: [
        Divider(height: 8, thickness: 8, color: backgroundGrey,),
        specSection(good),
        imageSection(good),
        detailSection(good),
      ],
    );
  }

  Widget specSection(AuctionGood good) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFA4A4A4),
            width: 0.2,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(8, 8, 10, 8),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.person_outline_outlined, size: 18),
                Text(
                  good.seller,
                  style: TextStyle(
                    fontSize: 15,
                    color: revaultBlack,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified_outlined, size: 18),
          Text(
            good.condition != null ? good.condition: 'F',
            style: TextStyle(
              fontSize: 15,
              color: revaultBlack,
              fontWeight: FontWeight.w500,
              letterSpacing: -1.0,
            ),
          ),
          VerticalDivider(width: 10),
          Icon(Icons.checkroom_outlined, size: 18),
          Text(good.size != null ? good.size: 'Free',
            style: TextStyle(
              fontSize: 15,
              color: revaultBlack,
              fontWeight: FontWeight.w500,
              letterSpacing: -1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget imageSection(AuctionGood good) {
    if (good.aucState == 2) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Stack(
          children: [
            (good.imageUrlList != null && good.imageUrlList.length > 0) ?
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              color: Color(0x80000000),
              child: Image.network(
                good.imageUrlList[0],
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                //fit: BoxFit.cover,
                color: Color(0x80000000),
                colorBlendMode: BlendMode.darken,
              ),
            ) :
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              color: Color(0x80000000),
              child: Image.asset(
                'images/nike_black_hoodie1.jpeg',
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                //fit: BoxFit.cover,
                color: Color(0x80000000),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 2,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                        AssetImage(
                          'images/revault_square_logo.jpg',
                        ),
                        // NetworkImage(
                        //   'https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg'
                        // ),
                      backgroundColor: Colors.transparent
                    ),
                    Divider(color: Colors.transparent, height: 10,),
                    Text(
                      '${good.winner}님에게 낙찰되었습니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    Divider(color: Colors.transparent, height: 5,),
                    Text(
                      '최종낙찰가 ${putComma(good.price)}원',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    var rt = (good.aucState == 1)
      ? remainingTime(good.endDate)
      : remainingTime(good.startDate);

    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 2,
            child: (good.imageUrlList != null && good.imageUrlList.length > 0) ?
            Image.network(
              good.imageUrlList[0],
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width,
              //fit: BoxFit.cover,
            ) :
            Image.asset(
              'images/nike_black_hoodie1.jpeg',
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.width,
              //fit: BoxFit.cover,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90.0,
            padding: EdgeInsets.only(top: 16),
            alignment: Alignment.topLeft,
            child: Container(
              width: 90.0,
              child: ClipRect(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: (rt.inDays > 2) ?
                      Color(0xFF2C4FDE) : Color(0xFFE92D2D),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 9, 0, 9),
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.white,
                          size: 18,
                        ),
                        Text(
                          remainingTimeTextFromDuration(rt),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   width: 75.0,
          //   height: 90.0,
          //   alignment: Alignment.bottomLeft,
          //   child: ClipRect(
          //     child: DecoratedBox(
          //       decoration: ShapeDecoration(
          //         color: Color(0xFF2C4FDE),
          //         shape: RoundedRectangleBorder(
          //           side: BorderSide.none,
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(8),
          //           )
          //         )
          //       ),
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          //         child: Row(
          //           children: [
          //             Icon(
          //               Icons.schedule,
          //               color: Colors.white,
          //               size: 16
          //             ),
          //             Text(
          //               remainingTimeTextFromDuration(rt),
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 12
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget makeDetailButton(AuctionGood good) {
    switch (good.aucState) {
      case 0:
        return FlatButton(
          shape: Border(),
          color: revaultBlack,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 17.0),
          splashColor: Colors.greenAccent,
          onPressed: () async {
            await Navigator.pushNamed(
              context, '/auctiongooddetail',
              arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
            );
            setState(() {
              auctionList = fetchGoodList(widget.status);
            });
          },
          child: Text(
            "시작시 알림",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
        );
      case 1: 
        return FlatButton(
          shape: Border(),
          color: revaultBlack,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 18.0),
          splashColor: Colors.greenAccent,
          onPressed: () async {
            await Navigator.pushNamed(
              context, '/auctiongooddetail',
              arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
            );
            setState(() {
              auctionList = fetchGoodList(widget.status);
            });
          },
          child: Text(
            "경매 참여",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
        );
      case 2:
        return FlatButton(
          shape: Border(),
          color: revaultBlack,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          splashColor: Colors.greenAccent,
          onPressed: () async {
            await Navigator.pushNamed(
              context, '/auctiongooddetail',
              arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
            );
            setState(() {
              auctionList = fetchGoodList(widget.status);
            });
          },
          child: Text(
            "기록보기",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.0,
            ),
          ),
        );
      default:
        return FlatButton(
          shape: Border(),
          color: revaultGreen,
          textColor: revaultBlack,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          splashColor: Colors.greenAccent,
          onPressed: () {},
          child: Text(
            "잘못된 정보",
            style: TextStyle(fontSize: 16.0),
          ),
        );
    }
  }

  Widget detailSection(AuctionGood good) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFA4A4A4),
            width: 0.2,
          ),
          bottom: BorderSide(
            color: Color(0xFFA4A4A4),
            width: 0.2,
          ),
        ),
      ),
      padding: EdgeInsets.fromLTRB(15, 9, 15, 9),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  good.brand,
                  style: TextStyle(
                    fontSize: 16,
                    color: revaultBlack,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  ),
                ),
                Text(
                  good.goodName,
                  style: TextStyle(
                    fontSize: 16,
                    color: revaultBlack,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      good.price != null ? '${putComma(good.price)}원' : 'priceless',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: -1.0,
                      )
                    ),
                    VerticalDivider(width: 8),
                    Text(
                      '10% 기부',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          makeDetailButton(good),
        ]
      )
    );
  }

  String currSession = "";
  static final storage = new FlutterSecureStorage();
  _asyncMethod() async {
    currSession = await storage.read(key: "session");
    print(currSession);
  }

  @override
  void initState() {
    auctionList = fetchGoodList(widget.status);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFA4A4A4),
            width: 0.2,
          )
        ),
      ),
      child: _buildWithList(),
    );
  }
}