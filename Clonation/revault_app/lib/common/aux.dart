import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<String> isLogged() async {
  final storage = new FlutterSecureStorage();
  String currSession = await storage.read(key: "session");

  if (currSession == null) {
    print("Not Logged In");
    return null;
  }
  
  http.Response response = await http.get(
    'https://ibsoft.site/revault/whoami',
    headers: <String, String>{
      'Cookie': currSession,
    },
  );

  if (response.statusCode == 200 && response.body != null && response.body != "") {
    print("Logged In: ${response.body}");
    return currSession;
  }
  // 사용자 정보가 만료
  print("Session Expired");
  await storage.delete(key: "session",);
  return null;
}

// Duration remainingTime(DateTime deadline) {
//   DateTime now = DateTime.now();
//   return deadline.difference(now);
// }
String remainingTimeTextFromDate(DateTime deadline) {
  DateTime now = DateTime.now();
  Duration timeLeft = deadline.difference(now);

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