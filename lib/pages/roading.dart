// import 'package:flutter/material.dart';
// import 'package:hakgeun_market/models/goods.dart';
// import 'package:hakgeun_market/service/goodsService.dart';

// class GoodsListScreen extends StatelessWidget {
//   final GoodsService goodsService = GoodsService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Goods List'),
//       ),
//       body: FutureBuilder<List<Goods>>(
//         // 비동기 함수 호출
//         future: goodsService.getFireModels(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // 데이터 로딩 중일 때 보여줄 UI
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             // 에러가 발생한 경우 보여줄 UI
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 style: TextStyle(color: Colors.red),
//               ),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             // 데이터가 없는 경우 보여줄 UI
//             return Center(
//               child: Text(
//                 'No data available',
//                 style: TextStyle(fontStyle: FontStyle.italic),
//               ),
//             );
//           } else {
//             // 데이터가 있는 경우 보여줄 UI
//             List<Goods> goodsList = snapshot.data!;
//             return ListView.builder(
//               itemCount: goodsList.length,
//               itemBuilder: (context, index) {
//                 Goods goods = goodsList[index];
//                 return ListTile(
//                   title: Text(goods.title),
//                   subtitle: Text(
//                     goods.price != null
//                         ? 'Price: ${goods.price}'
//                         : 'Free Giveaway',
//                   ),
//                   // 필요에 따라 추가적인 UI 구성 요소를 추가하세요.
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: GoodsListScreen(),
//   ));
// }
