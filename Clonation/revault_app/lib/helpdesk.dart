import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:revault_app/common/common.dart';
import 'customerRequest.dart';

class HelpDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HelpDeskDetails(),
    );
  }
}

class HelpDeskDetails extends StatefulWidget {

  @override
  HelpDeskDetailsState createState() => HelpDeskDetailsState();
}

class HelpDeskDetailsState extends State<HelpDeskDetails> {
  Future<SessionNamePair> currUser;

  @override
  void initState() {
    currUser = isLogged();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currUser,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: 50.0,
                    floating: false,
                    pinned: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        "고객센터",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    shape: Border(
                      bottom: BorderSide(
                        color: Color(0xFFD7D7D7),
                      )
                    ),
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
                                child: Text("1:1 문의하기"),
                              ),
                            ),
                          ),
                          Tab(
                            child: SizedBox.expand(
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.white,
                                child: Text("1:1 문의내역"),
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
                  RequestForm(user: snapshot.data),
                  HelpResponse(user: snapshot.data),
                ],
              )
            ),
          );
        }
        else if (snapshot.hasData && snapshot.data != null) {
          Future.delayed(Duration(seconds: 5),
            () => Navigator.pushReplacementNamed(context, '/login'));

          return Center(
            child: Text(
              "세션이 만료되었습니다\n로그인 화면으로 돌아갑니다",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
        else if (snapshot.hasError) {
          return Center(child: Text("${snapshot.error}"));
        }

        return Center(child: CircularProgressIndicator());
      }
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

class RequestForm extends StatefulWidget {
  final SessionNamePair user;
  RequestForm({Key key, @required this.user}) : super(key: key);

  @override
  RequestFormState createState() {
    return RequestFormState();
  }
}

// 문의 양식
class RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  List<bool> _selections = List.generate(6, (_) => false);
  final List<String> typeList = ['상품', '결제', '배송', '교환', '환불', '기타'];

  Future<http.Response> addQuestion(String content) async {
    final int category = _selections.indexOf(true) + 1;
    var map = new Map<String, dynamic>();
    map['content'] = content;
    map['cat_id'] = category.toString();

    return http.post(
      'https://ibsoft.site/revault/addQuestion',
      headers: <String, String>{
        'Cookie': widget.user.getSession(),
      },
      body: map,
    );
  }

  Widget build(BuildContext context) {
    TextEditingController _helpController = new TextEditingController();
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 3;
    final double itemHeight = size.width * 4 / 27;
    var counter = 0;
    // final TextStyle typeStyle = TextStyle(
    //   fontSize: 15,
    //   fontWeight: FontWeight.bold,
    //   letterSpacing: -1.0,
    // );

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                '문의 유형',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(0),
              child: GridView.count(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                crossAxisCount: 3,
                childAspectRatio: (itemWidth / itemHeight),
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    child: Text(
                      '상품',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    height: itemHeight,
                    child: Text('결제', style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    child: Text('배송', style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    child: Text('교환', style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    child: Text('환불', style: TextStyle(fontSize: 16),),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: itemWidth - 14.7,
                    child: Text('기타', style: TextStyle(fontSize: 16),),
                  ),
                ].map((widget) {
                  final index = ++counter - 1;
                  
                  return ToggleButtons(
                    borderWidth: 0.5,
                    children: [widget],
                    isSelected: [_selections[index]],
                    onPressed: (_) {
                      setState(() {
                        for (int btnIndex = 0; btnIndex < _selections.length; btnIndex++) {
                          if (btnIndex == index)
                            _selections[btnIndex] = true;
                          else
                            _selections[btnIndex] = false;
                        }
                      });
                    },
                    fillColor: revaultGreen,
                    selectedColor: Colors.white,
                    textStyle: TextStyle(
                      fontWeight: _selections[index]
                        ? FontWeight.bold
                        : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ),
            Divider(color: Colors.transparent),
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                '문의 내용',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.0,
                )
              ),
            ),
            TextFormField(
              controller: _helpController,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '문의 내용을 입력하세요',
                fillColor: Colors.grey,
                border: inputBorder,
                focusedBorder: inputBorder,
              ),
              validator: (content) {
                if (content.isEmpty) {
                  return 'Please enter your request content';
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "문의 내용에 대한 답변은 '1:1 문의내역'에서 확인할 수 있습니다.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FlatButton(
                  shape: Border(),
                  color: revaultBlack,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: revaultBlack,
                  padding: EdgeInsets.all(18,),
                  splashColor: Colors.greenAccent,
                  onPressed: () async {
                    if (_formKey.currentState.validate() && _selections.any((sel) => sel)) {
                      http.Response response = await addQuestion(_helpController.text);
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('문의가 접수되었습니다')));
                      }
                      else {
                        ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('문의 접수에 실패했습니다. 다시 시도해주세요')));
                      }
                    }
                    else if (_selections.every((sel) => !sel)) {
                      ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('문의 유형을 선택하세요')));
                    }
                  },
                  child: Text(
                    '신청하기',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ),
          ],
        )
      )
    );
  }
}

List<CustomerRequest> parseRequest(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<CustomerRequest>((json) => CustomerRequest.fromJson(json)).toList();
}

Future<List<CustomerRequest>> fetchRequestList(String session) async {
  final response = await http.get(
    'https://ibsoft.site/revault/getQuestion',
    headers: <String, String>{
      'Cookie': session,
    }
  );

  if (response.statusCode == 200) {
    debugPrint(response.body);
    return compute(parseRequest, response.body);
  }
  else {
    throw Exception('상품 정보를 불러오지 못했습니다');
  }
}

// 문의 내역
class HelpResponse extends StatefulWidget {
  final SessionNamePair user;
  HelpResponse({Key key, @required this.user}) : super(key: key);

  @override
  HelpResponseState createState() => HelpResponseState();
}

class HelpResponseState extends State<HelpResponse> {
  Future<List<CustomerRequest>> items;

  @override
  void initState() {
    print(widget.user);
    items = fetchRequestList(widget.user.getSession());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CustomerRequest>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return SingleChildScrollView(
              //padding: EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(21, 19, 18, 18),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext _context, int i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: revaultBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: snapshot.data[i].status,
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' / ${snapshot.data[i].category}',
                                          )
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text('${DateFormat('yyyy.MM.dd HH:mm').format(snapshot.data[i].requestDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey
                                )
                              ),
                            ],
                          ),
                          Divider(color: Colors.transparent),
                          Text(
                            'Q: ${snapshot.data[i].content}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            )
                          ),
                          (snapshot.data[i].responseList.length > 0) ?
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              style: TextStyle(
                                color: revaultBlack,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'A ',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: snapshot.data[i].responseList[0].content,
                                ),
                                TextSpan(
                                  text: '${snapshot.data[i].responseList[0].userID} | ${snapshot.data[i].responseList[0].responseDate}',
                                ),
                              ]
                            ),
                          ) : Text(''),
                          Divider(),
                        ]
                      );
                    }
                  )
                ],
              )
            );
          }
          return Text(
            "현재 접수된 문의가 없습니다",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Center(child: CircularProgressIndicator());
      }
    );
  }
}