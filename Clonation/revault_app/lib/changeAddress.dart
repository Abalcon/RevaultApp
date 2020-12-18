import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kopo/kopo.dart';
import 'package:revault_app/common/aux.dart';

// Change Address - Goods Delivery
class ChangeAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ReceiverArguments receiver = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("배송지 변경"),
      ),
      body: ChangeAddressForm(
        session: receiver.session,
        ref: receiver.ref,
        name: receiver.name,
        phone: receiver.phone,
        address: receiver.address)
    );
  }
}

class ChangeAddressForm extends StatefulWidget {
  final String session;
  final int ref;
  final String name;
  final String phone;
  final String address;

  ChangeAddressForm({Key key, @required this.session, @required this.name,
    @required this.ref, @required this.phone, @required this.address}) : super(key: key);

  @override
  ChangeAddressFormState createState() {
    return ChangeAddressFormState();
  }
}

class ChangeAddressFormState extends State<ChangeAddressForm> {
  final _formKey1 = GlobalKey<FormState>();
  // bool isEditing = false;
  TextEditingController _nameCtrl = new TextEditingController();
  TextEditingController _phoneCtrl = new TextEditingController();
  TextEditingController _zipCtrl = new TextEditingController();
  TextEditingController _addrCtrl = new TextEditingController();
  TextEditingController _detCtrl = new TextEditingController();
  String addressJSON = '';
  String zipCode = '';
  String address1 = '';

  Future<http.Response> tryChangeAddress(int id, String addr, String phone, String name) async {
    var map = new Map<String, dynamic>();
    map['ref'] = id.toString();
    map['address'] = addr;
    map['tel'] = phone;
    map['recipient'] = name;
    
    http.Response response = await http.post(
      'https://ibsoft.site/revault/modAuctionResult',
      headers: <String, String>{
        'Cookie': widget.session,
      },
      body: map,
    );

    print(response.statusCode); // 200 or 201
    print(response.body); // string: "1" or "-1"
    return response;
  }

  @override
  void initState() {
    _nameCtrl.text = widget.name;
    _phoneCtrl.text = widget.phone;
    // Example: "[06530] 서울시 서초구 신반포로45길 54 경미빌딩 지하1층"
    _zipCtrl.text = widget.address.substring(1, 6);
    _addrCtrl.text = widget.address.substring(8);
    print("주소 로드 성공");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Start of Address Change
              Form(
                key: _formKey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          '주소 정보',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          hintText: '받는 사람',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '상품을 받을 사람을 입력하세요';
                          }
                          return null;
                        },
                      ),
                      Divider(color: Colors.white),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: InputDecoration(
                          hintText: '연락처',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '연락처를 입력하세요';
                          }
                          return null;
                        },
                      ),
                      Divider(color: Colors.white),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _zipCtrl,
                              decoration: InputDecoration(
                                hintText: '우편번호',
                                border: inputBorder,
                                focusedBorder: inputBorder,
                                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '우편번호를 입력하세요';
                                }
                                return null;
                              },
                            ),
                          ),
                          VerticalDivider(),
                          RaisedButton(
                            color: Colors.grey[300],
                            textColor: Colors.grey[700],
                            disabledColor: Colors.black,
                            disabledTextColor: Colors.grey,
                            padding: EdgeInsets.all(12.0),
                            splashColor: Colors.transparent,
                            onPressed: () async {
                              KopoModel model = await Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => Kopo(),
                                ),
                              );
                              print(model.toJson());
                              setState(() {
                                addressJSON =
                                  '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''} ${model.zonecode} ';
                                zipCode = '${model.zonecode}';
                                _zipCtrl.text = '${model.zonecode}';
                                address1 = '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                                _addrCtrl.text = '${model.address} ${model.buildingName}${model.apartment == 'Y' ? '아파트' : ''}';
                              });
                            },
                            child: Text(
                              '우편번호 검색',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.white),
                      TextFormField(
                        controller: _addrCtrl,
                        decoration: InputDecoration(
                          hintText: '주소',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '변경할 주소를 입력하세요';
                          }
                          return null;
                        },
                      ),
                      Divider(color: Colors.white),
                      TextFormField(
                        controller: _detCtrl,
                        decoration: InputDecoration(
                          hintText: '상세주소',
                          border: inputBorder,
                          focusedBorder: inputBorder,
                          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            padding: EdgeInsets.all(8.0),
                            splashColor: Colors.greenAccent,
                            onPressed: () async {
                              if (_formKey1.currentState.validate()) {
                                // Example: "[06530] 서울시 서초구 신반포로45길 54 경미빌딩 지하1층"
                                String detailedAddr = (_detCtrl.text == '') ? '' : ' ${_detCtrl.text}';
                                String newAddress = '[${_zipCtrl.text}] ${_addrCtrl.text}$detailedAddr';
                                http.Response changeResponse;
                                if (widget.ref > 0) {
                                  // 상품에 대한 배송지 변경
                                  changeResponse = await tryChangeAddress(
                                    widget.ref, newAddress, _phoneCtrl.text, _nameCtrl.text);
                                }
                                else {
                                  changeResponse = await tryModifyUserAddress(
                                    widget.session, newAddress, _phoneCtrl.text, _nameCtrl.text);
                                }

                                if (changeResponse.statusCode == 200 || changeResponse.statusCode == 201) {
                                  if (changeResponse.body == "-1") {
                                    ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text('배송지 변경에 실패했습니다. 다시 시도해주세요')));
                                    return;
                                  }

                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('배송지 변경에 성공했습니다')));
                                  Navigator.pop(context);
                                }
                                else {
                                  ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요')));
                                }
                              }
                            },
                            child: Text(
                              "저장하기",
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                        )
                      ),
                    ]
                )
              ),
            ],
          ),
        )
      )
    );
  }

}