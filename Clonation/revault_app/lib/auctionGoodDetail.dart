import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:revault_app/auctionGood.dart';
import 'package:revault_app/common/aux.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

AuctionGood parseGood(String responseBody) {
  return AuctionGood.fromJson(jsonDecode(responseBody));
}

Future<AuctionGood> fetchGood(int id) async {
  final response = await http.get('https://ibsoft.site/revault/getAuctionInfo?auction_id=$id');
  if (response.statusCode == 200) {
    return compute(parseGood, response.body);
  }
  else {
    throw Exception('상품 정보를 불러오지 못했습니다');
  }
}

class AuctionGoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int goodID = ModalRoute.of(context).settings.arguments; // 2020-11-17 djkim: 상품 ID 가져오기
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("REVAULT"),
      ),
      body: AuctionGoodDetailWithVideo(goodID: goodID,)
    );
  }
}

class AuctionGoodDetailWithVideo extends StatefulWidget{
  final int goodID;
  AuctionGoodDetailWithVideo({Key key, @required this.goodID}) : super(key: key);

  @override
  _AGDWithVideoState createState() => _AGDWithVideoState();
}

class _AGDWithVideoState extends State<AuctionGoodDetailWithVideo> {

  // 입찰가 입력창: 경매 참가 신청 삭제 -> 바로 입찰 가능하게 변경
  Future<void> _showBiddingDialog(int currPrice, int unitPrice) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.verified, size: 100, color: Colors.green),
                  Text(
                    '원하시는 입찰가를 입력하세요',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet, size: 16),
                      Text(
                        ' 현재 입찰가: $currPrice' + '원',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      )
                    ],
                  ),
                  Text(
                    '입찰가는 $unitPrice' + '원 단위로 올릴 수 있습니다',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  BiddingForm(goodID: widget.goodID, price: currPrice, unit: unitPrice, session: currSession, parent: this),
                  Divider(),
                  Text(
                    '안내사항',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text('1. 경매 낙찰 후 낙찰가를 결제하면 상품 배송이 시작됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text('2. 경매에 낙찰이 되지 않았을 시, 입찰가는 결제되지 않습니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text('3. 경매 낙찰 이후, 낙찰가를 결제하지 않으면, 위약금이 부과됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text(
                    '4. 경매제품 특성상, 교환과 반품이 어려운 점 양해바랍니다.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red
                    )
                  ),
                ],
              ),
            )
          ),
        );
      }
    );
  }

  Future<void> _showAutoBiddingDialog(int currPrice, int unitPrice) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AutoBiddingForm(goodID: widget.goodID, price: currPrice, unit: unitPrice, session: currSession, parent: this)
        );
      }
    );
  }

  // 경매 결과 알림창
  Future<void> _showResultDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    '경매가 종료되었습니다!',
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  CircleAvatar(
                    radius: 80.0,
                    backgroundImage:
                      NetworkImage(
                        'https://www.go4thetop.net/assets/images/Staff_Ryunan.jpg'
                      ),
                    backgroundColor: Colors.transparent
                  ),
                  Text(
                    'noname님 축하드립니다.',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Divider(),
                  Text(
                    '결제한 참가비 -100,000원',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '총 기부금액 ',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Text(
                          '115,000원',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          )
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 50.0),
                    splashColor: Colors.black,
                    onPressed: () => Navigator.pushNamed(context, '/myparticipations'),
                    child: Text(
                      "경매 진행내역 보기",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      }
    );
  }

  Future<void> _showCommentsDialog(List<Comment> comments) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: 400.0,
                    width: 300.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      itemCount: comments.length,
                      itemBuilder: (BuildContext _context, int i) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                    NetworkImage(
                                      'https://www.go4thetop.net/assets/images/Staff_Ryunan.jpg'
                                    ),
                                  backgroundColor: Colors.transparent,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${comments[i].username}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          )
                                        ),
                                        VerticalDivider(),
                                        Text(
                                          commentTimeTextFromDate(comments[i].date),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          )
                                        ),
                                      ]
                                    ),
                                    Text('${comments[i].content}',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider()
                          ]
                        );
                      }
                    ),
                  ),
                ),
                CommentForm(goodID: widget.goodID, session: currSession, parent: this),
              ],
            )
          )
        );
      } 
    );
  }

  VideoPlayerController sampleVideoController;
  Future<void> _initializeVideoPlayerFuture;
  List<Widget> sliderItems;
  Future<AuctionGood> currentGood;
  String currSession;
  _asyncMethod() async {
    currSession = await isLogged();
    print(currSession);
  }

  @override
  void initState() {
    sampleVideoController = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
    );
    _initializeVideoPlayerFuture = sampleVideoController.initialize();
    
    sliderItems = [1,2,3].map((i) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Image.asset(
              'images/nike_black_hoodie$i.jpeg',
              fit: BoxFit.cover,
            )
          );
        },
      );
    }).toList();

    sliderItems.add(
      Builder(
        builder: (BuildContext context) {
          return Container(width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                    aspectRatio: sampleVideoController.value.aspectRatio,
                    child: VideoPlayer(sampleVideoController)
                  );
                }
                else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            )
          );
        },
      )
    );

    currentGood = fetchGood(widget.goodID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    sampleVideoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Center(
        child: FutureBuilder<AuctionGood>(
          future: currentGood,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  // 텍스트 정보 부분
                  Text(
                    snapshot.data.goodName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),
                  Text(snapshot.data.goodName,
                    style: TextStyle(
                      fontSize: 18,
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 14),
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(snapshot.data.seller, style: TextStyle(fontSize: 14)),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('SIZE: ${snapshot.data.size}', style: TextStyle(fontSize: 14)),
                      ),
                      Text('Condition: ${snapshot.data.condition}', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  remainingTimeDisplay(snapshot.data.endDate, snapshot.data.biddingList.length),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 360.0,
                      enableInfiniteScroll: false,
                      autoPlay: false
                    ),
                    items: sliderItems,
                  ),
                  Text(
                    snapshot.data.price.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )
                  ),
                  Text(
                    snapshot.data.biddingList.length > 0 ?
                    '${snapshot.data.biddingList[0].username} 님께서 최근 입찰하셨습니다.'
                    : '아직 입찰한 사람이 없습니다. 지금 입찰해보세요!'
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)
                    ),
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    splashColor: Colors.greenAccent,
                    onPressed: () => {
                      _showBiddingDialog(snapshot.data.price, snapshot.data.unitPrice)
                    },
                    child: Text(
                      "BID UP",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green)
                    ),
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    splashColor: Colors.greenAccent,
                    onPressed: () => {
                      _showResultDialog()
                    },
                    child: Text(
                      "경매 결과창 테스트",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: '자동입찰 설정하기',
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                          _showAutoBiddingDialog(snapshot.data.price, snapshot.data.unitPrice)
                        }
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: Border(
                        top: BorderSide(color: Colors.grey, width: 1.0),
                        bottom: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      color: Colors.white,
                      textColor: Colors.black,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      child: Icon(Icons.keyboard_arrow_up),
                      onPressed: () => {
                        _showCommentsDialog(snapshot.data.commentList)
                      },
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage:
                          NetworkImage(
                            'https://www.go4thetop.net/assets/images/Staff_Ryunan.jpg'
                          ),
                        backgroundColor: Colors.transparent,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          snapshot.data.commentList.length > 0 ?
                          Row(
                            children: [
                              Text(
                                '${snapshot.data.commentList[0].username}', // 여기에 items.length - 1을 넣고 싶은데 어떻게 해야할까?
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ),
                              VerticalDivider(),
                              Text(
                                commentTimeTextFromDate(snapshot.data.commentList[0].date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                )
                              ),
                            ]
                          )
                          : Text('이 상품에 대한 반응이 아직 없습니다'),
                          snapshot.data.commentList.length > 0 ?
                          Text('${snapshot.data.commentList[0].content}',
                            style: TextStyle(
                              fontSize: 14,
                            )
                          )
                          : Text('첫 반응을 작성하세요!'),
                        ],
                      ),
                    ],
                  ),
                  Divider()
                ],
              );
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        )
      )
    );
  }
}

class BiddingForm extends StatefulWidget {
  final int price;
  final int unit;
  final int goodID;
  final String session;
  _AGDWithVideoState parent;

  BiddingForm({Key key, @required this.goodID, @required this.price, @required this.unit,
    @required this.session, @required this.parent}) : super(key: key);

  @override
  BiddingFormState createState() {
    return BiddingFormState();
  }
}

class BiddingFormState extends State<BiddingForm> {
  
  final _formKey = GlobalKey<FormState>();
  int selectedPrice;

  Future<http.Response> addBidding(int id, int price) async {
    //final http.Response response = await

    var map = new Map<String, dynamic>();
    map['auction_id'] = id.toString();
    map['price'] = price.toString();

    return http.post(
      'https://ibsoft.site/revault/addBidLog',
      headers: <String, String>{
        'Cookie': widget.session,
      },
      body: map,
    );
  } 

  @override void initState() {
    selectedPrice = widget.price + widget.unit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '희망 입찰가',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      selectedPrice.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
                ),
                VerticalDivider(),
                Column(
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        // (selectedPrice == widget.price + widget.unit)
                        setState(() {
                          selectedPrice += widget.unit;
                        });
                      },
                      child: Text(
                        '+${widget.unit}원',
                        style: TextStyle(fontSize: 16.0)
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: (selectedPrice == widget.price + widget.unit) ? null
                        : () {
                        setState(() {
                          selectedPrice -= widget.unit;
                        });
                      },
                      child: Text(
                        '-${widget.unit}원',
                        style: TextStyle(fontSize: 16.0)
                      ),
                    ),
                  ],
                ),
              ],
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
              ),
              color: Colors.black,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.transparent,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  http.Response response = await addBidding(widget.goodID, selectedPrice);
                  print(response.statusCode);
                  print(response.body);
                  if (response.statusCode == 200) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('입찰가 제출에 성공했습니다')));
                    this.widget.parent.setState(() {
                      this.widget.parent.currentGood = fetchGood(widget.goodID);
                    });
                    Navigator.pop(context);
                  }
                  else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                  }
                }
              },
              child: Text(
                '입찰가 제출',
                style: TextStyle(fontSize: 16.0)
              ),
            ),
          ]
      )
      )
    );
  }
}

class AutoBiddingForm extends StatefulWidget {
  final int price;
  final int unit;
  final int goodID;
  final String session;
  _AGDWithVideoState parent;
  AutoBiddingForm({Key key, @required this.goodID, @required this.price, @required this.unit,
    @required this.session, @required this.parent}) : super(key: key);

  @override
  AutoBiddingFormState createState() {
    return AutoBiddingFormState();
  }
}

class AutoBiddingFormState extends State<AutoBiddingForm> {

  final _formKey = GlobalKey<FormState>();
  int selectedPrice;

  // TODO: Auto Bidding API 호출
  // Future<http.Response> addAutoBidding(int id, int price) async {
  //   //final http.Response response = await

  //   var map = new Map<String, dynamic>();
  //   map['auction_id'] = id.toString();
  //   map['price'] = price.toString();

  //   return http.post(
  //     'https://ibsoft.site/revault/addBidLog',
  //     headers: <String, String>{
  //       'Cookie': widget.session,
  //     },
  //     body: map,
  //   );
  // }

  @override void initState() {
    selectedPrice = widget.price + widget.unit;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              '자동입찰 가격 설정',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              indent: 50,
              endIndent: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, size: 16),
                Text(
                  ' 현재 입찰가: ${widget.price}원',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold
                  )
                )
              ],
            ),
            Text(
              '입찰가는 ${widget.unit}원 단위로 올릴 수 있습니다',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )
            ),
            Divider(
              indent: 50,
              endIndent: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '희망 입찰가',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      selectedPrice.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ]
                ),
                VerticalDivider(),
                Column(
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          selectedPrice += 10 * widget.unit;
                        });
                      },
                      child: Transform.rotate(
                        angle: 270 * pi / 180,
                        child: Icon(
                            Icons.fast_forward,
                            color: Colors.white,
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        setState(() {
                          selectedPrice += widget.unit;
                        });
                      },
                      child: Transform.rotate(
                        angle: 270 * pi / 180,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: (selectedPrice == widget.price + widget.unit) ? null
                        : () {
                        setState(() {
                          selectedPrice -= widget.unit;
                        });
                      },
                      child: Transform.rotate(
                        angle: 90 * pi / 180,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)
                      ),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.transparent,
                      onPressed: (selectedPrice >= widget.price + 10 * widget.unit)
                        ? () {
                          setState(() {
                            selectedPrice -= 10 * widget.unit;
                          });
                        }
                      : null,
                      child: Transform.rotate(
                        angle: 90 * pi / 180,
                        child: Icon(
                          Icons.fast_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.transparent,
                  disabledTextColor: Colors.grey,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('자동입찰 설정 취소')));
                    Navigator.pop(context);
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(fontSize: 16.0)
                  ),
                ),
                VerticalDivider(),
                RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.transparent,
                  disabledTextColor: Colors.grey,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // TODO: API 호출 및 처리
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('자동입찰 설정 진행중')));
                    }
                  },
                  child: Text(
                    '완료',
                    style: TextStyle(fontSize: 16.0)
                  ),
                ),
              ],
            ),
          ]
      )
      )
    );
  }
}

class CommentForm extends StatefulWidget {
  final int goodID;
  final String session;
  _AGDWithVideoState parent;

  CommentForm({Key key, @required this.goodID,
    @required this.session, @required this.parent}) : super(key: key);

  @override
  CommentFormState createState() {
    return CommentFormState();
  }
}

class CommentFormState extends State<CommentForm> {
  
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> addComment(int id, String comment) {

    var map = new Map<String, dynamic>();
    map['auction_id'] = id.toString();
    map['content'] = comment;

    return http.post(
      'https://ibsoft.site/revault/addAuctionComment',
      headers: <String, String>{
        'Cookie': widget.session,
      },
      body: map,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: 'Enter your comment',
                labelText: '댓글 입력'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your comment';
                }
                return null;
              },
            ),
          ),
          RaisedButton(
            color: Colors.black,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.black,
            padding: EdgeInsets.all(8.0),
            splashColor: Colors.transparent,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                http.Response response = await addComment(widget.goodID, _passController.text);
                print(response.statusCode);
                print(response.body);
                if (response.statusCode == 200 || response.statusCode == 201) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('댓글 작성에 성공했습니다')));
                  this.widget.parent.setState(() {
                    this.widget.parent.currentGood = fetchGood(widget.goodID);
                  });
                  Navigator.pop(context);
                }
                else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                }
              }
            },
            child: Text(
              '댓글 달기',
              style: TextStyle(fontSize: 14.0)
            ),
          ),
        ],
      ),
    );
  }
}