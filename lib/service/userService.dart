import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakgeun_market/models/user.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 싱글톤 인스턴스
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<void> createUser(UserModel user) async {
    // 닉네임으로 이미 존재하는 사용자를 찾습니다.
    var querySnapshot = await _db
        .collection('users')
        .where('nickname', isEqualTo: user.nickName)
        .get();

    // 이미 존재하는 닉네임이 없는 경우에만 사용자를 생성합니다.
    if (querySnapshot.docs.isEmpty) {
      await _db.collection('users').doc(user.id).set(user.toMap());
    } else {
      throw Exception('닉네임이 이미 존재합니다.');
    }
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.id).update(user.toMap());
  }

  Future<void> deleteUser(String userId) async {
    await _db.collection('users').doc(userId).delete();
  }

  Future<UserModel?> getUserFromUID(String userId) async {
    try {
      var snapshot = await _db.collection('users').doc(userId).get();
      if (snapshot.exists) {
        return UserModel.fromDocument(snapshot);
      } else {
        return null; // 사용자를 찾을 수 없을 때 null을 반환합니다.
      }
    } catch (e) {
      // 에러 처리
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<UserModel?> getUserFromUserModel(UserModel user) async {
    try {
      var snapshot = await _db.collection('users').doc(user.id).get();
      if (snapshot.exists) {
        return UserModel.fromDocument(snapshot);
      } else {
        return null; // 사용자를 찾을 수 없을 때 null을 반환합니다.
      }
    } catch (e) {
      // 에러 처리
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> isUserRegistered(String uid) async {
    var doc = await _db.collection('users').doc(uid).get();
    return doc.exists; // 문서가 존재하면 true, 그렇지 않으면 false를 반환합니다.
  }

  Future<List<String>>? getUserLikeList(String userId) async {
    DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
    UserModel user = UserModel.fromDocument(userDoc);
    return user.likeList ?? [];
  }
}
