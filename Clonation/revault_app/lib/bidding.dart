import 'package:flutter/material.dart';

class Bidding {
  String username;
  DateTime date;
  int price;

  Bidding({
    @required this.username,
    @required this.date,
    @required this.price,
  });
}