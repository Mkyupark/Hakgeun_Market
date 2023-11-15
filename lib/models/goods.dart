import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakgeun_market/models/user.dart';

class Goods {
  String? id;
  List<String>? photoList;
  User? user;
  String title;
  String? content;
  String price;
  String? likeCnt;
  String? readCnt;
  Timestamp? uploadTime;
  Timestamp? updateTime;
  String category;

  Goods(this.id, this.photoList, this.user, this.title, this.content,
      this.price, this.likeCnt, this.readCnt, this.category);
  // Goods(
  //     {required this.id,
  //     required this.photoList,
  //     required this.user,
  //     required this.title,
  //     required this.content,
  //     required this.price,
  //     required this.likeCnt,
  //     required this.readCnt,
  //     this.uploadTime,
  //     this.updateTime,
  //     required this.category});

  Goods.fromJson(dynamic json)
      : id = json['id'],
        photoList = json['photoList'].cast<String>(),
        title = json['title'],
        content = json['content'],
        price = json['price'], // 또는 json['price'].toInt() 등으로 수정
        likeCnt = json['likeCnt'],
        readCnt = json['readCnt'],
        uploadTime = json['uploadTime'],
        updateTime = json['updateTime'],
        category = json['category'];

  // firebase에 저장할 때
  Map<String, dynamic> toJson() => {
        'photoList': photoList,
        'title': title,
        'content': content,
        'price': price,
        'likeCnt': likeCnt,
        'readCnt': readCnt,
        'category': category,
      };
  Goods.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Goods.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  // factory Goods.fromDocumentSnapshot(DocumentSnapshot doc) {
  //   return Goods(
  //       id: doc.id,
  //       user: doc['user'],
  //       photoList: doc['photoList'].cast<String>(),
  //       title: doc['title'],
  //       content: doc['content'],
  //       price: doc['price'], // 또는 json['price'].toInt() 등으로 수정
  //       likeCnt: doc['likeCnt'],
  //       readCnt: doc['readCnt'],
  //       uploadTime: doc['uploadTime'],
  //       updateTime: doc['updateTime'],
  //       category: doc['category']);
  // }
}
