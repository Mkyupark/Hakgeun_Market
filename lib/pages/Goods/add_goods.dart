import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/service/userService.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
  XFile? _image;
  String userId = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker picker = ImagePicker();
  final UserService userService = UserService();
  late String firstCate = "기타";
  final List<String> temp = ["가구", "의류", "전자기기", "주방용품", "기타"];
  final List<String> schools = [
    "금오공과대학교",
    "구미대학교",
    "경운대학교",
    "한국폴리텍대학 구미캠퍼스",
  ];
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

// 텍스트 컨트롤러와 다른 상태 변수들을 정의합니다.
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late String _location = "기타";
  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void register() async {
    final goodsService = GoodsService();

    DocumentReference userReference =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // if (user == null) {
    //   debugPrint("유저 정보 없음 ${userReference}");
    // } else {
    //   debugPrint("유저 정보 있음 ${userReference}");
    // }
    // debugPrint(" 현재 시간: ${Timestamp.now()}");

    final goods = Goods(
        photoList: [],
        user: userReference,
        title: _itemNameController.text,
        content: _itemDescriptionController.text,
        price: _priceController.text,
        loc: _location,
        likeCnt: "0",
        readCnt: "0",
        uploadTime: Timestamp.now(),
        updateTime: Timestamp.now(),
        category: firstCate);

    await goodsService.CreateGoods(goods);
    // App 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => App()),
    );
  }

  // 삭제 버튼 추가
  Widget deleteButton(String goodsid) {
    final goodsService = GoodsService();
    return ElevatedButton(
      onPressed: () {
        goodsService.delGoodsModel(goodsid);
      },
      style: ElevatedButton.styleFrom(primary: const Color(0xFF2DB400)),
      child: const SizedBox(
        width: double.infinity,
        height: 40.0,
        child: Center(
          child: Text("삭제", style: TextStyle(fontSize: 16.0)),
        ),
      ),
    );
  }

  // 유저 정보와 만든사람이 일치하는지 확인
  // 이 함수 detail에서 판별해서 넘겨줘야할듯
  // 어차피 상품이 일치하지않으면 수정 권한도 없기 때문에 delete버튼만 추가하면 될듯.
  bool checkUserToGoods(Goods goods) {
    DocumentReference? userReference = goods.user;
    String path = userReference!.path;
    String userData = path.substring(path.indexOf('/') + 1);

    if (userData == userId)
      return true;
    else
      return false;
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
                getImage(ImageSource.gallery);
              },
            ),

            // 카메라 버튼과 이미지 선택 기능을 구현합니다.

            const SizedBox(height: 20), // 여백 추가
            // 상품명을 입력하는 텍스트 필드입니다.
            TextField(
              controller: _itemNameController,
              onChanged: (value) {
                // setState(() => item?.title = value);
              },
              decoration: const InputDecoration(
                labelText: '제목', // "제목"이라는 라벨을 가진 입력 필드
                border: OutlineInputBorder(), // 테두리 설정
              ),
            ),
            const SizedBox(height: 20), // 여백 추가
            // 가격을 입력하는 텍스트 필드입니다.
            TextField(
              controller: _priceController,
              onChanged: (value) {
                // setState(() => item?.price = value);
              },
              decoration: const InputDecoration(
                labelText: '가격을 입력해주세요.', // "가격을 입력해주세요."라는 라벨
                border: OutlineInputBorder(), // 테두리 설정
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20), // 여백 추가
            DropdownButtonFormField<String>(
              value: "금오공과대학교",
              items: schools.map((school) {
                return DropdownMenuItem<String>(
                  value: school,
                  child: Text(school),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _location = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "위치 선택",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20), // 여백 추가
            // 상세 설명을 입력하는 텍스트 필드입니다.
            TextField(
              controller: _itemDescriptionController,
              onChanged: (value) {
                // setState(() => item?.content = value);
              },
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
            const SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: firstCate,
              items: temp.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  firstCate = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: "카테고리 선택",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20), // 여백 추가
            // 양식 제출 버튼입니다.
            ElevatedButton(
              onPressed: () {
                register();
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF2DB400),
                minimumSize: const Size(double.infinity, 40.0),
              ),
              child: const SizedBox(
                width: double.infinity,
                height: 40.0,
                child: Center(
                  child: Text("작성 완료", style: TextStyle(fontSize: 16.0)),
                ),
              ),
            ),
            // detail에서 값 넘어올 시 삭제 버튼 => 유저 정보랑 일치할 경우
            // if(checkUserToGoods(goods)){
            //   deleteButton(goods.id);
            // }
          ],
        ));
  }
}
