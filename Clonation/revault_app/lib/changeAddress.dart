import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';

// Change Address - Goods Delivery
class ChangeAddress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("배송지 변경"),
      ),
      body: ChangeAddressForm()
    );
  }
}

class ChangeAddressForm extends StatefulWidget {
  @override
  ChangeAddressFormState createState() {
    return ChangeAddressFormState();
  }
}

class ChangeAddressFormState extends State<ChangeAddressForm> {
  final _formKey1 = GlobalKey<FormState>();
  TextEditingController _zipCtrl = new TextEditingController();
  TextEditingController _addrCtrl = new TextEditingController();
  String addressJSON = '';
  String zipCode = '';
  String address1 = '';

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
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              //key: Key(zipCode),
                              controller: _zipCtrl,
                              decoration: InputDecoration(
                                hintText: '우편번호',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return '우편번호를 입력하세요';
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
                              style: TextStyle(fontSize: 14.0)
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        //key: Key(address1),
                        controller: _addrCtrl,
                        decoration: InputDecoration(
                          hintText: '주소',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '변경할 주소를 입력하세요';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: '상세주소',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return '변경할 상세주소를 입력하세요';
                          }
                          return null;
                        },
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
                            onPressed: () {
                              if (_formKey1.currentState.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text('Ready to Change Address!')));
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