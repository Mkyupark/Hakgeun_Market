import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/componenets/appbar.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/Goods/home.dart';
import 'package:hakgeun_market/pages/MyPage/profile_screen.dart';
import 'package:hakgeun_market/pages/chatroom/chatlist.dart';
import 'package:hakgeun_market/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class DetailToHome extends StatefulWidget {
  final List<Goods> SearchData;

  const DetailToHome({super.key, required this.SearchData});

  @override
  State<DetailToHome> createState() => _DetailToHomeState();
}

class _DetailToHomeState extends State<DetailToHome> {
  late NavigationProvider _navigationBar;
  late List<Goods> goodsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goodsList = widget.SearchData;
  }

  Widget _bodyWidget() {
    switch (_navigationBar.currentNavigationIndex) {
      case 0:
        return Home(SearchData: goodsList);
      case 1:
        return Container();
      case 2:
        return ChatList();
      case 3:
        return const ProfileScreen();
    }
    return Container();
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          _navigationBar.updatePage(index);
        },
        currentIndex: _navigationBar.currentNavigationIndex,
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/home-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/home.svg',
                width: 30,
              ),
              label: '홈'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/text-box-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/text-box.svg',
                width: 30,
              ),
              label: '게시판?'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/chat-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/chat.svg',
                width: 30,
              ),
              label: '채팅'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/svg/account-outline.svg',
                width: 30,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svg/account.svg',
                width: 30,
              ),
              label: '내정보')
        ]);
  }

  @override
  Widget build(BuildContext context) {
    _navigationBar = Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(
        onSearchCallback: (searchTerm) {
          setState(() {
            goodsList = searchTerm; // searchData 업데이트
          });
        },
      ),
      body: Home(
        SearchData: widget.SearchData,
      ),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
