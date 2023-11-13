import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hakgeun_market/firebase_options.dart';
import 'package:hakgeun_market/pages/AuthPage/main_screen.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/navigation_provider.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<NavigationProvider>(
        create: (context) => NavigationProvider()),
    ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider())
  ], child: const MainScreen()));
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
              cursorColor: Colors.green,
              selectionColor: Colors.green,
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
