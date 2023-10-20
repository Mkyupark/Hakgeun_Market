import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/add_goods.dart';
import 'package:hakgeun_market/pages/detail.dart';
import 'package:hakgeun_market/sample/sample.dart';
import 'package:intl/intl.dart';

// Home 화면
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      elevation: 1,
      title: GestureDetector(
        onTap: () {
          print('Click!');
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            // 돋보기 아이콘을 눌렀을 때 실행될 코드를 추가하세요.
          },
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {
            // 목록 아이콘을 눌렀을 때 실행될 코드를 추가하세요.
          },
          icon: SvgPicture.asset('assets/svg/menu.svg'),
        ),
        IconButton(
          onPressed: () {
            // 검색 아이콘을 눌렀을 때 실행될 코드를 추가하세요.
          },
          icon: SvgPicture.asset('assets/svg/bell-outline.svg'),
        ),
      ],
    );
  }

  Widget _bodyWidget(List<Goods> goods) {
    if (goods.isNotEmpty) {
      return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // physics: const ClampingScrollPhysics(), // bounce 효과 제거
          itemBuilder: (BuildContext _context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // 해당 라인 클릭시 상세 페이지로 이동
                    // 클릭시 goods 인덱스 전달해서 detail 페이지로 이동  goods : goods[index]
                    builder: (context) => const Detail(),
                  ),
                );
              },
              child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Hero(
                        tag: goods[index].id!,
                        child: goods[index].photoList != null &&
                                goods[index].photoList!.isNotEmpty
                            ? Image.asset(
                                goods[index].photoList![0],
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
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.only(left: 20, top: 2),
                          height: 100,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  goods[index].title,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  goods[index].price <= 0
                                      ? "무료나눔"
                                      : NumberFormat("###,###,###.###원")
                                          .format(goods[index].price),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Expanded(
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/svg/chat-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        const Text(
                                          '77',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SvgPicture.asset(
                                            'assets/svg/cards-heart-outline.svg',
                                            width: 17,
                                            height: 17),
                                        const SizedBox(
                                          width: 1,
                                        ),
                                        Text(goods[index].likeCnt.toString(),
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ]),
                                )
                              ])),
                    )
                  ])),
            );
          },
          separatorBuilder: (BuildContext _context, int index) {
            return Container(
                height: 1, color: const Color.fromARGB(150, 163, 155, 155));
          },
          itemCount: goods.length);
    } else {
      return const Center(child: Text("데이터가 없습니다."));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _appbarWidget(),
      body: _bodyWidget(dummyData_Goods),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // + 버튼 선택시 AddGoods 페이지로 이동
              builder: (context) => AddGoods(),
            ),
          );
        },
        backgroundColor: const Color(0xFFF08F4F),
        child: const Icon(Icons.add),
      ),
    );
  }
}
