import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hakgeun_market/models/goods.dart';

class GoodsService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final GoodsService _goodsService = GoodsService._internal();

  factory GoodsService() => _goodsService;

  GoodsService._internal();

  Future<void> CreateGoods(Goods goods) async {
    await _db.collection('goods').doc().set(goods.toJson());
  }

  // // READ 각각의 데이터를 콕 집어서 가져올때
  Future<Goods?> getGoodsFromUID(String goodsId) async {
    try {
      var snapshot = await _db.collection('goods').doc(goodsId).get();
      if (snapshot.exists) {
        return Goods.fromJson(snapshot);
      } else {
        return null; // 사용자를 찾을 수 없을 때 null을 반환합니다.
      }
    } catch (e) {
      // 에러 처리
      print('Error fetching user: $e');
      return null;
    }
  }

  //READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<Goods>> getGoodsModels({String searchGoods = ""}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _db.collection("goods");

    // 전부 조회
    if (searchGoods == "") {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .orderBy('uploadTime', descending: true)
              .get();
      List<Goods> goods = [];
      for (var doc in querySnapshot.docs) {
        Goods fireModel = Goods.fromQuerySnapshot(doc);
        goods.add(fireModel);
      }
      return goods;
      // 검색하는게 있을 경우
    } else {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .where('title', isGreaterThanOrEqualTo: searchGoods)
              .where('title', isLessThanOrEqualTo: '$searchGoods\uf8ff')
              .orderBy('title')
              .get();
      List<Goods> goods = [];
      for (var doc in querySnapshot.docs) {
        Goods fireModel = Goods.fromQuerySnapshot(doc);
        goods.add(fireModel);
      }
      return goods;
    }
  }

//Delete
  Future<void> delGoodsModel(String goodsid) async {
    await _db.collection('goods').doc(goodsid).delete();
  }

//Update
  Future<void> updateGoodsModel(Goods goods) async {
    await _db.collection('goods').doc(goods.id).update(goods.toJson());
  }
}
