import 'package:flutter/material.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/service/goodsService.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(List<Goods>) onSearchCallback;

  const CustomAppBar({required this.onSearchCallback});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _performSearch(context, searchTerm: "");
    // initState에서 필요한 초기화 코드 작성
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        "학근 마켓",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            _showSearchDialog(context);
          },
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {},
          color: Colors.white,
        ),
      ],
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
              _performSearch(context, searchTerm: value);
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
                _performSearch(context, searchTerm: _searchController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("검색"),
            ),
          ],
        );
      },
    );
  }

  void _performSearch(BuildContext context, {String searchTerm = ""}) async {
    final GoodsService goodsService = GoodsService();
    List<Goods> goods =
        await goodsService.getGoodsModels(searchGoods: searchTerm);

    // 검색 결과를 콜백으로 전달
    widget.onSearchCallback(goods);
  }
}
