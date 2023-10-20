import 'package:flutter/material.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NavigationProvider>(
        create: (context) => NavigationProvider()),
  ], child: const MyApp()));
  //runApp(const MyApp());
}

// 상태 관리  위한 provider 변수 선언 위치
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '학근마켓',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xfff08f4f),
              selectionColor: Color(0xfff08f4f),
              selectionHandleColor: Colors.black),
          colorScheme: const ColorScheme(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: Colors.white,
            onBackground: Colors.black,
            secondary: Colors.white,
            onSecondary: Colors.white,
            error: Colors.black,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        // home -> 페이지 시작 화면
        home: App());
  }
}
