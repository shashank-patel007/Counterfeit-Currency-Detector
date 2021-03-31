// To parse this JSON data, do
//
//     final bankData = bankDataFromJson(jsonString);

import 'dart:convert';

List<BankData> bankDataFromJson(String str) =>
    List<BankData>.from(json.decode(str).map((x) => BankData.fromJson(x)));

String bankDataToJson(List<BankData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankData {
  BankData({
    this.bank,
    this.distance,
    this.address,
  });

  String bank;
  String distance;
  String address;

  factory BankData.fromJson(Map<String, dynamic> json) => BankData(
        bank: json["bank"],
        distance: json["distance"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "bank": bank,
        "distance": distance,
        "address": address,
      };
}
