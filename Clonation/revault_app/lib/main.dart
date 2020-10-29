import 'package:flutter/material.dart';
import 'package:revault_app/auctionList.dart';
import 'package:revault_app/changeAddress.dart';
import 'package:revault_app/changePassword.dart';
import 'package:revault_app/emailVerify.dart';
import 'package:revault_app/helpdesk.dart';
import 'package:revault_app/languageSelect.dart';
import 'package:revault_app/models/cart.dart';
import 'package:revault_app/models/catalog.dart';
import 'package:revault_app/myBillings.dart';
import 'package:revault_app/myDonations.dart';
import 'package:revault_app/myParticipations.dart';
import 'package:revault_app/myPrevRecords.dart';
import 'package:revault_app/myProceedings.dart';
import 'package:revault_app/mySettings.dart';
import 'package:revault_app/myStackInfo.dart';
import 'package:revault_app/resetPassword.dart';
import 'package:revault_app/signup.dart';
import 'auctionGoodDetail.dart';
import 'login.dart';
import 'myPage.dart';
import 'myAuctionInfo.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      ],
      child: MaterialApp(
        title: 'Welcome to REVAULT',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Typography.blackMountainView,
        ),
        home: MyHomePage(title: 'REVAULT Start Page'),
        routes: {
          // TODO: Common - Glossary 정보 등을 저장할 파일이 필요
          '/login': (context) => Login(),
          '/signup': (context) => SignUp(),
          '/verifyemail': (context) => EmailVerify(),
          '/passwordreset': (context) => ResetPassword(),
          '/auctionlist': (context) => AuctionList(),
          '/auctiongooddetail': (context) => AuctionGoodDetail(),
          '/mypage': (context) => MyPage(),
          '/myauctioninfo': (context) => MyAuctionInfo(),
          '/myproceedings': (context) => MyProceedings(),
          '/myparticipations': (context) => MyParticipations(),
          '/myprevrecords': (context) => MyPrevRecords(),
          '/mysettings': (context) => MySettings(),
          '/mystackinfo': (context) => MyStackInfo(),
          '/mybillings': (context) => MyBillings(),
          '/mydonations': (context) => MyDonations(),
          '/helpdesk': (context) => HelpDesk(),
          '/changeaddress': (context) => ChangeAddress(),
          '/changepassword': (context) => ChangePassword(),
          '/languageselect': (context) => LanguageSelect()
        }
      )
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
  @override
  void initState() {
    // TODO: 로그인 여부 확인하여 로그인 화면 또는 경매 리스트 화면으로 이동
    super.initState();
    WidgetsBinding.instance
      .addPostFrameCallback((_) =>
        Future.delayed(Duration(seconds: 5), () => Navigator.pushReplacementNamed(context, '/login'))
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/revault_square_logo.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              fit: BoxFit.cover,
            ),
            LinearProgressIndicator(
              minHeight: 10,
            ),
            Text(
              'Now Loading...',
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
