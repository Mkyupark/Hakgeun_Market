// import 'package:app/pages/my_carrot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hakgeun_market/componenets/appbar.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/pages/MyPage/profile_screen.dart';
import 'package:hakgeun_market/pages/chatroom/chatlist.dart';
import 'package:hakgeun_market/pages/Goods/home.dart';
import 'package:hakgeun_market/provider/navigation_provider.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/service/userService.dart';
import 'package:provider/provider.dart';

// react -> Router 와 같은 개념, 페이지 이동을 위함 (Navigation)
class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late NavigationProvider _navigationBar;
  int num = 0;
  List<Goods>? searchData;

  Future<Widget> _bodyWidget() async {
    switch (_navigationBar.currentNavigationIndex) {
      case 0:
        return Home(SearchData: searchData ?? []);
      case 1:
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;
        if (user == null) {
          // Handle the null user case
          return Center(child: Text('User not found!'));
        }
        List<String>? likeList = await UserService().getUserLikeList(user.id);
        if (likeList == null || likeList.isEmpty) {
          // Handle the case where likeList is null or empty
          return Center(child: Text('No liked goods found'));
        }

        List<Goods> likedGoods = [];
        for (String id in likeList) {
          try {
            Goods goods = await GoodsService().FindGoodsById(id);
            likedGoods.add(goods);
          } catch (e) {
            print('Error fetching goods with id $id: $e');
            // Optionally handle the error or ignore this specific item
          }
        }

        return Home(SearchData: likedGoods);

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
              label: '관심목록'),
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
            searchData = searchTerm; // searchData 업데이트
          });
        },
        num: _navigationBar.currentNavigationIndex,
      ),
      body: FutureBuilder<Widget>(
        future: _bodyWidget(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // You can show a loading spinner here
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle the error state
            return Center(child: Text('An error occurred!'));
          } else {
            // Return the widget that _bodyWidget() returns
            return snapshot.data ??
                Container(); // Fallback to an empty container
          }
        },
      ),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
