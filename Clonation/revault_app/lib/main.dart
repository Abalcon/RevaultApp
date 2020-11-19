import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/auctionList.dart';
import 'package:revault_app/changeAddress.dart';
import 'package:revault_app/changePassword.dart';
import 'package:revault_app/emailVerify.dart';
import 'package:revault_app/helpdesk.dart';
import 'package:revault_app/languageSelect.dart';
import 'package:revault_app/models/cart.dart';
import 'package:revault_app/models/catalog.dart';
import 'package:revault_app/models/user.dart';
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
        ChangeNotifierProvider(create: (context) => UserModel()),
      ],
      child: MaterialApp(
        title: 'Welcome to REVAULT',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Typography.blackMountainView,
          //tabBarTheme: TabBarTheme(labelColor: Colors.white),
        ),
        home: MyHomePage(title: 'REVAULT Start Page'),
        routes: {
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
        },
        // onGenerateRoute: (settings) {
        //   if (settings.name == '/auctiongooddetail') {
        //     final AuctionGoodArguments args = settings.arguments;

        //     return MaterialPageRoute(
        //       builder: (context) => AuctionGoodDetail(args.goodID)
        //     );
        //   }

        //   assert(false, 'Need to implement ${settings.name}');
        //   return null;
        // },
        // TODO: Error 처리용 페이지
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (BuildContext context) =>
                Scaffold(body: Center(child: Text('Not Found'))),
          );
        },
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
  static final storage = new FlutterSecureStorage();
  String currSession = "";

  _checkLogged() async {
    currSession = await storage.read(key: "session");
    print(currSession);

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
        Navigator.pushReplacementNamed(context, '/auctionlist');
      }
      else {
        // 사용자 정보가 만료되었으므로 로그인 화면으로
        print("Session Expired");
        await storage.delete(key: "session",);
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
    else
      Navigator.pushReplacementNamed(context, '/login');
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

// class AuctionGoodArguments {
//   final int goodID;

//   AuctionGoodArguments(this.goodID);
// }