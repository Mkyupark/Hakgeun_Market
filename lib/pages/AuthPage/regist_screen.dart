// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakgeun_market/models/user.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/userService.dart';
import 'package:provider/provider.dart';

class RegistScreen extends StatefulWidget {
  final String phoneNumber;

  const RegistScreen({super.key, required this.phoneNumber});
  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  String? selectedSchool;
  bool get isFormValid =>
      _nicknameController.text.isNotEmpty && selectedSchool != null;

  void register() async {
    if (isFormValid) {
      try {
        final user = UserModel(
          id: FirebaseAuth.instance.currentUser!.uid,
          phoneNum: widget.phoneNumber,
          nickName: _nicknameController.text,
          schoolName: selectedSchool!,
          likeList: [],
        );

        // UserService 인스턴스 생성
        final userService = UserService();
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // Firestore에 사용자 정보 저장
        await userService.createUser(user);

        // App 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
      } catch (e) {
        // 닉네임 중복 예외 처리
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("회원가입 오류"),
              content: const Text("이미 사용 중인 닉네임입니다. 다른 닉네임을 선택해 주세요."),
              actions: <Widget>[
                TextButton(
                  child: const Text("확인"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> schools = [
      "금오공과대학교",
      "구미대학교",
      "경운대학교",
      "한국폴리텍대학 구미캠퍼스",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        title: const Text("프로필 설정", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            const Text("반갑습니다!", style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 7.0),
            const Text("프로필 설정을 해주세요.", style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 20.0),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: "닉네임",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: selectedSchool,
              items: schools.map((school) {
                return DropdownMenuItem<String>(
                  value: school,
                  child: Text(school),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSchool = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "학교 선택",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: isFormValid ? () => register() : null,
              style: ElevatedButton.styleFrom(primary: const Color(0xFF2DB400)),
              child: const SizedBox(
                width: double.infinity,
                height: 40.0,
                child: Center(
                  child: Text("프로필 설정 완료", style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
