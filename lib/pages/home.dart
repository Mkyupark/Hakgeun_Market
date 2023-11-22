import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/add_goods.dart';
import 'package:hakgeun_market/pages/detail.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final List<Goods> SearchData;

  const Home({required this.SearchData});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddGoodsPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bodyWidget() {
    if (widget.SearchData.isEmpty) {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: widget.SearchData.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, int index) {
          Goods goods = widget.SearchData[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Detail(searchData: [],),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Hero(
                      tag: goods.id!,
                      child:
                          goods.photoList != null && goods.photoList!.isNotEmpty
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
                      padding: const EdgeInsets.only(left: 20, top: 2),
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goods.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
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
                                ? '무료나눔'
                                : NumberFormat('###,###,###.###원')
                                    .format(int.parse(goods.price)),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/chat-outline.svg',
                                  width: 17,
                                  height: 17,
                                ),
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
                                  height: 17,
                                ),
                                const SizedBox(
                                  width: 1,
                                ),
                                Text(
                                  goods.likeCnt ?? '0',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
