import 'dart:core';

//https://app.quicktype.io/ Json을 소스코드로 변환 시켜주는 사이트 
class PersonalUnit {
  int id;
  String title;
  String name;
  String date;
  String amt; 
  String phoneNumber;

  PersonalUnit({
    this.id,
    this.title,
    this.name,
    this.date,
    this.amt,
    this.phoneNumber
  });

  factory PersonalUnit.fromJson(Map<String, dynamic> json) => new PersonalUnit(
    id: json["_id"],
    title: json['title'],
    name: json['name'],
    date: json['date'],
    amt: json['amt'],
    phoneNumber: json['phone']
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "name": name,
    "date": date,
    "amt": amt,
    "phone": phoneNumber
  };
}