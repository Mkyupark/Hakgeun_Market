import 'package:cloud_firestore/cloud_firestore.dart';

class Goods {
  String? id;
  List<String>? photoList;
  String? saler;
  String? buyer;
  String title;
  String? content;
  String price;
  String? loc;
  String? likeCnt;
  String? chatCnt;
  Timestamp? uploadTime;
  Timestamp? updateTime;
  String category;

  Goods(
      {required this.id,
      required this.photoList,
      required this.saler,
      required this.buyer,
      required this.title,
      required this.content,
      required this.price,
      required this.loc,
      required this.likeCnt,
      required this.chatCnt,
      required this.uploadTime,
      required this.updateTime,
      required this.category});

  // firebase에서 데이터 가져올 때
  Goods.fromJson(dynamic json)
      : id = json['id'],
        photoList = json['photoList'].cast<String>() ?? "",
        saler = json['saler'],
        buyer = json['buyer'],
        title = json['title'],
        content = json['content'],
        loc = json['location'],
        price = json['price'], // 또는 json['price'].toInt() 등으로 수정
        likeCnt = json['likeCnt'],
        chatCnt = json['chatCnt'],
        uploadTime = json['uploadTime'],
        updateTime = json['updateTime'],
        category = json['category'];

  // firebase에 저장할 때
  Map<String, dynamic> toJson() => {
        'id': id,
        'photoList': photoList,
        'buyer': buyer,
        'saler': saler,
        'title': title,
        'content': content,
        'price': price,
        'loc': loc,
        'likeCnt': likeCnt,
        'chatCnt': chatCnt,
        'uploadTime': uploadTime,
        'updateTime': updateTime,
        'category': category,
      };
  Goods.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Goods.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  factory Goods.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Goods(
        id: doc['id'],
        photoList: doc['photoList'].cast<String>(),
        saler: doc['saler'],
        buyer: doc['buyer'],
        title: doc['title'],
        content: doc['content'],
        price: doc['price'], // 또는 json['price'].toInt() 등으로 수정
        loc: doc['loc'],
        likeCnt: doc['likeCnt'],
        chatCnt: doc['chatcnt'],
        uploadTime: doc['uploadTime'],
        updateTime: doc['updateTime'],
        category: doc['category']);
  }
}
