import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/add_goods.dart';
import 'package:hakgeun_market/pages/detail.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:intl/intl.dart';

// Home 화면
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget _bodyWidget() {
    final GoodsService goodsService = GoodsService();

    return FutureBuilder<List<Goods>>(
        // 비동기 함수 호출
        future: goodsService.getGoodsModels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터 로딩 중일 때 보여줄 UI
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // 에러가 발생한 경우 보여줄 UI
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // 데이터가 없는 경우 보여줄 UI
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          } else {
            // 데이터가 있는 경우 보여줄 UI
            List<Goods> goodsList = snapshot.data!;
            return ListView.builder(
                itemCount: goodsList.length,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // physics: const ClampingScrollPhysics(), // bounce 효과 제거
                itemBuilder: (context, int index) {
                  Goods goods = goodsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          // 해당 라인 클릭시 상세 페이지로 이동
                          // 클릭시 goods 인덱스 전달해서 detail 페이지로 이동  goods : goods[index]
                          builder: (context) => const Detail(
                            title: '',
                          ),
                        ),
                      );
                    },
                    child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Hero(
                              tag: goods.id!,
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
                          Expanded(
                            child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 2),
                                height: 100,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        goods.title,
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
                                        int.parse(goods.price)! <= 0
                                            ? "무료나눔"
                                            : NumberFormat("###,###,###.###원")
                                                .format(int.parse(goods.price)),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                              Text(goods.likeCnt ?? "0",
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ]),
                                      )
                                    ])),
                          )
                        ])),
                  );
                });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              // + 버튼 선택시 AddGoods 페이지로 이동
              builder: (context) => const AddGoodsPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
