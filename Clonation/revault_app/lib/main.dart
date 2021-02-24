import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:revault_app/Policy.dart';
import 'package:revault_app/addProfile.dart';
import 'package:revault_app/auctionList.dart';
import 'package:revault_app/changeAddress.dart';
import 'package:revault_app/changePassword.dart';
import 'package:revault_app/changeProfile.dart';
import 'package:revault_app/common/aux.dart';
import 'package:revault_app/emailVerify.dart';
import 'package:revault_app/helpdesk.dart';
import 'package:revault_app/languageSelect.dart';
import 'package:revault_app/models/cart.dart';
import 'package:revault_app/models/catalog.dart';
import 'package:revault_app/models/user.dart';
import 'package:revault_app/myFailures.dart';
import 'package:revault_app/myParticipations.dart';
import 'package:revault_app/myPrevRecords.dart';
import 'package:revault_app/myProceedings.dart';
import 'package:revault_app/mySettings.dart';
import 'package:revault_app/purchaseWindow.dart';
import 'package:revault_app/resetPassword.dart';
import 'package:revault_app/signup.dart';
import 'package:revault_app/userIdentify.dart';
import 'package:revault_app/userIdentifyResult.dart';
import 'auctionGoodDetail.dart';
import 'login.dart';
import 'myPage.dart';
import 'package:provider/provider.dart';

void main() {
  KakaoContext.clientId = "44aa73adaa28262915db9e87bc41c37e";
  KakaoContext.javascriptClientId = "7a6b2ff76e0ab4769383c627f832f6df";

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('images/revault_square_logo.jpg'), context);
    return MultiProvider(
      providers: [
        // CatalogModel never changes, so a simple Provider is sufficient.
        Provider(create: (context) => CatalogModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use of ChangeNotifierProvider.
        // Moreover, CartModel depends on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProxyProvider<CatalogModel, CartModel>(
          create: (context) => CartModel(),
          update: (context, catalog, cart) {
            cart.catalog = catalog;
            return cart;
          }
        ),
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          title: 'Welcome to REVAULT',
          theme: ThemeData(
            primaryColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: Typography.blackMountainView.copyWith(
              headline1: TextStyle(
                fontFamily: 'Noto Sans KR',
                letterSpacing: -1.0,
              ),
              headline6: TextStyle(
                fontFamily: 'Noto Sans KR',
                letterSpacing: -1.0
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              modalBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
            ),
            tabBarTheme: TabBarTheme(
              labelColor: revaultBlack,
              labelPadding: EdgeInsets.all(0),
              labelStyle: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16,
                color: Color(0xFF333333),
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
              ),
              unselectedLabelColor: Color(0xFFD7D7D7),
              unselectedLabelStyle: Theme.of(context).textTheme.headline6.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.0,
              ),
            ),
          ),
          home: MyHomePage(title: 'REVAULT Start Page'),
          routes: {
            '/login': (context) => Login(),
            '/signup': (context) => SignUp(),
            '/addprofile': (context) => AddProfile(),
            '/verifyemail': (context) => EmailVerify(),
            '/passwordreset': (context) => ResetPassword(),
            '/auctionlist': (context) => AuctionList(),
            '/auctiongooddetail': (context) => AuctionGoodDetail(),
            '/mypage': (context) => MyPage(),
            '/myproceedings': (context) => MyProceedings(),
            '/myparticipations': (context) => MyParticipations(),
            '/myprevrecords': (context) => MyPrevRecords(),
            '/mysettings': (context) => MySettings(),
            '/myfailures': (context) => MyFailures(),
            '/helpdesk': (context) => HelpDesk(),
            '/changeaddress': (context) => ChangeAddress(),
            '/changepassword': (context) => ChangePassword(),
            '/changeprofile': (context) => ChangeProfile(),
            '/languageselect': (context) => LanguageSelect(),
            '/purchasewindow': (context) => PurchaseWindow(),
            '/policy': (context) => Policy(),
            '/useridentify': (context) => UserIdentify(),
            '/useridentifyresult': (context) => UserIdentifyResult(),
          },
          // Error 처리용 페이지
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (BuildContext context) =>
                  Scaffold(body: Center(child: Text('Not Found'))),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO: FCM 알림 수신했을 때 상품 상세 정보로 넘어갈 수 있도록 만들기
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static final storage = new FlutterSecureStorage();
  String currSession = "";
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  _checkLogged() async {
    currSession = await storage.read(key: "session");
    print(currSession);
    // FCM Token 받기 및 알림 수신 준비
    if (Platform.isIOS) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }

    var fcmToken = await _firebaseMessaging.getToken();
    print(fcmToken);
    storage.write(key: "fcm", value: fcmToken);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        String body = message['notification']['body'];
        showSimpleNotification(
          Text(
            '$body',
            style: TextStyle(
              fontSize: 16, 
            )
          ),
          background: Colors.lightBlue,
        );
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //moveToGoodDetail(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //moveToGoodDetail(message);
      }
    );

    if (currSession != null) {
      http.Response response = await http.get(
        'https://ibsoft.site/revault/whoami',
        headers: <String, String>{
          'Cookie': currSession,
        },
      );

      if (response.statusCode == 200 && response.body != null && response.body != "") {
        print(response.body);
        // 로그인 상태이므로 상품 리스트 화면으로
        Future.delayed(Duration(seconds: 1),
         () => Navigator.pushReplacementNamed(context, '/auctionlist'));
      }
      else {
        // 사용자 정보가 만료되었으므로 로그인 화면으로
        print("Session Expired");
        await storage.delete(key: "session",);
        Future.delayed(Duration(seconds: 1),
         () => Navigator.pushReplacementNamed(context, '/login'));
      }
    }
    else
      Future.delayed(Duration(seconds: 1),
         () => Navigator.pushReplacementNamed(context, '/login'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) => _checkLogged());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/revault_rectangle_logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

// class AuctionGoodArguments {
//   final int goodID;

//   AuctionGoodArguments(this.goodID);
// }