import 'package:flutter/material.dart';

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
  int unitPrice;

  int aucState;
  String winner;

  List<Comment> commentList;
  List<Bidding> biddingList;
  List<String> imageUrlList;
  int autoPrice;
  String autoUser;

  int waitingCount;
  List<String> waitingList;

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
    this.unitPrice,
    @required this.aucState,
    this.winner,
    this.commentList,
    this.biddingList,
    this.imageUrlList,
    this.autoPrice,
    this.autoUser,
    this.waitingList,
    this.waitingCount,
  });

  factory AuctionGood.fromJson(Map<String, dynamic> json) {
    var biddingsPart = json['bid_log_list'] as List;
    List<Bidding> bidList = (biddingsPart == null) ?
      [] : biddingsPart.map<Bidding>((json) => Bidding.fromJson(json)).toList();
    var commentsPart = json['comment_list'] as List;
    List<Comment> comList = (commentsPart == null) ?
      [] : commentsPart.map<Comment>((json) => Comment.fromJson(json)).toList();
    var imageUrlPart = json['ai_list'] as List;
    List<String> imgUrlList = (imageUrlPart == null) ?
      [] : imageUrlPart.map<String>((json) => json['path']).toList();
    var waitUrlPart = json['wait_user_profile'] as List;
    List<String> waitUrlList = (waitUrlPart == null) ?
      [] : waitUrlPart.map<String>((val) => val.toString()).toList();

    String brandAndTitle = json['title'];
    var nameDivisor = brandAndTitle.indexOf(']');

    return AuctionGood(
      auctionID: json['auction_id'],
      seller: json['seller_id'] != null ? json['seller_id'].toString() : 'Unknown',
      condition: json['grade'],
      size: json['size'],
      addedDate: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      startDate: DateTime.fromMillisecondsSinceEpoch(json['start_time']),
      endDate: DateTime.fromMillisecondsSinceEpoch(json['end_time']),
      brand: brandAndTitle.substring(1, nameDivisor),
      goodName: brandAndTitle.substring(nameDivisor + 1),
      price: json['price'],
      initPrice: json['start_price'],
      unitPrice: json['unit_price'],
      aucState: json['status'],
      winner: json['winner_id'],
      commentList: comList,
      biddingList: bidList,
      imageUrlList: imgUrlList,
      autoPrice: json['auto_price'],
      autoUser: json['auto_user'],
      waitingCount: json['wait_user_cnt'] == null ? 0 : json['wait_user_cnt'],
      waitingList: waitUrlList,
      // 2020-11-17 추가분
      // auction_id_arr, auction_id_list, isBid, isWin, isLose
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
      date: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      price: json['price']
    );
  }
}

class Comment {
  String username;
  DateTime date;
  String content;

  Comment({
    @required this.username,
    @required this.date,
    @required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['user_id'],
      date: DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      content: json['content']
    );
  }
}