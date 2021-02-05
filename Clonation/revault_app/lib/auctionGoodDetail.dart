import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flip_panel/flip_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:revault_app/auctionGood.dart';
import 'package:revault_app/common/aux.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'userInfo.dart';

AuctionGood parseGood(String responseBody) {
  return AuctionGood.fromJson(jsonDecode(responseBody));
}

Future<AuctionGood> fetchGood(int id) async {
  final response = await http.get('https://ibsoft.site/revault/getAuctionInfo?auction_id=$id');
  debugPrint('AGD: ${response.statusCode}');
  if (response.statusCode == 200) {
    return compute(parseGood, response.body);
  }
  else {
    throw Exception('상품 정보를 불러오지 못했습니다');
  }
}

Future<bool> checkVerify(String session) async {
  UserInfo userInfo = await getInfo(session);
  debugPrint("Verify Info: ${userInfo.niceDI}");
  return (userInfo.niceDI != null);
}

class AuctionGoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int goodID = ModalRoute.of(context).settings.arguments; // 2020-11-17 djkim: 상품 ID 가져오기
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'images/revault_rectangle_logo.png',
          width: MediaQuery.of(context).size.width * 0.25,
        ),
      ),
      body: AuctionGoodDetailWithVideo(
        goodID: goodID,
      ),
    );
  }
}

class AuctionGoodDetailWithVideo extends StatefulWidget{
  final int goodID;
  //final WebSocketChannel channel;
  AuctionGoodDetailWithVideo({Key key,
    @required this.goodID, /*@required this.channel*/}) : super(key: key);

  @override
  _AGDWithVideoState createState() => _AGDWithVideoState();
}

class _AGDWithVideoState extends State<AuctionGoodDetailWithVideo> {

  // 입찰가 입력창: 경매 참가 신청 삭제 -> 바로 입찰 가능하게 변경
  Future<void> _showBiddingModal(int currPrice, int unitPrice) async {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.only(
            top: 20
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 120,
                  color: revaultGreen,
                ),
                Divider(color: Colors.transparent),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wallet_giftcard, size: 30, color: revaultBlack),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: revaultBlack,
                          fontSize : 22,
                          letterSpacing: -1.0,
                        ),
                        children: [
                          TextSpan(
                            text: ' 현재 입찰가: ',
                          ),
                          TextSpan(
                            text: '${putComma(currPrice)}원',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: revaultBlack,
                      fontSize : 22,
                      letterSpacing: -1.0,
                    ),
                    children: [
                      TextSpan(
                        text: putComma(currPrice + unitPrice),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '원으로 입찰하시겠습니까?',
                      ),
                    ],
                  ),
                ),
                BiddingForm(goodID: widget.goodID, price: currPrice, unit: unitPrice, session: currUser.getSession(), parent: this),
                Divider(color: Color(0xFF828282), height: 50,),
                Text(
                  '안내사항',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.0,
                  )
                ),
                Divider(color: Colors.transparent),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 55),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize : 13,
                        letterSpacing: -1.0,
                      ),
                      children: [
                        TextSpan(
                          text: '1. 경매 낙찰 후 낙찰가를 결제하면 상품 배송이 시작됩니다.',
                        ),
                        TextSpan(
                          text: '\n\n2. 낙찰가는 두 번째로 높은 입찰가(세컨 프라이스)로 결정됩니다.'),
                        TextSpan(
                          text: '\n\n3. 경매에 낙찰이 되지 않았을 시, 입찰가는 결제되지 않습니다.',
                        ),
                        TextSpan(
                          text: '\n\n4. 경매 낙찰 이후, 낙찰가를 결제하지 않으면, 위약금이 부과됩니다.',
                        ),
                        TextSpan(
                          text: '\n\n5. 경매제품 특성상, 교환과 반품은 불가능합니다.',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  // 경매 결과 알림창
  Future<void> _showResultDialog(AuctionGood good) async {
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
                      AssetImage(
                        'images/revault_square_logo.jpg',
                      ),
                      // NetworkImage(
                      //   'https://revault.co.kr/web/upload/NNEditor/20201210/94b9ab77d43e7672ba4d14e021235d0e.jpg'
                      // ),
                    backgroundColor: Colors.transparent
                  ),
                  Text(
                    '${good.biddingList[0].username}님 축하드립니다.',
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Divider(),
                  Text(
                    '결제한 참가비 -100,000원',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold
                    ),
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
                          ),
                        ),
                        Text(
                          '115,000원',
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  Text(
                    // 임시
                    good.winner == null ? '아직 낙찰자가 나오지 않았습니다'
                    : '${good.winner}님께서 ${putComma(good.price)}원에 낙찰되셨습니다',
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                    )
                  ),
                  FlatButton(
                    shape: Border(),
                    color: revaultBlack,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: revaultBlack,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 50.0),
                    splashColor: revaultBlack,
                    onPressed: () => Navigator.pushNamed(context, '/myparticipations'),
                    child: Text(
                      "경매 진행내역 보기",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1.0,
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

  Future<void> _showCommentsModal(List<Comment> comments) async {
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
                      itemCount: comments.length,
                      itemBuilder: (BuildContext _context, int i) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 21.0, right: 5.0),
                                  child: CircleAvatar(
                                    radius: 16.0,
                                    backgroundImage: (comments[i].profile != null)
                                      ? NetworkImage(comments[i].profile)
                                      : AssetImage('images/revault_square_logo.jpg'),
                                    backgroundColor: Colors.transparent,
                                  ),
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
                                            fontSize: 11,
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
                            Divider(color: Color(0xFFE0E0E0),),
                          ]
                        );
                      }
                    ),
                  ),
                ),
                Divider(thickness: 1),
                CommentForm(goodID: widget.goodID, session: currUser.getSession(), parent: this),
              ],
            ),
          ),
        );
      } 
    );
  }

  Widget interactingSection(AuctionGood good) {
    switch (good.aucState) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFE0E0E0),
              ),
            ),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 150),
          child: waitingSection(good),
        );
      case 1:
        return biddingSection(good);
      case 2:
        return recordSection(good.biddingList);
      case -1:
        return Text('이 상품은 경매가 취소되었습니다');
      default:
        return Text('This page is hacked by...');
    }
  }

  Widget waitingSection(AuctionGood good) {
    if (good.waitingCount < 1) {
      return Text('이 상품의 경매를 기다리는 회원이 아직 없습니다\n지금 예약하세요!');
    }
    else if (good.waitingCount == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16.0,
            backgroundImage:
              NetworkImage(
                good.waitingProfileList[0],
              ),
            backgroundColor: Colors.transparent,
          ),
          Text('를 비롯한 ${good.waitingCount}명의 회원들이 경매를 기다리고 있습니다',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: -1.0,
            )
          ),
        ],
      );
    }
    else if (good.waitingCount == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 52.0,
                height: 32.0,
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 16.0,
                  backgroundImage:
                    NetworkImage(
                      good.waitingProfileList[0],
                    ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              Container(
                width: 52.0,
                height: 32.0,
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  radius: 16.0,
                  backgroundImage: (good.waitingProfileList.length > 1) ?
                    NetworkImage(good.waitingProfileList[1],) :
                    AssetImage('images/revault_square_logo.jpg',),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
          Text('를 비롯한 ${good.waitingCount}명의 회원들이 경매를 기다리고 있습니다',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: -1.0,
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              width: 70.0,
              height: 32.0,
              alignment: Alignment.centerLeft,
              child: CircleAvatar(
                radius: 16.0,
                backgroundImage:
                  NetworkImage(
                    good.waitingProfileList[0],
                  ),
                backgroundColor: Colors.transparent,
              ),
            ),
            Container(
              width: 70.0,
              height: 32.0,
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 16.0,
                backgroundImage: (good.waitingProfileList.length > 1) ?
                  NetworkImage(good.waitingProfileList[1],) :
                  AssetImage('images/revault_square_logo.jpg',),
                backgroundColor: Colors.transparent,
              ),
            ),
            Container(
              width: 70.0,
              height: 32.0,
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 16.0,
                backgroundImage: (good.waitingProfileList.length > 2) ?
                  NetworkImage(good.waitingProfileList[2],) :
                  AssetImage('images/revault_square_logo.jpg',),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
        Text('를 비롯한 ${good.waitingCount}명의 회원들이 경매를 기다리고 있습니다',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }

  Widget biddingSection(AuctionGood good) {
    //final singleDigitWidget = SingleDigit();
    if (channel != null) {
      return Column(
        children: [
          FlipPanel.stream(
            itemStream: channel.stream,
            itemBuilder: (context, value) {
              if (int.tryParse(value) != null) {
                currentPrice = int.parse(value);
              }

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      revaultBlack,
                      Color(0xFF444444),
                      revaultBlack,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 5),
                child: Text(
                  (int.tryParse(value) != null) ? putComma(int.parse(value)) :
                  (value != "connected") ? value : putComma(good.price),
                  style: TextStyle(
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: 44.0,
                    color: Colors.white,
                  ),
                ),
              );
            },
            initValue: putComma(good.price),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 12,),
            child: good.biddingList.length > 0 ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 16.0,
                  backgroundImage: NetworkImage(
                    good.biddingList[0].profile,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: revaultBlack,
                      fontSize : 16,
                      letterSpacing: -1.0
                    ),
                    children: [
                      TextSpan(
                        text: '${good.biddingList[0].username.substring(0, 4)}****',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '님께서 최근 입찰하셨습니다.',
                      )
                    ],
                  ),
                ),
              ],
            ) :
            Text(
              '아직 입찰한 사람이 없습니다. 지금 입찰해보세요!',
              style: TextStyle(
                fontSize: 16,
                letterSpacing: -1.0,
              ),
            ),
          ),
          Container(
            width: 80.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFBDBDBD),
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: Text(
                '₩${putComma(good.unitPrice)}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: revaultBlack,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              color: Color(0xFFBDBDBD),
              height: 6,
              width: 12,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.0),
              ),
              color: revaultGreen,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.grey[600],
              padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 90.0),
              onPressed: () async {
                var isVerified = await checkVerify(currUser.getSession());
                if (isVerified) {
                  if (currentPrice > 0)
                    _showBiddingModal(currentPrice, good.unitPrice);
                  else
                    _showBiddingModal(good.price, good.unitPrice);
                }
                else {
                  await Navigator.pushNamed(
                    context,
                    '/useridentify',
                    arguments: currUser.getSession(),
                  );
                  setState(() {
                    currentGood = fetchGood(widget.goodID);
                  });
                }
              },
              child: Text(
                "BID UP",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          (currUser.getName() == good.autoUser && good.autoPrice > good.price) ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cached,
                color: revaultGreen,
              ),
              Text(
                "${putComma(good.autoPrice)}원 까지 자동입찰 중",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                ),
              )
            ]
          )
          : RichText(
            text: TextSpan(
              text: '자동입찰 설정하기',
              style: TextStyle(
                color: Color(0xFF828282),
                fontSize: 15,
                letterSpacing: -1.0,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 250,//MediaQuery.of(context).size.height * 3 / 5,
                        child: AutoBiddingForm(goodID: widget.goodID, price: good.price,
                          unit: good.unitPrice, session: currUser.getSession(), parent: this),
                      );
                    }
                  );
                }
            ),
          ),
          Divider(color: Colors.transparent),
        ],
      );
    }

    return CircularProgressIndicator();
  }

  Widget recordSection(List<Bidding> bidRecord) {
    return Column(
      children: [
        Container(
          color: revaultBlack,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            '입찰 로그',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            height: 220.0,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 9),
              itemCount: bidRecord.length,
              itemBuilder: (BuildContext _context, int i) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 21),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 14.0,
                                  backgroundImage: NetworkImage(
                                    bidRecord[i].profile,
                                  ),
                                  backgroundColor: Colors.transparent,
                                ),
                                VerticalDivider(),
                                Text(
                                  bidRecord[i].username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                VerticalDivider(),
                                Text(
                                  '|  ${DateFormat('yyyy.MM.dd HH:mm').format(bidRecord[i].date)}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ]
                            ),
                          ),
                          ClipRect(
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                color: (i == 0) ?
                                  revaultGreen : revaultBlack,
                                shape: BeveledRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                  )
                                )
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 6, bottom: 6, left: 22, right: 12),
                                child: Text(
                                  putComma(bidRecord[i].price),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: (i == 0) ?
                                    revaultBlack : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ]
                );
              }
            ),
          ),
        ),
      ]
    );
  }

  Future<http.Response> setAuctionAlarm(int id) async {
    var map = new Map<String, dynamic>();
    map['auction_id'] = id.toString();

    return http.post(
      'https://ibsoft.site/revault/addAlarmAuction',
      headers: <String, String>{
        'Cookie': currUser.getSession(),
      },
      body: map,
    );
  }

  Widget commentSection(AuctionGood good) {
    if (good.aucState == 0) {
      var isWaiting = good.waitingUserList.any((user)
        => currUser.getName() == user);

      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: isWaiting
        ? SizedBox(
          width: double.infinity,
          child: FlatButton(
            shape: Border(),
            color: revaultBlack,
            textColor: Colors.white,
            disabledColor: Colors.grey,
            disabledTextColor: revaultBlack,
            padding: EdgeInsets.all(18.0),
            splashColor: Colors.greenAccent,
            onPressed: () async {
              // TODO: 알림 해제하는 API 호출
            },
            child: Text(
              "알림 해제하기",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
        : SizedBox(
          width: double.infinity,
          child: FlatButton(
            shape: Border(),
            color: revaultGreen,
            textColor: revaultBlack,
            disabledColor: Colors.grey,
            disabledTextColor: Colors.white,
            padding: EdgeInsets.all(18.0),
            splashColor: Colors.greenAccent,
            onPressed: () async {
              http.Response response = await setAuctionAlarm(widget.goodID);
              if (response.statusCode == 200 && response.body == "1") {
                ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('알림을 설정했습니다. 낙찰을 기원합니다')));
                setState(() {
                  currentGood = fetchGood(widget.goodID);
                });
              }
              else {
                ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
              }
            },
            child: Text(
              "경매 시작시 알림 받기",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 0),
              shape: Border(
                top: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1.0),
              ),
              color: Colors.white,
              textColor: revaultBlack,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              child: Icon(
                Icons.keyboard_arrow_up,
              ),
              onPressed: () async {
                await _showCommentsModal(good.commentList);
                setState(() {
                  currentGood = fetchGood(widget.goodID);
                });
              },
            ),
          ),
          FlatButton(
            onPressed: () async {
              await _showCommentsModal(good.commentList);
              setState(() {
                currentGood = fetchGood(widget.goodID);
              });
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 5.0),
                  child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: good.commentList.length > 0
                      ? NetworkImage(good.commentList[0].profile)
                      : NetworkImage('https://ibsoft.site/profile/default_profile.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    good.commentList.length > 0 ?
                    Row(
                      children: [
                        Text(
                          '${good.commentList[0].username}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        VerticalDivider(),
                        Text(
                          commentTimeTextFromDate(good.commentList[0].date),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ]
                    )
                    : Text('이 상품에 대한 반응이 아직 없습니다'),
                    good.commentList.length > 0 ?
                    Text('${good.commentList[0].content}',
                      style: TextStyle(
                        fontSize: 14,
                      )
                    )
                    : Text('첫 반응을 작성하세요!'),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  List<Widget> _sliderItems(List<String> urlList) {
    if (urlList == null || urlList.length == 0) {
      return [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Image.asset(
            'images/revault_square_logo.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ];
    }

    return urlList.map((url) =>
      Builder(
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: FadeInImage.assetNetwork(
              placeholder: 'images/revault_square_logo.jpg',
              image: url,
              fit: BoxFit.cover,
            ),
          );
        },
      )
    ).toList();
  }

  VideoPlayerController sampleVideoController;
  //Future<void> _initializeVideoPlayerFuture;
  Future<AuctionGood> currentGood;
  SessionNamePair currUser;
  WebSocketChannel channel;
  int currentPrice = -1;
  _checkUser() async {
    currUser = await isLogged();
    debugPrint(currUser.getName());
    debugPrint(currUser.getSession());
    if (currUser.getName() == null) {
      // TODO: 회원만 상세 정보를 조회할 수 있어야할까?
    }
  }

  @override
  void initState() {
    // sampleVideoController = VideoPlayerController.network(
    //   'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
    // );
    // _initializeVideoPlayerFuture = sampleVideoController.initialize();

    // sliderItems.add(
    //   Builder(
    //     builder: (BuildContext context) {
    //       return Container(width: MediaQuery.of(context).size.width,
    //         margin: EdgeInsets.symmetric(horizontal: 5.0),
    //         child: FutureBuilder(
    //           future: _initializeVideoPlayerFuture,
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               return AspectRatio(
    //                 aspectRatio: sampleVideoController.value.aspectRatio,
    //                 child: VideoPlayer(sampleVideoController)
    //               );
    //             }
    //             else {
    //               return Center(child: CircularProgressIndicator());
    //             }
    //           }
    //         )
    //       );
    //     },
    //   )
    // );

    // 실시간 입찰 가격 반영용 WebSocket 연결
    debugPrint("Connecting to WebSocket Server...");
    WebSocket.connect('wss://ibsoft.site/revault/ws/chat').then((ws) {
      channel = IOWebSocketChannel(ws);
      debugPrint("WebSocket Connected!");
      debugPrint(channel.protocol);
      debugPrint('${widget.goodID}');
      channel.sink.add('${widget.goodID}');
    }).catchError((error) {
      print(e);
    });

    currentGood = fetchGood(widget.goodID);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUser();
    });

    super.initState();
  }

  @override
  void dispose() {
    //sampleVideoController.dispose();
    channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: FutureBuilder<AuctionGood>(
            future: currentGood,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var good = snapshot.data;
                return Column(
                  children: [
                    Text(
                      good.brand,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: revaultBlack,
                        letterSpacing: -1.0,
                      )
                    ),
                    Text(
                      good.goodName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: revaultBlack,
                        letterSpacing: -1.0,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline, size: 12),
                          Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              good.seller,
                              style: TextStyle(
                                fontSize: 12,
                                color: revaultBlack,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 8),
                            child: Text(
                              'SIZE: ${good.size}',
                              style: TextStyle(
                                fontSize: 12,
                                color: revaultBlack,
                                letterSpacing: -1.0,
                              ),
                            ),
                          ),
                          Text(
                            'CONDITION: ${good.condition}',
                            style: TextStyle(
                                fontSize: 12,
                                color: revaultBlack,
                                letterSpacing: -1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: 50,
                      endIndent: 50,
                      color: Color(0xFFE0E0E0),
                    ),
                    remainingTimeDisplay(good.endDate, good.biddingList.length),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 320.0,
                          enableInfiniteScroll: false,
                          autoPlay: false
                        ),
                        items: _sliderItems(good.imageUrlList),
                      ),
                    ),
                    interactingSection(good),
                    commentSection(good),
                  ],
                );
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class BiddingForm extends StatefulWidget {
  final int price;
  final int unit;
  final int goodID;
  final String session;
  final _AGDWithVideoState parent;

  BiddingForm({Key key, @required this.goodID, @required this.price, @required this.unit,
    @required this.session, @required this.parent}) : super(key: key);

  @override
  BiddingFormState createState() {
    return BiddingFormState();
  }
}

class BiddingFormState extends State<BiddingForm> {
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
    return Padding(
      padding: EdgeInsets.only(top: 32, bottom: 20),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: revaultBlack)
        ),
        color: revaultBlack,
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: revaultBlack,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
        splashColor: Colors.transparent,
        onPressed: () async {
          http.Response response = await addBidding(widget.goodID, selectedPrice);
          if (response.statusCode == 200 && response.body == "1") {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('입찰가 제출에 성공했습니다')));
            this.widget.parent.setState(() {
              this.widget.parent.currentGood = fetchGood(widget.goodID);
              this.widget.parent.currentPrice = selectedPrice;
            });
            Navigator.pop(context, "Changed");
          }
          else if (response.statusCode == 200 && response.body == "-2") {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('경매가 마감되었습니다')));
            this.widget.parent.setState(() {
              this.widget.parent.currentGood = fetchGood(widget.goodID);
            });
            Navigator.pop(context, "Not Changed");
          }
          else {
            ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
          }
        },
        child: Text(
          '입찰하기',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
          )
        ),
      ),
    );
  }
}

class AutoBiddingForm extends StatefulWidget {
  final int price;
  final int unit;
  final int goodID;
  final String session;
  final _AGDWithVideoState parent;
  AutoBiddingForm({Key key, @required this.goodID, @required this.price, @required this.unit,
    @required this.session, @required this.parent}) : super(key: key);

  @override
  AutoBiddingFormState createState() {
    return AutoBiddingFormState();
  }
}

class PriceSelectPair {
  int price;
  bool isSelected;

  PriceSelectPair(
    this.price,
    this.isSelected,
  );
}

class AutoBiddingFormState extends State<AutoBiddingForm> {
  final _formKey = GlobalKey<FormState>();
  int selectedPrice;

  Future<http.Response> addAutoBidding(int id, int price) async {
    debugPrint("자동 입찰: $id번 상품에 $price원");
    var map = new Map<String, dynamic>();
    map['auction_id'] = id.toString();
    map['price'] = price.toString();

    return http.post(
      'https://ibsoft.site/revault/setAutoBid',
      headers: <String, String>{
        'Cookie': widget.session,
      },
      body: map,
    );
  }

  @override
  void initState() {
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
              children: [
                TextButton(
                  style: autoBiddingButtonStyle,
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('자동입찰 설정 취소')));
                    Navigator.pop(context);
                  },
                  child: Text('취소하기'),
                ),
                Expanded(
                  child: Text(
                    '자동입찰 가격 설정',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF828282),
                    ),
                  ),
                ),
                VerticalDivider(width: 30),
                TextButton(
                  style: autoBiddingButtonStyle,
                  onPressed: () async {
                    if (selectedPrice != null) {
                      http.Response response = await addAutoBidding(widget.goodID, selectedPrice);
                      if (response.statusCode == 200 && response.body == "1") {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('자동 입찰 등록에 성공했습니다')));
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
                    else {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('원하는 가격을 선택하세요')));
                    }
                  },
                  child: Center(
                    child: Text('완료'),
                  ),
                ),
              ],
            ),
            Container(
              height: 150,
              child: CupertinoPicker.builder(
                selectionOverlay: Container(
                  //padding: EdgeInsets.only(top: 10, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                      bottom: BorderSide(
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ),
                diameterRatio: 1000.0,
                squeeze: 0.9,
                itemExtent: 28,
                childCount: 50,
                scrollController: FixedExtentScrollController(
                  initialItem: 49,
                ),
                onSelectedItemChanged: (int i) {
                  setState(() {
                    selectedPrice = widget.price + (50 - i) * widget.unit;
                  });
                },
                itemBuilder: (BuildContext _context, int i) {
                  return Text(
                    '${putComma(widget.price + (50 - i) * widget.unit)}원'
                  );
                },
              ),
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
  final _AGDWithVideoState parent;

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
      child: Padding(
        padding: EdgeInsets.fromLTRB(7, 11, 7, 5),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _passController,
                decoration: InputDecoration(
                  hintText: '댓글 입력',
                  border: inputBorder,
                  enabledBorder: inputBorder,
                  focusedBorder: inputBorder,
                  contentPadding: EdgeInsets.fromLTRB(5, 4, 0, 4),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '댓글 내용을 입력하세요';
                  }
                  return null;
                },
              ),
            ),
            FlatButton(
              shape: Border(),
              color: revaultBlack,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: revaultBlack,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              splashColor: Colors.transparent,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  http.Response response = await addComment(widget.goodID, _passController.text);
                  if ((response.statusCode == 200 || response.statusCode == 201) && response.body == "1") {
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
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}