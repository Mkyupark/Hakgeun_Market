import 'package:cloud_firestore/cloud_firestore.dart';

class Goods {
  String? id;
  List<String>? photoList;
  DocumentReference? user;
  String title;
  String? content;
  String price;
  String? loc;
  String? likeCnt;
  String? readCnt;
  Timestamp? uploadTime;
  Timestamp? updateTime;
  String category;

  Goods(
      {required this.photoList,
      required this.user,
      required this.title,
      required this.content,
      required this.price,
      required this.loc,
      required this.likeCnt,
      required this.readCnt,
      required this.uploadTime,
      required this.updateTime,
      required this.category});

  // firebase에서 데이터 가져올 때
  Goods.fromJson(dynamic json)
      : id = json['id'],
        photoList = json['photoList'].cast<String>() ?? "",
        title = json['title'],
        content = json['content'],
        loc = json['location'],
        price = json['price'], // 또는 json['price'].toInt() 등으로 수정
        likeCnt = json['likeCnt'],
        readCnt = json['readCnt'],
        uploadTime = json['uploadTime'],
        updateTime = json['updateTime'],
        category = json['category'];

  // firebase에 저장할 때
  Map<String, dynamic> toJson() => {
        'photoList': photoList,
        'user': user,
        'title': title,
        'content': content,
        'price': price,
        'loc': loc,
        'likeCnt': likeCnt,
        'readCnt': readCnt,
        'uploadTime': uploadTime,
        'updateTime': updateTime,
        'category': category,
      };
  Goods.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  Goods.fromQuerySnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data());

  factory Goods.fromDocumentSnapshot(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Goods(
        user: doc['user'],
        photoList: doc['photoList'].cast<String>(),
        title: doc['title'],
        content: doc['content'],
        price: doc['price'], // 또는 json['price'].toInt() 등으로 수정
        loc: doc['loc'],
        likeCnt: doc['likeCnt'],
        readCnt: doc['readCnt'],
        uploadTime: doc['uploadTime'],
        updateTime: doc['updateTime'],
        category: doc['category']);
  }
}
