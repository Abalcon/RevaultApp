import 'package:flutter/material.dart';

class AuctionResult {
  int ref;
  String userID;
  int auctionID;
  String brand;
  String name;
  int price;
  DateTime endDate;
  String status;
  String address;
  String phone;
  String receiver;

  AuctionResult({
    @required this.ref,
    @required this.userID,
    @required this.auctionID,
    @required this.brand,
    @required this.name,
    @required this.price,
    @required this.endDate,
    @required this.status,
    @required this.address,
    @required this.phone,
    @required this.receiver
  });

  factory AuctionResult.fromJson(Map<String, dynamic> json) {
    String getStatus(int id) {
      switch (id) {
        case 0:
          return '입금대기';
        case 1:
          return '결제완료';
        case 2:
          return '배송준비';
        case 3:
          return '배송중';
        case 4:
          return '배송완료';
        case -1:
          return '취소';
        default:
          return '해킹당함';
      }
    }

    String brandAndTitle = json['title'];
    var nameDivisor = brandAndTitle.indexOf(']');

    return AuctionResult(
      ref: json['ref'],
      userID: json['user_id'],
      auctionID: json['auction_id'],
      brand: brandAndTitle.substring(1, nameDivisor),
      name: brandAndTitle.substring(nameDivisor + 1),
      price: json['price'],
      endDate: (json['add_time'] == null)
        ? DateTime.fromMillisecondsSinceEpoch(100000000)
        : DateTime.fromMillisecondsSinceEpoch(json['add_time']),
      status: getStatus(json['status']),
      address: (json['address'] == null)
        ? 'Unknown'
        : json['address'],
      phone: (json['tel'] == null)
        ? 'Unknown'
        : json['tel'],
      receiver: (json['recipient'] == null)
        ? 'Unknown'
        : json['recipient'],
    );
  }
}