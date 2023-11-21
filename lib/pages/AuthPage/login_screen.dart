import 'package:flutter/material.dart';
import 'package:hakgeun_market/pages/AuthPage/regist_screen.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/pages/chatroom/chatlist.dart';
import 'package:hakgeun_market/pages/home.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController loginPhoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  @override
  void dispose() {
    loginPhoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 0,
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
              "휴대폰번호로 로그인해주세요.",
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: loginPhoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "휴대폰번호",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _smsController,
              decoration: const InputDecoration(
                labelText: "인증번호",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey, // 회색 테두리
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                const Text(
                  "학근마켓이 처음이신가요?",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 회원가입 페이지로 이동하는 코드를 여기에 추가
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistScreen()));
                  },
                  child: const Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // 클릭 이벤트 처리
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => App(),
                  ),
                );
                // 로그인 버튼을 클릭했을 때의 동작을 여기에 추가
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DB400),
              ),
              child: const SizedBox(
                width: double.infinity,
                height: 50.0,
                child: Center(
                  child: Text(
                    "로그인",
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
