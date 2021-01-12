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
                expandedHeight: 50.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("REVAULT"),
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
                    indicatorColor: Color(0xFF80F208),
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
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
        imageSection(good),
        Divider(thickness: 2),
        detailSection(good),
        Divider(thickness: 5,),
      ],
    );
  }

  Widget imageSection(AuctionGood good) {
    if (good.aucState == 2) {
      return Stack(
        children: [
          Image.asset(
            'images/nike_black_hoodie1.jpeg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            color: Colors.grey,
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                      AssetImage(
                        'images/revault_square_logo.jpg',
                      ),
                      // NetworkImage(
                      //   'https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg'
                      // ),
                    backgroundColor: Colors.transparent
                  ),
                  Text(
                    '${good.winner}님에게 낙찰',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(
                    '최종 낙찰가 ${good.price}원',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                ],
              ),
            ),
          ),
        ]
      );
    }

    return Stack(
      children: [
        Image.asset(
          'images/nike_black_hoodie1.jpeg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Container(
          width: 100.0,
          height: 90.0,
          alignment: Alignment.topLeft,
          child: Container(
            width: 80.0,
            height: 33.0,
            child: ClipRect(
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: Color(0xFFE92D2D),
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    )
                  )
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 16
                      ),
                      Text(
                        remainingTimeTextFromDate(good.endDate),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 80.0,
          height: 90.0,
          alignment: Alignment.bottomLeft,
          child: ClipRect(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: Color(0xFF2C4FDE),
                shape: RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  )
                )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 16
                    ),
                    Text(
                      remainingTimeTextFromDate(good.endDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]
    );
  }

  Widget makeDetailButton(AuctionGood good) {
    switch (good.aucState) {
      case 0:
        return RaisedButton(
          color: Color(0xFF80F208),
          textColor: Colors.black,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          splashColor: Colors.greenAccent,
          onPressed: () => Navigator.pushNamed(
            context, '/auctiongooddetail',
            arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
          ),
          child: Text(
            "시작시 알림",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 1: 
        return RaisedButton(
          color: Color(0xFF80F208),
          textColor: Colors.black,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          splashColor: Colors.greenAccent,
          onPressed: () => Navigator.pushNamed(
            context, '/auctiongooddetail',
            arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
          ),
          child: Text(
            "경매 참여",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 2:
        return RaisedButton(
          color: Colors.black,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.grey[700],
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
          splashColor: Colors.greenAccent,
          onPressed: () => Navigator.pushNamed(
            context, '/auctiongooddetail',
            arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
          ),
          child: Text(
            "기록 보기",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      default:
        return RaisedButton(
          color: Color(0xFF80F208),
          textColor: Colors.black,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '[${good.brand}]${good.goodName}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.person_outline_outlined, size: 16),
                    Text(good.seller),
                    VerticalDivider(width: 10),
                    Text('SIZE : '),
                    Text(good.condition != null ? good.condition: 'F'),
                    VerticalDivider(width: 10),
                    Text('CONDITION : '),
                    Text(good.size != null ? good.size: 'Free')
                  ],
                ),
                Row(
                  children: [
                    Text(
                      good.price != null ? '${good.price}원' : 'priceless',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      )
                    ),
                    VerticalDivider(width: 5),
                    ClipRect(
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: Colors.black,
                          shape: RoundedRectangleBorder(
                            side: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            )
                          )
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 1, 5, 2),
                          child: Text(
                            '10% 기부',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          ),
                        ),
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
    return _buildWithList();
  }
}