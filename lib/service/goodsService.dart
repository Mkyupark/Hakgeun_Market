// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:typed_data';

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

  Future<List<Goods>> getGoodsModelsByCategory(String category) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _db.collection("goods");
    if (category == "전체") {
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
    }
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.where('category', isEqualTo: category).get();
    List<Goods> goods = [];
    for (var doc in querySnapshot.docs) {
      Goods fireModel = Goods.fromQuerySnapshot(doc);
      goods.add(fireModel);
    }
    return goods;
  }

  //READ 컬렉션 내 모든 데이터를 가져올때
  Future<List<Goods>> getGoodsModels(
      {String searchGoods = "", String category = "전체"}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _db.collection("goods");

    // 전부 조회
    if (category == "전체") {
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
    } else {
      if (searchGoods == "") {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await collectionReference
                .where('category', isEqualTo: category)
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
  }

//Delete
  Future<void> delGoodsModel(String goodsid) async {
    QuerySnapshot querySnapshot =
        await _db.collection('goods').where('id', isEqualTo: goodsid).get();
    print(querySnapshot.docs);
    // 찾은 문서를 삭제
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await _db.collection('goods').doc(doc.id).delete();
    }
    // await _db.collection('goods').doc(goodsid).delete();
  }

  // id값으로 Goods 모델 찾기 함수
  Future<Goods> FindGoodsById(String id) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection('goods').where('id', isEqualTo: id).get();

    print("querySnapshot");
    print(querySnapshot.docs.first.exists);
    Goods fireModel = Goods.fromDocumentSnapshot(querySnapshot.docs.first);
    return fireModel;
  }

//Update
  Future<void> updateGoodsModel(Goods goods) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _db.collection('goods').where('id', isEqualTo: goods.id).get();
    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          querySnapshot.docs.first;
      String documentID = documentSnapshot.id;
      await _db.collection('goods').doc(documentID).update(goods.toJson());
      print("업데이트 완료");
    } else {
      print("id: ${querySnapshot.docs.first.id} title: ${goods.title}");
      // print(querySnapshot.docs.first);
      // print("데이터 없음");
    }
  }

  // 판매자 == 유저
  Future<List<Goods>> getFilterSaleGoods(String filterNickname) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _db.collection("goods");

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();
    List<Goods> goods = [];

    for (var doc in querySnapshot.docs) {
      Goods fireModel = Goods.fromQuerySnapshot(doc);

      // Check if the filterNickname matches either saleNickname or purchaseNickName
      if (fireModel.saler == filterNickname ||
          fireModel.saler == filterNickname) {
        goods.add(fireModel);
      }
    }

    return goods;
  }

  Future<List<Goods>> getFilterBuyGoods(String filterNickname) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
        _db.collection("goods");

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await collectionReference.get();
    List<Goods> goods = [];

    for (var doc in querySnapshot.docs) {
      Goods fireModel = Goods.fromQuerySnapshot(doc);

      // Check if the filterNickname matches either saleNickname or purchaseNickName
      if (fireModel.buyer == filterNickname ||
          fireModel.buyer == filterNickname) {
        goods.add(fireModel);
      }
    }

    return goods;
  }

  Uint8List base64StringToImage(String base64String) {
    return base64Decode(base64String);
  }

  String? imageToBase64(Uint8List? image) {
    if (image != null) {
      return base64Encode(image);
    }
    return null;
  }
}
