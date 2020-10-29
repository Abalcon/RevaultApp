import 'package:flutter/material.dart';
import 'customerRequest.dart';

class HelpDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 50.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("고객센터"),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    tabs: [
                      Tab(child: Text("1:1 문의하기", style: Theme.of(context).textTheme.headline6)),
                      Tab(child: Text("1:1 문의내역", style: Theme.of(context).textTheme.headline6)),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            children: <Widget> [
              Center(child: RequestForm()),
              Center(child: HelpResponse()),
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

class RequestForm extends StatefulWidget {
  @override
  RequestFormState createState() {
    return RequestFormState();
  }
}

// 문의 양식
class RequestFormState extends State<RequestForm> {
  final _formKey = GlobalKey<FormState>();
  List<bool> _selections = List.generate(6, (_) => false);

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                '문의 유형',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            ToggleButtons(
              children: [
                Text('상품'),
                Text('결제'),
                Text('배송'),
                Text('교환'),
                Text('환불'),
                Text('기타'),
              ],
              isSelected: _selections,
              onPressed: (index) {
                setState(() {
                  for (int btnIndex = 0; btnIndex < _selections.length; btnIndex++) {
                    if (btnIndex == index)
                      _selections[btnIndex] = true;
                    else
                      _selections[btnIndex] = false;
                  }
                });
              },
              fillColor: Colors.green,
              selectedColor: Colors.black,
            ),
            Divider(),
            Text(
              '문의 내용',
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '문의 내용을 입력하세요',
                fillColor: Colors.grey,
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
                  fontSize: 12,
                )
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 10.0
              ),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.greenAccent,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Request')));
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0)
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

// 문의 내역
class HelpResponse extends StatelessWidget {
  final List<CustomerRequest> items = [
    CustomerRequest(
      category: '배송관련',
      status: '답변완료',
      requestDate: '2020-08-15',
      responseDate: '2020-08-15',
      replyer: 'REVAULT 고객센터',
      content: '이번에 낙찰된 상품이 아직 도착하지 않았는데 언제쯤 받을 수 있을까요?',
      response: '네 고객님 이번에 낙찰되신 상품이 나이키 후드티가 맞는지요. 해당 상품은 이틀 뒤에 도착 예정입니다. 감사합니다.',
    ),
    CustomerRequest(
      category: '환불관련',
      status: '미답변',
      requestDate: '2020-07-21',
      responseDate: '',
      replyer: '',
      content: '이번에 경매한 제품에 보풀이 생각보다 많네요, 입기 힘들거 같은데 환불 요청드립니다.',
      response: '',
    ),
  ];

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //padding: EdgeInsets.only(top: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (BuildContext _context, int i) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${items[i].status}',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )
                            ),
                            Text(' / ${items[i].category}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              )
                            ),
                          ],
                        ),
                      ),
                      Text('${items[i].requestDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                        )
                      ),
                    ],
                  ),
                  Text(
                    'Q: ${items[i].content}',
                    style: TextStyle(
                      fontSize: 14,
                    )
                  ),
                  Text(
                    'A: ${items[i].response}',
                    style: TextStyle(
                      fontSize: 14,
                    )
                  ),
                  Text(
                    '${items[i].replyer} | ${items[i].responseDate}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    )
                  ),
                  Divider()
                ]
              );
            }
          )
        ],
      )
    );
  }
}