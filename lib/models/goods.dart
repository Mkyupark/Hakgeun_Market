import 'package:hakgeun_market/models/user.dart';

class Goods {
  String? id;
  List<String>? photoList;
  User user;
  String title;
  String? content;
  num price;
  int? likeCnt;
  int? readCnt;
  int? uploadTime;
  int? updateTime;
  String category;

  Goods(this.id, this.photoList, this.user, this.title, this.content,
      this.price, this.likeCnt, this.readCnt, this.category);
}
