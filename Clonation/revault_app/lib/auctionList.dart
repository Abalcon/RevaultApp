import 'package:flutter/material.dart';
import 'semiRoundedButton.dart';
import 'auctionGood.dart';

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
                        Text('a', style: TextStyle(color: Colors.green))
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
                    labelColor: Colors.white,
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
            // TODO: 실제 데이터 집어넣기
            children: <Widget> [
              Center(child: AuctionGoods()),
              Center(child: AuctionGoods()),
              Center(child: AuctionGoods()),
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
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
  @override
  _AuctionGoodsState createState() => _AuctionGoodsState();
}

class _AuctionGoodsState extends State<AuctionGoods> {
  final List<AuctionGood> _examples = <AuctionGood>[];

  Widget _buildExample() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider(thickness: 5);
        }

        final int index = i ~/ 2;
        if (index >= _examples.length) {
          _examples.add(generateExample());
        }
        return _buildRow(_examples[index]);
      }
    );
  }

  AuctionGood generateExample() {
    var example = AuctionGood(
      seller: 'KIDMILLE',
      condition: 'S',
      size: 'XL',
      startDate: '2020-10-12',
      endDate: '2020-10-16',
      brand: 'NIKE',
      goodName: 'Black Hoodie',
      price: '230,000원',
      sellState: '경매 진행중'
    );

    return example;
  }

  Widget _buildRow(AuctionGood good) {
    return Column(
      children: [
        sellerSection(good),
        Divider(),
        imageSection(good),
        Divider(),
        detailSection(good)
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
    return Stack(
      children: [
        Image.asset(
          'images/nike_black_hoodie1.jpeg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Container(
          width: 90.0,
          height: 90.0,
          alignment: Alignment.topLeft,
          child: Container(
            width: 80.0,
            height: 40.0,
            child: new SemiRoundedBorderButton(
              borderSide: const BorderSide(color: Colors.red, width: 0),
              radius: const Radius.circular(20.0),
              background: Colors.red,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.white,
                      size: 18
                    ),
                    Text(
                      '1일 남음',
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
          width: 90.0,
          height: 90.0,
          alignment: Alignment.bottomLeft,
          child: new SemiRoundedBorderButton(
            borderSide: const BorderSide(color: Colors.green, width: 0),
            radius: const Radius.circular(20.0),
            background: Colors.green,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
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
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Text(
                  good.goodName != null ? good.goodName : 'empty',
                ),
                Text(
                  good.price != null ? good.price : 'priceless',
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
            onPressed: () => Navigator.pushNamed(context, '/auctiongooddetail'),
            child: Text(
              "자세히 보기",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildExample();
  }
}

class AuctionTabBar extends StatefulWidget {
  @override
  AuctionTabBarState createState() {
    return AuctionTabBarState();
  }
}

class AuctionTabBarState extends State<AuctionTabBar> with TickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material (
        child: TabBar(
          tabs: <Tab> [
            Tab(text: "LIVE"),
            Tab(text: "UPCOMING"),
            Tab(text: "ENDED"),
          ],
          controller: controller,
        ),
        color: Colors.blue,
      ),
      body: TabBarView(
        children: <Widget> [
          Text("LIVE"),
          Text("UPCOMING"),
          Text("ENDED"),
        ],
        controller: controller,
      )
    );
  }
}