import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakgeun_market/models/goods.dart';

class GoodsService {
  static final GoodsService _goodsService = GoodsService._internal();

  factory GoodsService() => _goodsService;

  GoodsService._internal();

  // Create
  Future createNewGoods(Map<String, dynamic> json) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("goods").doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  // READ 각각의 데이터를 콕 집어서 가져올때
  Future<Goods> getGoodsModel() async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection("goods").doc();
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await documentReference.get();
    Goods goods = Goods.fromSnapShot(documentSnapshot);
    return goods;
  }

  //READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<Goods>> getGoodsModels() async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        FirebaseFirestore.instance.collection("goods");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.orderBy('uploadTime', descending: true).get();

    List<Goods> goods = [];
    for (var doc in querySnapshot.docs) {
      Goods fireModel = Goods.fromQuerySnapshot(doc);
      goods.add(fireModel);
    }
    return goods;
  }
// //Delete
//   Future<void> delGoodsModel(DocumentReference reference) async {
//     await reference.delete();
//   }

// //Update
//   Future<void> updateGoodsModel(Map<String, dynamic> json,DocumentReference reference) async {
//     await reference.set(json);
//   }
}
