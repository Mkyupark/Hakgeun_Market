import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/models/user.dart';
import 'package:hakgeun_market/pages/Goods/edit_goods.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/service/userService.dart';
import 'package:hakgeun_market/pages/chatroom/chatroom.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Detail extends StatefulWidget {
  final Goods goods;
  final List<Goods> goodsDataList;
  const Detail(
      {super.key,
      required this.goods,
      required this.goodsDataList}); // 생성자: 상품의 id를 받음.

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late Goods? goodsData;
  late List<Goods> goodsList;
  late String selectedCategory = "전체";
  late String currentDetail;
  final UserProvider _userProvider = UserProvider();
  final goodsService = GoodsService();
  final userService = UserService();
  var isLoading = true;
  late bool isHeartOn;
  late bool isSoldOut;
  late int likeCount;

// 채팅방 이름 생성을 도와주는 함수
  String _generateChatRoomName(String nickName1, String nickName2) {
    // 닉네임을 알파벳 순으로 정렬하여 일관된 순서를 보장합니다.
    List<String> nicknames = [nickName1, nickName2];

    return "${nicknames[0]}_${nicknames[1]}_${goodsData!.id}";
  }

  Future<bool> _AddChatCnt() async {
    try {
      QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
          .collection('goods')
          .where('id', isEqualTo: goodsData!.id)
          .get();
      DocumentReference<Object?> documentReference =
          querySnapshot.docs[0].reference;
      await documentReference.update({
        'chatCnt': (int.parse(goodsData!.chatCnt!) + 1).toString(),
      });
      return true;
    } catch (e) {
      print("조회수 증가 오류 발생: $e");
      return false;
    }
  }

// 채팅방이 이미 존재하는지 확인하는 함수
  Future<bool> _checkIfChatRoomExists(String chatRoomName) async {
    try {
      // Firestore에서 chatRooms 컬렉션의 해당 문서를 가져옵니다.
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomName)
          .get();

      // 문서가 존재하면 true를 반환합니다.
      return snapshot.exists;
    } catch (e) {
      // 에러가 발생하면 false를 반환합니다.
      print("채팅방 확인 중 오류 발생: $e");
      return false;
    }
  }

// 채팅방을 생성하는 함수
  Future<void> _createChatRoom(String chatRoomName, String rname, String uid1,
      String uid2, String id) async {
    try {
      // Firestore에서 chatRooms 컬렉션에 새 문서를 생성합니다.
      DocumentReference chatRoomRef =
          FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomName);

      // 채팅방 정보를 추가합니다.
      await chatRoomRef.set({
        'rname': rname,
        'uid1': uid1,
        'uid2': uid2,
        'id': goodsData!.id,
      });

      // "messages" 서브컬렉션을 추가합니다.
      await chatRoomRef.collection('messages').add({});
    } catch (e) {
      print('Error creating chat room: $e');
      // Handle the error appropriately
    }
  }

  // detail 페이지에서 유저 정보 일치하는지 판별하는 함수
  bool _isTrueUserInfo() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user?.nickName == widget.goods.saler) {
      return true;
    } else
      return false;
  }

  @override
  void initState() {
    // 위젯이 생성될 때 Firebase에서 데이터를 가져옴.(상태초기화)
    super.initState();
    UserModel? currentUser = _userProvider.user;

    if (currentUser?.likeList?.contains(widget.goods.id) ?? false) {
      isHeartOn = true;
    } else {
      isHeartOn = false;
    }
    isSoldOut = false;
    likeCount = int.parse(widget.goods.likeCnt ?? "0");
    goodsData = widget.goods;
    goodsList = widget.goodsDataList;
  }

  // 앱 바 위젯 생성 함수
  PreferredSizeWidget _appbarWidget() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
    );
  }

  // 이미지 위젯 생성 함수
  Widget _makeimage() {
    if (goodsData?.photoList == null || goodsData!.photoList!.isEmpty) {
      return Container(
          width: double.infinity,
          child: Image.asset(
            'assets/images/empty.jpg',
            width: 100,
            height: 300,
            fit: BoxFit.fill,
          ));
    }
    String imageUrl = goodsData!.photoList![0];
    return Container(
        width: double.infinity,
        child: Image.memory(
          goodsService.base64StringToImage(imageUrl),
          width: 100,
          height: 300,
          fit: BoxFit.fill,
        ));
  }

  // 판매자 정보를 표시하는 위젯 생성 함수
  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                goodsData!.saler ?? "null",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                goodsData!.loc ?? "금오공과대학교",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 구분선 생성 함수
  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  // 상품 내용 상세 정보를 표시하는 위젯 생성 함수
  Widget _contentDetail() {
    if (goodsData == null) return Container(); // 데이터가 없는 경우
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            if (_isTrueUserInfo())
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          goodsData!.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 수정 아이콘
                  GestureDetector(
                    onTap: () {
                      // 수정 아이콘을 눌렀을 때 수행할 동작
                      print(goodsData?.id);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => Home(SearchData: goodsList)),
                            builder: (context) =>
                                EditGoodsPage(goods: goodsData!)),
                      );
                      print('Edit icon pressed');
                    },
                    child: Icon(
                      Icons.edit,
                      size: 30,
                    ),
                  ),
                  // 삭제 아이콘
                  GestureDetector(
                    onTap: () {
                      // 삭제 아이콘을 눌렀을 때 수행할 동작
                      print(goodsData?.id);
                      goodsService.delGoodsModel(goodsData!.id ?? "null");
                      print('Delete icon pressed');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => App()),
                        (route) => false,
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      size: 30,
                    ),
                  ),
                ],
              )
            else
              Text(
                goodsData!.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            Text(
              goodsData!.category,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              goodsData!.content ?? '',
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Text(
                  "관심 ${goodsData!.likeCnt} ·",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  " 채팅수 ${goodsData!.chatCnt}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ));
  }

  // 판매자의 다른 상품 정보를 표시하는 섹션 생성 함수
  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: GestureDetector(
        onTap: () {
          // "모두보기" 버튼을 눌렀을 때 AllProductsPage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                // builder: (context) => Home(SearchData: goodsList)),
                builder: (context) => App()),
          );
        },
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "이 글과 함께 봤어요",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "모두보기",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 하단 바 생성 함수
  Widget _bottomBarWidget() {
    UserModel? currentUser = _userProvider.user;

    void updateLikeList() async {
      await UserService().updateUser(currentUser!);
    }

    if (goodsData!.buyer != null) {
      isSoldOut = true;
    }

    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      height: 55,
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (isHeartOn == false) {
                currentUser?.likeList?.add(goodsData?.id ?? "");
                updateLikeList(); // 사용자 정보 업데이트
                setState(() {
                  updateLikeCount(true); // LikeCnt 증가 함수
                  isHeartOn = !isHeartOn; // 좋아요 상태 변경
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("관심목록에 등록되었습니다."),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                    label: '취소',
                    onPressed: () {
                      // 취소 로직
                      currentUser?.likeList?.remove(goodsData?.id);
                      updateLikeList(); // 좋아요 제거
                      setState(() {
                        updateLikeCount(false); // LikeCnt 감소
                        isHeartOn = !isHeartOn; // 좋아요 상태 변경
                      });
                    }, // 버튼 눌렀을때.
                  ),
                ));
              } else {
                // 관심목록 제거
                currentUser?.likeList?.remove(goodsData?.id);
                updateLikeList();
                setState(() {
                  updateLikeCount(false);
                  isHeartOn = !isHeartOn;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("관심목록에서 해제했습니다."),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: SvgPicture.asset(
              isHeartOn
                  ? "assets/svg/heart_on.svg"
                  : "assets/svg/heart_off.svg",
              width: 20,
              height: 20,
              color: Colors.green,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                int.parse(goodsData!.price) <= 0
                    ? '무료나눔'
                    : NumberFormat('###,###,###.###원')
                        .format(int.parse(goodsData!.price)),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: isSoldOut ||
                            goodsData!.saler == currentUser!.nickName
                        ? Colors
                            .grey // Change the color to grey if usernames match, 판매완료시에도 바꿈.
                        : Colors.green, // Use green otherwise
                  ),
                  child: isSoldOut
                      ? const Text(
                          "판매완료",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )
                      : GestureDetector(
                          onTap: goodsData!.saler == currentUser!.nickName
                              ? null // Disable onTap if usernames match
                              : () async {
                                  // Your existing onTap logic here
                                  String chatRoomName = _generateChatRoomName(
                                      goodsData!.saler ?? "NULL",
                                      currentUser.nickName);
                                  bool roomExists =
                                      await _checkIfChatRoomExists(
                                          chatRoomName);
                                  if (!roomExists) {
                                    await _createChatRoom(
                                      chatRoomName,
                                      chatRoomName,
                                      goodsData!.saler ?? "",
                                      currentUser.nickName,
                                      goodsData!.id ?? "",
                                    );
                                    await _AddChatCnt();
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        rname: chatRoomName,
                                        uid2: goodsData!.saler ?? "",
                                        uid1: currentUser.nickName,
                                        id: goodsData!.id!,
                                      ),
                                    ),
                                  );
                                },
                          child: const Text(
                            "채팅으로 거래하기",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 메인 바디 위젯 생성 함수
  Widget _bodyWidget() {
    // if (isLoading) {
    //   return Center(child: CircularProgressIndicator());
    // }
    currentDetail = goodsData!.id ?? "";
    selectedCategory = goodsData!.category;
    List<Goods> filteredGoods = widget.goodsDataList
        .where((goods) =>
            goods.category == selectedCategory && currentDetail != goods.id)
        .take(6)
        .toList();
    print(widget.goods.toString());

    return CustomScrollView(slivers: [
      SliverList(
        delegate: SliverChildListDelegate(
          [
            _makeimage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ],
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              Goods goods = filteredGoods[index];
              // goodsDataList에서 각 아이템 가져오기
              if (index >= filteredGoods.length) {
                // 인덱스가 범위를 벗어날 경우 에러 방지
                return Container();
              }
              //if( firebase에서 갖고온 goods.category  == goods.category){
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Detail(
                              goods: goods,
                              goodsDataList: widget.goodsDataList)));
                },
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey.withOpacity(0.3),
                          height: 120,
                          child: goods.photoList != null &&
                                  goods.photoList!.isNotEmpty
                              ? Image.memory(
                                  goodsService
                                      .base64StringToImage(goods.photoList![0]),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/images/empty.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Expanded(
                        child: Text(
                          goods.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Text(
                        int.parse(goods.price) <= 0
                            ? '무료나눔'
                            : NumberFormat('###,###,###.###원')
                                .format(int.parse(goods.price)),
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
              // if (goods.photoList == null || goods.photoList!.isEmpty) {
              //   // photoList가 null이거나 비어 있을 경우 에러 방지
              //   return Container();
              // }
            },
            childCount: filteredGoods.length,
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appbarWidget(),
        body: _bodyWidget(),
        bottomNavigationBar: _bottomBarWidget());
  }

  void updateLikeCount(bool increment) {
    setState(() {
      if (increment) {
        likeCount++;
      } else {
        if (likeCount > 0) likeCount--;
      }
      setState(() {
        goodsData?.likeCnt = likeCount.toString(); // Goods 객체의 likeCnt도 업데이트
      });
    });
    updateGoodsLikeCount();
  }

  void updateGoodsLikeCount() async {
    if (goodsData != null) {
      await goodsService
          .updateGoodsModel(goodsData!); // GoodsService를 사용하여 업데이트
    }
  }
}
