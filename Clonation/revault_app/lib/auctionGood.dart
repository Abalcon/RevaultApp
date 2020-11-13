import 'package:flutter/material.dart';
import 'comment.dart';

class AuctionGood {
  int auctionID;
  String seller;
  String condition;
  String size;

  DateTime addedDate;
  DateTime startDate;
  DateTime endDate;

  String brand;
  String goodName;
  int price;
  int initPrice;

  String sellState;
  String winner;

  List<Comment> commentList;
  List<Bidding> biddingList;
  // List<AuctionImage> imageList;

  AuctionGood({
    @required this.auctionID,
    @required this.seller,
    @required this.condition,
    @required this.size,
    this.addedDate,
    @required this.startDate,
    @required this.endDate,
    @required this.brand,
    @required this.goodName,
    @required this.price,
    this.initPrice,
    @required this.sellState,
    this.winner,
    this.commentList,
    this.biddingList
  });

  factory AuctionGood.fromJson(Map<String, dynamic> json) {
    var biddingsPart = json['bid_log_list'] as List;
    List<Bidding> bidList = biddingsPart.map<Bidding>((json) => Bidding.fromJson(json)).toList();

    return AuctionGood(
      auctionID: json['auction_id'],
      seller: 'KIDMILLE', // TODO: temporal name
      condition: json['grade'],
      size: json['size'],
      addedDate: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      startDate: DateTime.fromMillisecondsSinceEpoch(json['start_time']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['end_time']),
      brand: json['title'],
      goodName: json['title'],
      price: json['price'],
      initPrice: json['start_price'],
      sellState: json['status'],
      winner: json['winner_id'],
      commentList: [], // TODO: parse comment_list to List<Comment>
      biddingList: bidList,
    );
  }
}

class Bidding {
  String username;
  DateTime date;
  int price;

  Bidding({
    @required this.username,
    @required this.date,
    @required this.price,
  });

  factory Bidding.fromJson(Map<String, dynamic> json) {
    return Bidding(
      username: json['user_id'],
      date: json['add_time'],
      price: json['price']
    );
  }
}