// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistScreen extends StatefulWidget {
  const RegistScreen({super.key});

  @override
  _RegistScreenState createState() => _RegistScreenState();
}

class _RegistScreenState extends State<RegistScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedSchool = "금오공과대학교";
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();

  String? verificationId;

  Future<void> _verifyPhoneNumber() async {
    verificationCompleted(AuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number automatically verified!')),
      );
    }

    verificationFailed(FirebaseAuthException e) {
      print(e.code); // This will print the specific error code
      print(e.message); // This will print the error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification failed. Please try again.')),
      );
    }

    codeSent(String verificationId, int? resendToken) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Verification code sent on the phone number')),
      );
      this.verificationId = verificationId;
    }

    codeAutoRetrievalTimeout(String verificationId) {
      this.verificationId = verificationId;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: _smsController.text,
      );

      final User? user = (await _auth.signInWithCredential(credential)).user;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Successfully signed up with UID: ${user?.uid}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
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
        title: const Text("회원가입", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10.0),
            const Text("안녕하세요!", style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 7.0),
            const Text("휴대폰 번호로 회원가입 해주세요.", style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 20.0),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "휴대폰번호",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _smsController,
              decoration: const InputDecoration(
                labelText: "인증 코드",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: const Text("SMS 보내기"),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: const Text("인증확인"),
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
              onPressed: () {
                // Handle further registration steps here
              },
              style: ElevatedButton.styleFrom(primary: const Color(0xFF2DB400)),
              child: const SizedBox(
                width: double.infinity,
                height: 50.0,
                child: Center(
                  child: Text("회원가입 완료", style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
