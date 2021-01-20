import 'package:flutter/material.dart';

class CustomerRequest {
  int requestID;
  String category;
  String status;
  String content;
  DateTime requestDate;
  String userID;

  List<Response> responseList;

  CustomerRequest({
    @required this.requestID,
    @required this.category,
    @required this.status,
    @required this.content,
    @required this.requestDate,
    @required this.userID,
    @required this.responseList,
  });

  factory CustomerRequest.fromJson(Map<String, dynamic> json) {
    var responsePart = json['answer_list'] as List;
    List<Response> respList = (responsePart == null) ?
      [] : responsePart.map<Response>((json) => Response.fromJson(json)).toList();
    String getCategory(int id) {
      switch (id) {
        case 1:
          return '상품관련';
        case 2:
          return '결제관련';
        case 3:
          return '배송관련';
        case 4:
          return '교환관련';
        case 5:
          return '환불관련';
        case 6:
          return '기타';
        default:
          return '분류불명';
      }
    }

    String getStatus(int status) {
      if (status == null)
        return '미답변';

      if (status == 1)
        return '답변완료';

      return '알수없음';
    }

    return CustomerRequest(
      requestID: json['question_id'],
      category: getCategory(json['cat_id']),
      content: json['content'],
      requestDate: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      userID: json['user_id'],
      status: getStatus(json['status']),
      responseList: respList,
    );
  }
}

class Response {
  int number;
  int requestID;
  String content;
  String userID;
  DateTime responseDate;

  Response({
    @required this.number,
    @required this.requestID,
    @required this.content,
    @required this.userID,
    @required this.responseDate,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      number: json['ref'],
      requestID: json['question_id'],
      content: json['content'],
      userID: json['user_id'],
      responseDate: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
    );
  }
}