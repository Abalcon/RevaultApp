import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:revault_app/userInfo.dart';

class SessionNamePair {
  final String session;
  final String name;
  SessionNamePair(
    this.session,
    this.name,
  );

  @override
  String toString() => 'SessionNamePair[$session, $name]';
  String getSession() => this.session;
  String getName() => this.name;
}

Future<SessionNamePair> isLogged() async {
  final storage = new FlutterSecureStorage();
  String currSession = await storage.read(key: "session");

  if (currSession == null) {
    print("Not Logged In");
    return SessionNamePair(null, null);
  }
  
  http.Response response = await http.get(
    'https://ibsoft.site/revault/whoami',
    headers: <String, String>{
      'Cookie': currSession,
    },
  );

  if (response.statusCode == 200 && response.body != null && response.body != "") {
    print("Logged In: ${response.body}");
    return SessionNamePair(currSession, response.body);
  }
  // 사용자 정보가 만료
  print("Session Expired");
  await storage.delete(key: "session",);
  return SessionNamePair(null, null);
}

Future<http.Response> trySignUp(String id, String pw,
  String email, String phone, {int snsCode = 0, String address = ''}) async {
  // snsCode: 0은 직접 가입, 1은 페이스북, 2는 카카오
  var map = new Map<String, dynamic>();
  map['user_id'] = id;
  map['passwd'] = pw;
  map['email'] = email;
  map['tel'] = phone;
  map['sns_code'] = snsCode.toString();
  map['address'] = address;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/addUser',
    body: map,
  );

  print(response.headers); // set-cookie: JSESSIONID=blahblah
  print(response.body); // string: "1" or "-1"
  return response;
}

UserInfo parseInfo(String responseBody) {
  return UserInfo.fromJson(jsonDecode(responseBody));
}

Future<UserInfo> getInfo(String session) async {
  http.Response response = await http.get(
    'https://ibsoft.site/revault/mypage',
    headers: <String, String>{
      'Cookie': session,
    },
  );

  if (response.statusCode == 200 && response.body != null && response.body != "") {
    print("Current User Info: ${response.body}");
    return compute(parseInfo, response.body);
  }

  return UserInfo(
    ref: null,
    userID: null,
    email: null,
    name: null,
    phone: null,
    address: null,
    profile: null,
    auctionList: null,
    commentList: null,
    fcmToken: null,
    alarmPrice: null,
    alarmStatus: null,
    alarmComment: null,
    snsCode: null,
  );
}

Future<UserInfo> findUserInfo(String phone) async {
  var map = new Map<String, dynamic>();
  map['tel'] = phone;
  http.Response response = await http.post(
    'https://ibsoft.site/revault/findUser',
    body: map,
  );

  if (response.statusCode == 200 && response.body != null && response.body != "") {
    print("User Found: ${response.body}");
    return compute(parseInfo, response.body);
  }
  print("User Not Found");
  return UserInfo(
    ref: null,
    userID: null,
    email: null,
    name: null,
    phone: null,
    address: null,
    profile: null,
    auctionList: null,
    commentList: null,
    fcmToken: null,
    alarmPrice: null,
    alarmStatus: null,
    alarmComment: null,
    snsCode: null,
  );
}

Duration remainingTime(DateTime deadline) {
  DateTime now = DateTime.now();
  return deadline.difference(now);
}

// 2020-11-20 시간 표기 통합 함수
String timeTextBuilder(DateTime date, bool isReverse, String dayText, String hourText,
  String minuteText, String secondText, String suffix, String otherwise) {
  
  DateTime now = DateTime.now();
  Duration diff = isReverse ? -date.difference(now) : date.difference(now);
  
  if (diff.inDays > 0)
    return diff.inDays.toString() + dayText + ' ' + suffix;
  else if (diff.inHours > 0)
    return diff.inHours.toString() + hourText + ' ' + suffix;
  else if (diff.inMinutes > 0)
    return diff.inMinutes.toString() + minuteText + ' ' + suffix;
  else if (diff.inSeconds > 0)
    return diff.inSeconds.toString() + secondText + ' ' + suffix;
  
  return otherwise;
}

String remainingTimeTextFromDuration(Duration timeLeft) {
  if (timeLeft.inDays > 0) 
    return timeLeft.inDays.toString() + 'd ' + timeLeft.inHours.toString() + 'h';
  else if (timeLeft.inHours > 0) 
    return timeLeft.inHours.toString() + 'h ' + timeLeft.inMinutes.toString() + 'm';
  else if (timeLeft.inMinutes > 0) 
    return timeLeft.inMinutes.toString() + 'm';
  else if (timeLeft.inSeconds > 0)
    return timeLeft.inSeconds.toString() + 's';

  return 'Ended';
}

// 댓글 작성일 ago 형으로 표시
String commentTimeTextFromDate(DateTime comDate) {
  DateTime now = DateTime.now();
  Duration timeElapsed = now.difference(comDate);

  if (timeElapsed.inDays > 0)
    return timeElapsed.inDays.toString() + '일 전';
  else if (timeElapsed.inHours > 0) 
    return timeElapsed.inHours.toString() + '시간 전';
  else if (timeElapsed.inMinutes > 0) 
    return timeElapsed.inMinutes.toString() + '분 전';
  else if (timeElapsed.inSeconds > 0)
    return timeElapsed.inSeconds.toString() + '초 전';

  return '방금';
}

// 2020-11-20 나중에 하나의 함수로 통합시킬 수 있을 것 같다
String remainingTimeText(Duration timeLeft) {
  if (timeLeft.inDays > 0) 
    return timeLeft.inDays.toString() + '일';
  else if (timeLeft.inHours > 0) 
    return timeLeft.inHours.toString() + '시간 ' + timeLeft.inMinutes.toString() + '분';
  else if (timeLeft.inMinutes > 0) 
    return timeLeft.inMinutes.toString() + '분';
  else if (timeLeft.inSeconds > 0)
    return timeLeft.inSeconds.toString() + '초';

  return '마감되었습니다';
}

Widget remainingTimeDisplay(DateTime deadline, int entries) {
  DateTime now = DateTime.now();
  Duration timeLeft = deadline.difference(now);

  if (timeLeft.isNegative) {
    return Text(
      '경매가 종료된 상품입니다.',
      style: TextStyle(
        fontSize: 14,
        color: Colors.red
      )
    );
  }

  String timeString = remainingTimeText(timeLeft);

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.schedule, size: 14, color: Colors.red),
      Container(
        padding: EdgeInsets.only(right: 8),
        child: Text(
          '남은시간 : $timeString',
          style: TextStyle(
            fontSize: 14,
            color: Colors.red
          )
        ),
      ),
      Icon(Icons.person, size: 14),
      Text(
        '$entries' + '명 참여 중', // TODO: 같은 사람이 여러번 올린 경우를 빼야한다
        style: TextStyle(
          fontSize: 14
        ),
      )
    ],
  );
}

class ReceiverArguments {
  final String session;
  final int ref;
  final String name;
  final String phone;
  final String address;

  ReceiverArguments(
    this.session,
    this.ref,
    this.name,
    this.phone,
    this.address,
  );
}

Future<http.Response> tryModifyUserAddress(String session, String address, String phone, String name) async {
  var map = new Map<String, dynamic>();
  map['address'] = address;
  map['tel'] = phone;
  map['name'] = name;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/modUserInfo',
    headers: <String, String>{
      'Cookie': session,
    },
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1"
  return response;
}

class ProfileArguments {
  final String session;
  final String imagePath;

  ProfileArguments(
    this.session,
    this.imagePath,
  );
}

Future<http.StreamedResponse> tryModifyUserProfile(String session, File image) async {
  var client = new http.Client();
  http.StreamedResponse response;
  try {
    Map<String, String> headers = { "Cookie": session};
    //String encodedImage = base64Encode(image.readAsBytesSync());

    http.MultipartRequest request = new http.MultipartRequest(
      'POST', Uri.parse('https://ibsoft.site/revault/modUserProfile'));
    //Uri.https('ibsoft.site', '/revault/modUserProfile', {'mf': encodedImage}));
    request.fields['mf'] = 'newProfileImage';
    request.headers.addAll(headers);
    request.files.add(await http.MultipartFile.fromPath('mf', image.path));
    response = await request.send();
  }
  catch (e) {
    throw Exception(e);
  }
  finally {
    client.close();
  }

  print(response.statusCode); // 200 or 201
  return response;
}

Future<http.Response> tryModifyUserPassword(String session, String oldPass, String newPass) async {
  var map = new Map<String, dynamic>();
  map['passwd'] = newPass;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/modUserInfo',
    headers: <String, String>{
      'Cookie': session,
    },
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1"
  return response;
}

Future<http.Response> tryModifyUserAlarms(
  String session, bool price, bool comment, bool status) async {
  String boolToString(bool val) {
    return val ? "1" : "0";
  }

  var map = new Map<String, dynamic>();
  map['alarm_price'] = boolToString(price);
  map['alarm_comment'] = boolToString(comment);
  map['alarm_status'] = boolToString(status);

  http.Response response = await http.post(
    'https://ibsoft.site/revault/modUserInfo',
    headers: <String, String>{
      'Cookie': session,
    },
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1"
  return response;
}

Future<http.Response> tryModifyUserPhone(String session, String phone) async {
  var map = new Map<String, dynamic>();
  map['tel'] = phone;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/modUserInfo',
    headers: <String, String>{
      'Cookie': session,
    },
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1"
  return response;
}

OutlineInputBorder inputBorder = new OutlineInputBorder(
  borderRadius: const BorderRadius.all(
    const Radius.circular(0.0),
  ),
  borderSide: new BorderSide(
    color: Colors.black,
    width: 1.0,
  ),
);

class PurchaseArguments {
  final String session;
  final int id; // AuctionResult의 ref
  final String name;
  final double price;

  PurchaseArguments(
    this.session,
    this.id,
    this.name,
    this.price,
  );
}

Future<http.Response> tryCheckBilling(String session, int resID, String receiptID) async {
  var map = new Map<String, dynamic>();
  map['ar_ref'] = resID.toString();
  map['receipt_id'] = receiptID;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/verify',
    headers: <String, String>{
      'Cookie': session,
    },
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1" or "-2"
  return response;
}

class PhoneVerifyArguments {
  // 결제할 때는 최초 한번만 - session, username 값이 존재
  // 아이디를 찾을 때는 항상 - session, username 모두 null
  // 비번을 찾을 때에도 항상 - username만 값이 존재
  final String session;
  final String username;

  PhoneVerifyArguments(
    this.session,
    this.username,
  );
}

Future<http.Response> tryResetUserPassword(String userID, String newPass) async {
  var map = new Map<String, dynamic>();
  map['user_id'] = userID;
  map['passwd'] = newPass;

  http.Response response = await http.post(
    'https://ibsoft.site/revault/modUserPasswd',
    body: map,
  );

  print(response.statusCode); // 200 or 201
  print(response.body); // string: "1" or "-1"
  return response;
}