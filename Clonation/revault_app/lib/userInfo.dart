import 'package:flutter/material.dart';
import 'auctionGood.dart';

class UserInfo {
  int ref;
  String userID;
  String email;
  String name;
  String phone;
  String address;
  String profile;
  //DateTime registerDate;
  List<AuctionGood> auctionList;
  List<Comment> commentList;
  String fcmToken;
  bool alarmPrice;
  bool alarmStatus;
  bool alarmComment;
  int snsCode;

  UserInfo({
    @required this.ref,
    @required this.userID,
    @required this.email,
    @required this.name,
    @required this.phone,
    @required this.address,
    @required this.profile,
    @required this.auctionList,
    @required this.commentList,
    @required this.fcmToken,
    @required this.alarmPrice,
    @required this.alarmStatus,
    @required this.alarmComment,
    @required this.snsCode,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    var goodsPart = json['auction_list'] as List;
    List<AuctionGood> goodList = (goodsPart == null) ?
      [] : goodsPart.map<AuctionGood>((json) => AuctionGood.fromJson(json)).toList();
    var commentsPart = json['comment_list'] as List;
    List<Comment> comList = (commentsPart == null) ?
      [] : commentsPart.map<Comment>((json) => Comment.fromJson(json)).toList();

    return UserInfo(
      ref: json['ref'],
      userID: json['user_id'],
      email: json['email'],
      name: json['name'],
      phone: json['tel'],
      address: json['address'],
      profile: json['profile'],
      auctionList: goodList,
      commentList: comList,
      fcmToken: json['user_token'],
      alarmPrice: json['alarm_price'],
      alarmStatus: json['alarm_status'],
      alarmComment: json['alarm_comment'],
      snsCode: json['sns_code'],
    );
  }
}