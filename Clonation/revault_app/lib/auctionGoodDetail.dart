import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:revault_app/comment.dart';
import 'package:revault_app/common/aux.dart';
import 'package:video_player/video_player.dart';
import 'auctionGood.dart';
import 'package:http/http.dart' as http;

class AuctionGoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("REVAULT"),
      ),
      body: AuctionGoodDetailWithVideo()
    );
  }
}

class AuctionGoodDetailWithVideo extends StatefulWidget{
  @override
  _AGDWithVideoState createState() => _AGDWithVideoState();
}

class _AGDWithVideoState extends State<AuctionGoodDetailWithVideo> {

  // 입찰가 입력창: 경매 참가 신청 삭제 -> 바로 입찰 가능하게 변경
  Future<void> _showAddmissionDialog(int currPrice) async {
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
                        '현재 입찰가 $currPrice\$원',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        )
                      )
                    ],
                  ),
                  Divider(
                    indent: 50,
                    endIndent: 50,
                  ),
                  BiddingForm(price: currPrice),
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

  List<Comment> comments = [
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 31),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 32),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 33),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 34),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 35),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 36),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 37),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 38),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 39),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
    Comment(
      username: 'USER2020',
      date: DateTime(2020, 10, 27, 10, 40),
      content: '이 상품은 제가 꼭 낙찰받고 싶네요!'
    ),
  ];

  Future<void> _showCommentsDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          content: Column(
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
                                      Text('${comments[i].date}',
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
              CommentForm(),
            ],
          )
        );
      } 
    );
  }

  VideoPlayerController sampleVideoController;
  Future<void> _initializeVideoPlayerFuture;
  List<Widget> sliderItems;
  Future<AuctionGood> currentGood;

  AuctionGood parseGood(String responseBody) {
    return AuctionGood.fromJson(jsonDecode(responseBody));
  }

  Future<AuctionGood> fetchGood() async {
    final response = await http.get('https://ibsoft.site/revault/getAuctionInfo?auction_id=1');
    if (response.statusCode == 200) {
      return compute(parseGood, response.body);
    }
    else {
      throw Exception('상품 정보를 불러오지 못했습니다');
    }
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

    currentGood = fetchGood();    

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
                  Text('${snapshot.data.biddingList[0].username} 님께서 최근 입찰하셨습니다.'),
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
                      // TODO: 입찰 등록 POST
                      _showAddmissionDialog(snapshot.data.price)
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
                        _showCommentsDialog()
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
                          Row(
                            children: [
                              Text(
                                '${comments[9].username}', // 여기에 items.length - 1을 넣고 싶은데 어떻게 해야할까?
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                )
                              ),
                              VerticalDivider(),
                              Text('${comments[9].date}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                )
                              ),
                            ]
                          ),
                          Text('${comments[9].content}',
                            style: TextStyle(
                              fontSize: 14,
                            )
                          ),
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

  BiddingForm({Key key, @required this.price}) : super(key: key);

  @override
  BiddingFormState createState() {
    return BiddingFormState();
  }
}

class BiddingFormState extends State<BiddingForm> {
  
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> addBidding(int price) async {
    //final http.Response response = await
    return http.post(
      'https://ibsoft.site/revault/addBidLog',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // TODO: jsession이 여기에 들어가야한다 - jsession 저장 기능 구현 필요
      },
      body: jsonEncode(<String, int>{
        'price': price,
      }),
    );

    // TODO: 새로운 입찰가 및 사용자 이름을 반영하여 다시 build
    // if (response.statusCode == 201) {
    //   return Album.fromJson(jsonDecode(response.body));
    // } else {
    //   throw Exception('입찰가 신청에 실패했습니다. 다시 시도해주세요');
    // }
  } 

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: '새로운 입찰가를 입력하세요',
                labelText: '새로운 입찰가를 입력하세요'
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return '원하시는 입찰가를 입력하세요';
                }
                else if (int.parse(value) <= widget.price) {
                  return '현재 입찰가보다 더 높은 가격을 입력하세요';
                }
                return null;
              },
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
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  addBidding(int.parse(_passController.text));
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

class CommentForm extends StatefulWidget {
  @override
  CommentFormState createState() {
    return CommentFormState();
  }
}

class CommentFormState extends State<CommentForm> {
  
  final _formKey = GlobalKey<FormState>();

  Future<http.Response> addComment(String comment) {
    return http.post(
      'https://ibsoft.site/revault/addComment',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // TODO: jsession이 여기에 들어가야한다 - jsession 저장 기능 구현 필요
      },
      body: jsonEncode(<String, String>{
        'content': comment,
      }),
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
            onPressed: () {
              if (_formKey.currentState.validate()) {
                addComment(_passController.text);
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