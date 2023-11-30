import 'package:flutter/material.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/service/goodsService.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(List<Goods>) onSearchCallback;
  final int num;
  const CustomAppBar(
      {super.key, required this.onSearchCallback, required this.num});

  @override
  _CustomAppBarState createState() => _CustomAppBarState(num: num);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final int num;
  _CustomAppBarState({required this.num});

  final TextEditingController _searchController = TextEditingController();
  late String selectedCategory = "전체";
  final List<String> temp = ["전체", "가구", "의류", "전자기기", "주방용품", "기타"];
  final List<String> temp2 = ["학근 마켓", "관심목록", "채팅", "내정보"];
  @override
  void initState() {
    super.initState();
    _SearchAllGoodsModel(context, searchTerm: "", category: selectedCategory);
  }

  void _showCategoryDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("카테고리 선택"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButton<String>(
                value: selectedCategory,
                items: temp.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _SearchByCategory(context, selectedCategory);
                _searchController.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("상품 검색"),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: "상품 검색",
            ),
            onSubmitted: (value) {
              _SearchAllGoodsModel(context,
                  searchTerm: value, category: selectedCategory);
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                // Perform search logic here
                _SearchAllGoodsModel(context,
                    searchTerm: _searchController.text,
                    category: selectedCategory);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("검색"),
            ),
          ],
        );
      },
    );
  }

  void _SearchByCategory(BuildContext context, String category) async {
    final GoodsService goodsService = GoodsService();
    List<Goods> goods = await goodsService.getGoodsModelsByCategory(category);
    widget.onSearchCallback(goods);
  }

  void _SearchAllGoodsModel(BuildContext context,
      {String searchTerm = "", String category = "전체"}) async {
    final GoodsService goodsService = GoodsService();
    List<Goods> goods = await goodsService.getGoodsModels(
        searchGoods: searchTerm, category: category);

    // 검색 결과를 콜백으로 전달
    widget.onSearchCallback(goods);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        temp2[widget.num],
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _showSearchDialog(context);
          },
          color: Colors.white,
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _showCategoryDialog(context);
          },
          color: Colors.white,
        ),
        // IconButton(
        //   icon: Icon(Icons.notifications),
        //   onPressed: () {},
        //   color: Colors.white,
        // ),
      ],
    );
  }
}
