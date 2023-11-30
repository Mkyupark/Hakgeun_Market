import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/models/user.dart';
import 'package:hakgeun_market/pages/app.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/pages/chatroom/chatroom.dart';

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
  var isLoading = true;
  late bool isHeartOn;
  late bool isSoldOut;
  late int likeCount;

// 채팅방 이름 생성을 도와주는 함수
  String _generateChatRoomName(String nickName1, String nickName2) {
    // 닉네임을 알파벳 순으로 정렬하여 일관된 순서를 보장합니다.
    List<String> nicknames = [nickName1, nickName2];

    return "${nicknames[0]}_${nicknames[1]}";
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
  Future<void> _createChatRoom(
      String chatRoomName, String rname, String uid1, String uid2) async {
    try {
      // Firestore에서 chatRooms 컬렉션에 새 문서를 생성합니다.
      DocumentReference chatRoomRef =
          FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomName);

      // 채팅방 정보를 추가합니다.
      await chatRoomRef.set({
        'rname': rname,
        'uid1': uid1,
        'uid2': uid2,
      });

      // "messages" 서브컬렉션을 추가합니다.
      await chatRoomRef.collection('messages').add({});
    } catch (e) {
      print('Error creating chat room: $e');
      // Handle the error appropriately
    }
  }

  @override
  void initState() {
    // 위젯이 생성될 때 Firebase에서 데이터를 가져옴.(상태초기화)
    super.initState();
    isHeartOn = false;
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
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
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
        child: Image.asset(
          imageUrl,
          width: 100,
          height: 300,
          fit: BoxFit.fill,
        ));
  }

  // 매너 온도 등을 표시하는 위젯 생성 함수
  Widget _temp() {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      "36.5°C",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            height: 6,
                            color: Colors.black.withOpacity(0.2),
                            child: Row(
                              children: [
                                Container(
                                    height: 6, width: 40, color: Colors.green),
                              ],
                            )))
                  ],
                )
              ],
            ),
          ),
          const Text(
            "매너온도",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 12,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  Widget _tempset() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(
        children: [
          _temp(),
          Container(
              width: 30,
              height: 30,
              child: Image.asset("assets/images/level-3.jpg"))
        ],
      ),
    ]));
  }

  // 판매자 정보와 매너 온도를 표시하는 위젯 생성 함수
  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
              child: Stack(
            children: [
              Positioned(
                  child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        Image.asset("assets/images/user.png").image,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goodsData!.username,
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
              )),
              Positioned(right: 0, child: _tempset())
            ],
          )),
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
                  " 조회 ${goodsData!.readCnt}",
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
                setState(() {
                  incrementLikeCount();
                  widget.goods.likeCnt = likeCount.toString();
                  //관심 수 업데이트 함수(goods.likeCnt Update)
                  //addMyFavoriteContent(widget.goods);
                  isHeartOn = !isHeartOn;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("관심목록에 등록되었습니다."),
                  duration: const Duration(seconds: 1),
                  action: SnackBarAction(
                    label: '취소',
                    onPressed: () {
                      setState(() {
                        isHeartOn = !isHeartOn;
                      });
                    }, //버튼 눌렀을때.
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("관심목록에서 해제했습니다."),
                    duration: Duration(seconds: 1),
                  ),
                );
                setState(() {
                  isHeartOn = !isHeartOn;
                });
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
                "${goodsData!.price}원",
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
                    color: (goodsData!.username == currentUser!.nickName || isSoldOut) 
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
                    onTap: goodsData!.username == currentUser.nickName
                        ? null // Disable onTap if usernames match
                        : () async {
                            // Your existing onTap logic here
                            String chatRoomName = _generateChatRoomName(
                                goodsData!.username, currentUser!.nickName);
                            bool roomExists =
                                await _checkIfChatRoomExists(chatRoomName);
                            if (!roomExists) {
                              await _createChatRoom(chatRoomName, chatRoomName,
                                  goodsData!.username, currentUser.nickName);
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  rname: chatRoomName,
                                  uid2: goodsData!.username,
                                  uid1: currentUser.nickName,
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
    .where((goods) => goods.category == selectedCategory
    && currentDetail != goods.id)
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
              if (filteredGoods == null ||
                  index >= filteredGoods.length) {
                // goodsDataList가 null이거나 인덱스가 범위를 벗어날 경우 에러 방지
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
                                ? Image.asset(
                                    goods.photoList![0],
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
                        Text(
                          goods.title,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "${goods.price}원",
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
  
  void incrementLikeCount(){
    setState(() {
      likeCount++;
    });
  }
  // 관심목록 등록하는 함수
  // void addMyFavoriteContent(Goods goods) async{
  //   final GoodsService goodsService = GoodsService();
  //   await goodsService.updateGoodsModel(widget.goods);
  // }

}
