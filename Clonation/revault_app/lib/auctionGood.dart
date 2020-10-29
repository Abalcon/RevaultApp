import 'package:flutter/material.dart';

class AuctionGood {
  String seller;
  String condition;
  String size;

  String startDate;
  String endDate;

  String brand;
  String goodName;
  String price;

  String sellState;

  AuctionGood({
    @required this.seller,
    @required this.condition,
    @required this.size,
    @required this.startDate,
    @required this.endDate,
    @required this.brand,
    @required this.goodName,
    @required this.price,
    @required this.sellState,
  });
}