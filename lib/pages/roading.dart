// 로딩 페이지

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:hakgeun_market/componenets/splash_widget.dart';

// class Roading extends StatefulWidget {
//   const Roading({super.key});

//   @override
//   State<Roading> createState() => _IntroState();
// }

// class _IntroState extends State<Roading> {
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Center(
//           child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Splash 위젯 표시
//           SplashWidget()
//         ],
//       )),
//     );
//   }

//   Future<Timer> _loadData() async {
//     // 약 3초 후 App 페이지로 이동
//     return Timer(Duration(seconds: 3), _onDoneLoading);
//   }

//   _onDoneLoading() async {
//     // 기타 필수 기초 데이터 로딩 및 선 처리 작업
//     Navigator.of(context)
//         .pushReplacement(MaterialPageRoute(builder: (context) => App()));
//   }
// }
