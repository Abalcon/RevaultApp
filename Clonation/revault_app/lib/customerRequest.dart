import 'package:flutter/material.dart';

class CustomerRequest {
  String category;
  String status;
  String content;
  String requestDate;

  String replyer;
  String response;
  String responseDate;

  CustomerRequest({
    @required this.category,
    @required this.status,
    @required this.content,
    @required this.requestDate,
    @required this.responseDate,
    @required this.replyer,
    @required this.response,
  });
}