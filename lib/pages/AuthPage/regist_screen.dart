// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({Key? key}) : super(key: key);

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  String selectedSchool = "금오공과대학교"; // 초기 선택 학교

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
        backgroundColor: Colors.white, // AppBar의 배경색을 흰색으로 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // 아이콘 색상 설정
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로 가기 아이콘 동작
          },
        ),
        elevation: 0, // AppBar의 그림자를 없애는 부분
        title: const Text("회원가입",
            style: TextStyle(color: Colors.black)), // 타이틀 색상 설정
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            const Text(
              "안녕하세요!",
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 7.0),
            const Text(
              "휴대폰 번호로 회원가입 해주세요.",
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 20.0),
            // 휴대폰번호 입력 필드
            const TextField(
              decoration: InputDecoration(
                labelText: "휴대폰번호",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // 비밀번호 입력 필드
            const TextField(
              decoration: InputDecoration(
                labelText: "비밀번호",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            // 비밀번호 확인 입력 필드
            const TextField(
              decoration: InputDecoration(
                labelText: "비밀번호 확인",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            // 닉네임 입력 필드
            const TextField(
              decoration: InputDecoration(
                labelText: "닉네임 입력",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            // 학교 선택 드롭다운 메뉴
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
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // 회원가입 버튼을 클릭했을 때의 동작을 여기에 추가
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2DB400),
              ),
              child: const SizedBox(
                width: double.infinity,
                height: 50.0,
                child: Center(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
