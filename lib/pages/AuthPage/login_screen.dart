import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hakgeun_market/models/user.dart';
import 'package:hakgeun_market/pages/AuthPage/regist_screen.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/AuthService.dart';
import 'package:hakgeun_market/service/userService.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _verificationId;
  final userService = UserService();
  bool _isOTPSent = false;

  void _verifyPhoneNumber() async {
    String phoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    phoneNumber = '+82${phoneNumber.substring(1)}';

    await _authService.verifyPhoneNumber(
      phoneNumber,
      (verificationId) {
        // 코드가 전송되면 이 콜백이 호출됩니다.
        setState(() {
          _verificationId = verificationId;
          _isOTPSent = true; // OTP가 전송되었음을 나타냅니다.
        });
      },
    );
  }

  void _signInWithOTP() async {
    if (_verificationId != null && _otpController.text.isNotEmpty) {
      bool isSuccess = await _authService.signInWithVerificationCode(
        _verificationId!,
        _otpController.text,
      );

      if (isSuccess) {
        // FirebaseAuth 인스턴스로부터 현재 사용자의 uid를 가져옵니다.
        User? currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null) {
          // 사용자가 이미 가입되어 있는지 확인합니다.
          bool isRegistered =
              await userService.isUserRegistered(currentUser.uid);

          if (isRegistered) {
            // 이미 가입된 사용자인 경우, User 정보를 가져와서 UserProvider에 저장합니다.
            UserModel? user = await userService.getUserFromUID(currentUser.uid);
            if (user != null) {
              // UserProvider에 저장
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).setUser(user);
            }
            // App 화면으로 이동
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => App()), // App()은 메인 스크린으로 돌아가는 라우트
            );
          } else {
            // 가입되지 않은 사용자인 경우, RegistScreen으로 이동하며 휴대폰 번호 정보를 전달합니다.
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        RegistScreen(phoneNumber: _phoneController.text)));
          }
        } else {
          // 사용자가 로그인되어 있지 않다면, 적절한 처리를 수행하세요.
          // 예를 들어, 로그인 페이지로 이동하거나 메시지를 표시할 수 있습니다.
          // ...
        }
      } else {
        _showErrorDialog('Failed to Sign In');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  bool _loading = false; // Add this variable to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('휴대폰 인증', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '안녕하세요!\n휴대폰 번호로 로그인 해주세요.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text(
              '휴대폰 번호는 안전하게 보관되며 이웃들에게 공개되지 않아요.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                  labelText: '휴대폰 번호 (-없이 숫자만 입력)',
                  border: OutlineInputBorder()),
              cursorColor: const Color(0xFF2DB400),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            if (_isOTPSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: '인증번호 입력',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              height: 40.0,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : (_isOTPSent
                        ? _phoneController.text.isNotEmpty &&
                                _otpController.text.isNotEmpty
                            ? _signInWithOTP
                            : null
                        : _phoneController.text.isNotEmpty
                            ? () async {
                                setState(() {
                                  _loading = true;
                                });
                                _verifyPhoneNumber();
                                setState(() {
                                  _loading = false;
                                });
                              }
                            : null),
                style: ElevatedButton.styleFrom(
                  onSurface: const Color(0xFF2DB400),
                  primary: const Color(0xFF2DB400),
                ),
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(_isOTPSent ? '인증하기' : '인증문자 받기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
