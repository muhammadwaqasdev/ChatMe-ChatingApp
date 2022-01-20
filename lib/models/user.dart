import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  String? uid;
  String? fullname;
  String? nickname;
  String? email;
  String? age;
  String? cuntery;
  String? gender;
  String? status;
  int? reportedcount;
  String? intro;
  String? prifilepic;
  Map<String, dynamic>? favoriteusers;
  Map<String, dynamic>? chatedides;
  UserModel(
      {this.uid,
      this.fullname,
      this.nickname,
      this.email,
      this.age,
      this.cuntery,
      this.gender,
      this.status,
      this.reportedcount,
      this.intro,
      this.prifilepic,
      this.favoriteusers,
      this.chatedides});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullname': fullname,
      'nickname': nickname,
      'email': email,
      'age': age,
      'cuntery': cuntery,
      'gender': gender,
      'status': status,
      'reportedcount': reportedcount,
      'intro': intro,
      'prifilepic': prifilepic,
      'favoriteusers': favoriteusers,
      'chatedides': chatedides,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      fullname: map['fullname'],
      nickname: map['nickname'],
      email: map['email'],
      age: map['age'],
      cuntery: map['cuntery'],
      gender: map['gender'],
      status: map['status'],
      reportedcount: map['reportedcount']?.toInt(),
      intro: map['intro'],
      prifilepic: map['prifilepic'],
      favoriteusers: map['favoriteusers'],
      chatedides: map['chatedides'],
    );
  }
}
