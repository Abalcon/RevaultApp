import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/common/aux.dart';
import 'semiRoundedButton.dart';
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
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () => Navigator.pushNamed(context, '/mypage'),
                  ),
                ],
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(child: Text("LIVE", style: Theme.of(context).textTheme.headline6)),
                      Tab(child: Text("UPCOMING", style: Theme.of(context).textTheme.headline6)),
                      Tab(child: Text("ENDED", style: Theme.of(context).textTheme.headline6)),
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
        sellerSection(good),
        Divider(thickness: 2),
        imageSection(good),
        Divider(thickness: 2),
        detailSection(good),
        Divider(thickness: 5,),
      ],
    );
  }

  Widget sellerSection(AuctionGood good) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.person),
              Text(good.seller != null ? good.seller : 'empty')
            ],
          ),
        ),
        Icon(Icons.verified),
        Text(good.condition != null ? good.condition: 'F'),
        Icon(Icons.checkroom),
        Text(good.size != null ? good.size: 'Free')
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
            width: 90.0,
            height: 40.0,
            child: new SemiRoundedBorderButton(
              borderSide: const BorderSide(color: Colors.red, width: 0),
              radius: const Radius.circular(20.0),
              background: Colors.red,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 18
                    ),
                    Text(
                      remainingTimeTextFromDate(good.endDate),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ),
        Container(
          width: 100.0,
          height: 90.0,
          alignment: Alignment.bottomLeft,
          child: new SemiRoundedBorderButton(
            borderSide: const BorderSide(color: Colors.green, width: 0),
            radius: const Radius.circular(20.0),
            background: Colors.green,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.military_tech,
                    color: Colors.white,
                    size: 18
                  ),
                  Text(
                    '100개 한정',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    ),
                  ),
                ],
              )
            )
          ),
        ),
      ]
    );
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
                    good.brand != null ? good.brand : 'empty',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )
                  ),
                ),
                Text(
                  good.goodName != null ? good.goodName : 'empty',
                  style: TextStyle(
                    fontSize: 16,
                  )
                ),
                Text(
                  good.price != null ? '${good.price}원' : 'priceless',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  )
                ),
              ],
            ),
          ),
          RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.greenAccent,
            onPressed: () => Navigator.pushNamed(
              context, '/auctiongooddetail',
              arguments: good.auctionID // 2020-11-17 djkim: 상품 ID 가져오기
            ),
            child: Text(
              "자세히 보기",
              style: TextStyle(fontSize: 20.0),
            ),
          )
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