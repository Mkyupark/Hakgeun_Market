import 'package:hakgeun_market/models/goods.dart';
import 'package:hakgeun_market/models/user.dart';

// 더미 데이터
List<User> dummyData_Users = [
  User('1', '010-1111-2222', '1111@gmail.com', '1111'),
  User('2', '010-2222-2222', '2222@gmail.com', '2222'),
];

List<String> dummyPhotoList1 = [
  'assets/images/sample1.jpg',
  'assets/images/sample2.jpg',
];

List<String> dummyPhotoList2 = [
  'assets/images/sample3.jpg',
  'assets/images/sample4.jpg',
];
List<String> dummyPhotoList3 = [
  'assets/images/sample5.jpg',
  'assets/images/sample6.jpg',
];
List<Goods> dummyData_Goods = [
  Goods(
    '1',
    dummyPhotoList1,
    dummyData_Users[0],
    '상품1',
    '구매해주세요',
    100000,
    10,
    63,
    '식기',
  ),
  Goods(
    '2',
    dummyPhotoList2,
    dummyData_Users[1],
    '상품2',
    '구매해주3',
    213120,
    30,
    23,
    '>_<',
  ),
  Goods(
    '3',
    dummyPhotoList3,
    dummyData_Users[1],
    '상품3',
    '구매해',
    43212310,
    10,
    23,
    '>_<',
  ),
];
