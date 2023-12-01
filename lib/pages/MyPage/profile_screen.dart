// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/models/user.dart';
import 'package:hakgeun_market/pages/AuthPage/login_screen.dart';
import 'package:hakgeun_market/pages/AuthPage/regist_screen.dart';
import 'package:hakgeun_market/pages/Goods/home.dart';
import 'package:hakgeun_market/provider/navigation_provider.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/service/goodsService.dart';
import 'package:hakgeun_market/service/userService.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    final user = userProvider.user;
    List<Goods>? searchData;
    final GoodsService goodsService = GoodsService();
    if (user != null) {
      return Scaffold(
        body: ListView(
          children: <Widget>[
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.account_circle, size: 50),
              title: Text(user.nickName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${user.schoolName} #${user.phoneNum}'),
                ],
              ),
            ),
            const Divider(),
            _buildMannerTemperature(context, user.mannerTemperature),
            const Divider(),
            _buildButton(context, Icons.list, '판매목록', Colors.green, () async {
              // Filter goods for Sales List
              List<Goods> salesList =
                  await goodsService.getFilterSaleGoods(user.nickName);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(
                    SearchData: salesList,
                  ),
                ),
              );
            }),
            _buildButton(context, Icons.shopping_cart, '구매목록', Colors.green,
                () async {
              List<Goods> buyList =
                  await goodsService.getFilterBuyGoods(user.nickName);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(
                    SearchData: buyList,
                  ),
                ),
              );
            }),
            const Divider(),
            _buildButton(context, Icons.edit, '회원 정보 수정', null, () {
              // Navigator push to 회원 정보 수정 screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegistScreen(
                          phoneNumber: user.phoneNum,
                        )),
              );
            }),
            _buildButton(context, Icons.exit_to_app, '회원 탈퇴', null, () {
              _showDialog(context, '회원 탈퇴하시겠습니까?', () async {
                // 회원 탈퇴 로직
                var userService = UserService();

                await userService.deleteUser(user.id);
                userProvider.setUser(null); // 현재 사용자 ID에 해당하는 사용자 삭제
              });
            }),
            _buildButton(context, Icons.logout, '로그아웃', null, () {
              _showDialog(context, '로그아웃하시겠습니까?', () async {
                // 로그아웃 로직
                var userProvider = UserProvider();
                userProvider.setUser(null); // 사용자 정보 제거
              });
            }),
            const Divider(),
            _buildExpansionTile(
              title: '이용안내',
              content: '학근마켓은 학교내에서 중고물품을 판매하는 기능을 제공합니다.',
            ),
            _buildExpansionTile(
                title: '개인정보 처리방침',
                content:
                    ' 학근마켓은 사용자의 개인정보를 보호하고 사용자에게 안전하고 효과적인 서비스를 제공하기 위해 최선을 다하고 있습니다.\n 본 개인정보 처리방침은 학근마켓이 어떻게 사용자의 정보를 수집, 사용, 공유하는지에 대한 중요한 정보를 담고 있습니다.\n\n'
                    '1. 수집하는 개인정보의 항목 및 수집 방법\n'
                    ' - 학근마켓은 서비스 제공을 위해 이메일, 성별, 생년월일, 로그인 ID 등의 정보를 수집합니다.\n 이 정보는 주로 카카오 로그인을 통해 수집됩니다.\n\n'
                    '2. 개인정보의 이용 목적\n'
                    ' - 수집된 정보는 서비스 제공, 사용자 관리, 신규 기능 개발 및 개선, 안전한 서비스 이용 환경 조성 등을 위해 사용됩니다.\n\n'
                    '3. 개인정보의 보유 및 이용 기간\n'
                    ' - 사용자의 정보는 서비스 이용 기간 동안 보유하며, 법적인 요구가 있는 경우를 제외하고는 이용자의 요청에 따라 삭제됩니다.\n\n'
                    '4. 개인정보의 파기 절차 및 방법\n'
                    ' - 사용자의 개인정보는 목적 달성 후 별도의 DB로 옮겨져 일정 기간 저장된 후 파기됩니다.\n'
                    ' - 전자적 파일 형태로 저장된 개인정보는 기술적 방법을 사용하여 복구 및 재생이 불가능하도록 안전하게 삭제됩니다.\n\n'
                    '5. 개인정보 보호를 위한 기술적, 관리적 대책\n'
                    ' - 학근마켓은 사용자의 개인정보 보호를 위해 보안 시스템을 갖추고 있으며, 정기적인 점검을 통해 안전을 유지하고 있습니다.\n'
                    ' - 사용자의 개인정보에 접근할 수 있는 인원을 최소한으로 제한하며, 이를 위반할 시 엄격한 처벌을 받을 수 있습니다.\n\n'
                    '본 개인정보 처리방침은 법률 및 정책의 변경에 따라 변경될 수 있으며, 변경 시 사용자에게 적절한 방법으로 통지할 것입니다.\n'),
            _DeveloperExpansionTile(),
          ],
        ),
      );
    } else {
      return Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('로그인 하여 학근마켓을 이용해주세요',
                  style: TextStyle(fontSize: 18.0)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('로그인'),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF2DB400),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _DeveloperExpansionTile() {
    return ExpansionTile(
      title: const Text('개발자 정보'),
      children: <Widget>[
        _buildDeveloperInfo('손승재', '20190613', '회원가입, 내정보 Screen 구현'),
        _buildDeveloperInfo('우민식', '20200723', 'Firebase 채팅 기능 구현'),
        _buildDeveloperInfo('양준석', '20200694', '상품 상세 정보 Screen 구현'),
        _buildDeveloperInfo('박민규', '20170426', '상품 리스트 Screen 구현'),
      ],
    );
  }

  Widget _buildDeveloperInfo(String name, String id, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text('$name $id',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(role),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({required String title, required String content}) {
    return ExpansionTile(
      title: Text(title),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label,
      Color? color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 30, color: color),
      title: Text(label),
      onTap: onTap,
    );
  }

  Widget _buildMannerTemperature(BuildContext context, double temperature) {
    Color color;
    String emoji;

    if (temperature < 35) {
      color = Colors.blue;
      emoji = '😊'; // Emoji for lower temperatures
    } else if (temperature < 37) {
      color = Colors.green;
      emoji = '😐'; // Emoji for moderate temperatures
    } else {
      color = Colors.red;
      emoji = '😷'; // Emoji for higher temperatures
    }

    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("학근 점수"),
              const SizedBox(
                  width:
                      8.0), // Adjust the spacing between title and temperature
              Text('${temperature.toStringAsFixed(1)}°C'),
              const SizedBox(
                  width:
                      8.0), // Adjust the spacing between temperature and emoji
              Text(emoji),
            ],
          ),
          GestureDetector(
            onTap: () {
              _showMannerTemperatureInfo(context);
            },
            child: const Icon(Icons.info_outline,
                color: Colors.blue), // Adjust the color as needed
          ),
        ],
      ),
      subtitle: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: temperature / 100,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Colors.grey[300],
        ),
      ),
    );
  }

  void _showMannerTemperatureInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('학근점수란?'),
          content: const Text(
              '학근점수는 사용자의 활동에 기반한 평판 점수입니다.\n긍정적인 활동으로 학점이 상승하며, 부정적인 행동으로 하락합니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(
      BuildContext context, String content, Future<Null> Function() param2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                param2();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
