import 'package:flutter/material.dart';

class Comment {
  String username;
  DateTime date;
  String content;

  Comment({
    @required this.username,
    @required this.date,
    @required this.content,
  });
}