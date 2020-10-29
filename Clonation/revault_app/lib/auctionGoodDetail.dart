import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:revault_app/comment.dart';
import 'package:video_player/video_player.dart';

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

  // 경매 참가 확인창
  Future<void> _showAddmissionDialog() async {
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
                    '참가비를 결제하시겠습니까?',
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
                        '현재잔액 80,000원',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, size: 16),
                      Text(
                        '결제금액 21,000원',
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
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black)
                    ),
                    color: Colors.black,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 80.0),
                    splashColor: Colors.greenAccent,
                    onPressed: () => {
                      
                    },
                    child: Text(
                      "결제하기",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  // TODO: 현재 잔액과 결제 금액을 비교하여 잔액이 부족하면 경고 메시지 띄우기
                  Divider(),
                  Text(
                    '안내사항',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    '1. 참가비는 경매 상품 시작가의 10%로 책정됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text('2. 경매 낙찰 후 잔액을 결제하면 상품 배송이 시작됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text('3. 경매에 낙찰이 되지 않았을 시, 참가비는 환불됩니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text('4. 경매 낙찰 이후, 잔액을 결제하지 않으면, 참가비는 환불되지 않습니다.',
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                  Text(
                    '5. 경매제품 특성상, 교환과 반품은 불가능합니다.',
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

  Future<void> _showAutoBiddingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('자동입찰 가격설정')
          ),
          body: AlertDialog(
            content: AutoBiddingForm()
          )
        );
      }
    );
  }

  List<Comment> items = [
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
                    itemCount: items.length,
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
                                        '${items[i].username}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )
                                      ),
                                      VerticalDivider(),
                                      Text('${items[i].date}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        )
                                      ),
                                    ]
                                  ),
                                  Text('${items[i].content}',
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
        child: Column(
          children: [
            // 텍스트 정보 부분
            Text(
              'NIKE ACG',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              )
            ),
            Text('Jacket With Gloves',
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
                  child: Text('KIDMILLE', style: TextStyle(fontSize: 14)),
                ),
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Text('SIZE: M', style: TextStyle(fontSize: 14)),
                ),
                Text('Condition: A', style: TextStyle(fontSize: 14)),
              ],
            ),
            Divider(
              indent: 50,
              endIndent: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.red),
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    '남은시간 : 2시간 10분',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red
                    )
                  ),
                ),
                Icon(Icons.person, size: 14),
                Text(
                  '20명 참여 중',
                  style: TextStyle(
                    fontSize: 14
                  ),
                )
              ],
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 360.0,
                enableInfiniteScroll: false,
                autoPlay: false
              ),
              items: sliderItems,
            ),
            Text(
              '210000',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              )
            ),
            Text('Noname 님께서 최근 입찰하셨습니다.'),
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
                _showAddmissionDialog()
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
                    _showAutoBiddingDialog()
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
                          '${items[9].username}', // 여기에 items.length - 1을 넣고 싶은데 어떻게 해야할까?
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )
                        ),
                        VerticalDivider(),
                        Text('${items[9].date}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          )
                        ),
                      ]
                    ),
                    Text('${items[9].content}',
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
        )
      )
    );
  }
}

class AutoBiddingForm extends StatefulWidget {
  @override
  AutoBiddingFormState createState() {
    return AutoBiddingFormState();
  }
}

class AutoBiddingFormState extends State<AutoBiddingForm> {
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController _passController = new TextEditingController();
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                RaisedButton(
                  color: Colors.transparent,
                  textColor: Colors.teal,
                  disabledColor: Colors.transparent,
                  disabledTextColor: Colors.grey,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('자동입찰 설정 취소')));
                  },
                  child: Text(
                    '취소하기',
                    style: TextStyle(fontSize: 16.0)
                  ),
                ),
                Text(
                    '자동입찰 가격설정',
                    textAlign: TextAlign.center
                ),
                RaisedButton(
                  color: Colors.transparent,
                  textColor: Colors.teal,
                  disabledColor: Colors.transparent,
                  disabledTextColor: Colors.grey,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.transparent,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
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
            TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
                labelText: 'Auto-bidding Price'
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your wishing price';
                }
                return null;
              },
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
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('댓글 달기 진행중')));
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