import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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

// Duration remainingTime(DateTime deadline) {
//   DateTime now = DateTime.now();
//   return deadline.difference(now);
// }

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

String remainingTimeTextFromDate(DateTime deadline) {
  DateTime now = DateTime.now();
  Duration timeLeft = deadline.difference(now);

  if (timeLeft.inDays > 0) 
    return timeLeft.inDays.toString() + '일 남음';
  else if (timeLeft.inHours > 0) 
    return timeLeft.inHours.toString() + '시간 ' + timeLeft.inMinutes.toString() + '분 남음';
  else if (timeLeft.inMinutes > 0) 
    return timeLeft.inMinutes.toString() + '분 남음';
  else if (timeLeft.inSeconds > 0)
    return timeLeft.inSeconds.toString() + '초 남음';

  return '입찰 마감';
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