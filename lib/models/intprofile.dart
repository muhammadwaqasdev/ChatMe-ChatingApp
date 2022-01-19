import 'dart:convert';

class IntrestProfile {
  String? icuntery;
  String? iagestart;
  String? iageend;
  String? gender;
  IntrestProfile({
    this.icuntery,
    this.iagestart,
    this.iageend,
    this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'icuntery': icuntery,
      'iagestart': iagestart,
      'iageend': iageend,
      'gender': gender,
    };
  }

  factory IntrestProfile.fromMap(Map<String, dynamic> map) {
    return IntrestProfile(
      icuntery: map['icuntery'],
      iagestart: map['iagestart'],
      iageend: map['iageend'],
      gender: map['gender'],
    );
  }
}
