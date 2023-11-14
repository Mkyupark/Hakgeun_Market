import 'package:flutter/material.dart';
import 'dart:math' as math;

// 메인 페이지로 상품을 추가하는 양식을 포함합니다.
class AddGoodsPage extends StatelessWidget {
  const AddGoodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 물건 팔기'), // 앱바 제목 설정
        backgroundColor: const Color(0xFF2DB400), // 앱바 색상 설정
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const AddGoodsForm(),
    );
  }
}

// 상품 정보를 입력하는 양식 위젯입니다.
class AddGoodsForm extends StatefulWidget {
  const AddGoodsForm({super.key});

  @override
  _AddGoodsFormState createState() => _AddGoodsFormState();
}

class _AddGoodsFormState extends State<AddGoodsForm> {
  // 텍스트 컨트롤러와 다른 상태 변수들을 정의합니다.
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: <Widget>[
          IconButton(
            iconSize: 80,
            icon: const Icon(Icons.camera_alt, size: 50),
            onPressed: () {
              // 이미지 선택 기능 구현
            },
          ),

          // 카메라 버튼과 이미지 선택 기능을 구현합니다.

          const SizedBox(height: 20), // 여백 추가
          // 상품명을 입력하는 텍스트 필드입니다.
          TextField(
            controller: _itemNameController,
            decoration: const InputDecoration(
              labelText: '제목', // "제목"이라는 라벨을 가진 입력 필드
              border: OutlineInputBorder(), // 테두리 설정
            ),
          ),
          const SizedBox(height: 20), // 여백 추가
          // 가격을 입력하는 텍스트 필드입니다.
          TextField(
            controller: _itemDescriptionController,
            decoration: const InputDecoration(
              labelText: '가격을 입력해주세요.', // "가격을 입력해주세요."라는 라벨
              border: OutlineInputBorder(), // 테두리 설정
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20), // 여백 추가
          TextField(
            controller: _itemDescriptionController,
            decoration: const InputDecoration(
              labelText: '장소', // "가격을 입력해주세요."라는 라벨
              border: OutlineInputBorder(), // 테두리 설정
            ),
          ),
          const SizedBox(height: 20), // 여백 추가
          // 상세 설명을 입력하는 텍스트 필드입니다.
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
                labelText: '상세설명', // "상세한 설명"이라는 라벨
                border: OutlineInputBorder(), // 테두리 설정
                hintText: '''금오공대에 올릴 게시글 내용을 작성해주세요.
(판매 금지 물품은 게시가 제한될 수 있어요.)

신뢰할 수 있는 거래를 위해 자세히 적어주세요.
과학기술정보통신부, 한국 인터넷진흥원과 함께
해요.'''),
            maxLines: 10,
            textAlign: TextAlign.start,
          ),

          const SizedBox(height: 20), // 여백 추가
          // 양식 제출 버튼입니다.
          ElevatedButton(
            onPressed: () {
              // code
            },
            style: ElevatedButton.styleFrom(primary: const Color(0xFF2DB400)),
            child: const SizedBox(
              width: double.infinity,
              height: 40.0,
              child: Center(
                child: Text("작성 완료", style: TextStyle(fontSize: 16.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
