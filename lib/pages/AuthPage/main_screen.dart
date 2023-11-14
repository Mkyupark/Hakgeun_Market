import 'package:flutter/material.dart';
import 'package:hakgeun_market/pages/AuthPage/login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 200.0,
              color: Color(0xFF2DB400),
            ),
            const Text(
              "학근마켓",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "학교내 중고거래 어플리케이션\n지금 내 학교를 검색하고 시작해보세요.",
              style: TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                // 가로로 쭉 늘리기
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼이 클릭될 때의 동작 정의
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2DB400),
                    ),
                    child: const Text(
                      "시작하기",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
