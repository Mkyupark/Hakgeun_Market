import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String phoneNum;
  final String nickName;
  final String schoolName;
  final double mannerTemperature;

  User({
    required this.id,
    required this.phoneNum,
    required this.nickName,
    required this.schoolName,
    required this.mannerTemperature,
  });

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNum,
      'nickname': nickName,
      'schoolName': schoolName,
      'mannerTemperature': mannerTemperature,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      phoneNum: data['phoneNumber'] ?? '정보없음',
      nickName: data['nickname'] ?? '이름없음',
      schoolName: data['schoolName'] ?? '정보없음',
      mannerTemperature: (data['mannerTemperature'] ?? 0).toDouble(),
    );
  }
}
