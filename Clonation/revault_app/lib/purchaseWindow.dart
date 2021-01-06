import 'package:bootpay_api/bootpay_api.dart';
import 'package:bootpay_api/model/extra.dart';
import 'package:bootpay_api/model/item.dart';
import 'package:bootpay_api/model/payload.dart';
import 'package:bootpay_api/model/user.dart';
import 'package:flutter/material.dart';
import 'package:revault_app/common/aux.dart';

class PurchaseWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PurchaseArguments purchaseInfo = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("결제하기"),
      ),
      body: PurchaseWindowDetail(
        session: purchaseInfo.session,
        aucID: purchaseInfo.id,
        name: purchaseInfo.name,
        price: purchaseInfo.price,
      ),
    );
  }
}

class PurchaseWindowDetail extends StatefulWidget {
  final String session;
  final int aucID;
  final String name;
  final double price;

  PurchaseWindowDetail({Key key, @required this.session, @required this.aucID,
    @required this.name, @required this.price}) : super(key: key);

  @override
  PurchaseWindowDetailState createState() {
    return PurchaseWindowDetailState();
  }
}

class PurchaseWindowDetailState extends State<PurchaseWindowDetail> {
  
  void goBootpayRequest(BuildContext context) async {
    Payload payload = Payload();
    payload.androidApplicationId = '5ff40d4b5b294800202a0e49';
    payload.iosApplicationId = '5ff40d4b5b294800202a0e4a';
    
    payload.pg = 'toss';
    //payload.method = 'card';
    payload.methods = ['card', /*'phone',*/ 'vbank', 'bank'];
    payload.name = widget.name;
    payload.price = widget.price;
    payload.orderId = "RV${widget.aucID}${DateTime.now().millisecondsSinceEpoch.toString()}";
//    payload.params = {
//      "callbackParam1" : "value12",
//      "callbackParam2" : "value34",
//      "callbackParam3" : "value56",
//      "callbackParam4" : "value78",
//    };
    // TODO: 로그인된 사용자의 정보를 가져오기
    User user = User();
    user.username = "김덕주";
    user.email = "extinbase@gmail.com";
    user.area = "서울시";
    user.phone = "010-3131-2806";

    Extra extra = Extra();
    extra.appScheme = 'bootpaySample';
    
    Item item1 = Item();
    item1.itemName = widget.name;
    item1.qty = 1;
    item1.unique = "RV${widget.aucID}";
    item1.price = widget.price;
    // maybe-later: 나중에 낙찰된 상품 여럿을 일괄로 결제할 수 있게끔 하면 좋겠다
    List<Item> itemList = [item1];

    BootpayApi.request(
      context,
      payload,
      extra: extra,
      user: user,
      items: itemList,
      onDone: (String json) {
        print('onDone: $json');
      },
      onReady: (String json) {
        //flutter는 가상계좌가 발급되었을때  onReady가 호출되지 않는다. onDone에서 처리해주어야 한다.
        print('onReady: $json');
      },
      onCancel: (String json) {
        print('onCancel: $json');
      },
      onError: (String json) {
        print('onError: $json');
      },
    );
  }


  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          goBootpayRequest(context);
        },
        child: Text("부트페이 결제요청"),
      ),
    );
  }
}