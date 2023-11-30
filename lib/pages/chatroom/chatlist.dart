import 'package:hakgeun_market/pages/chatroom/chatroom.dart';
import 'package:hakgeun_market/provider/user_provider.dart';
import 'package:hakgeun_market/models/user.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends StatefulWidget {
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final UserProvider _userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chatRooms').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('채팅방이 없습니다.'),
            );
          }

          List<DocumentSnapshot> rooms = snapshot.data!.docs;
          UserModel? currentUser = _userProvider.user;

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              String rname = rooms[index]['rname'];
              String uid1 = rooms[index]['uid1'];
              String uid2 = rooms[index]['uid2'];
              String id=rooms[index]['id'];
              
              
              if (currentUser != null && rname.contains(currentUser.nickName)) {
                if (uid1 == currentUser.nickName) {
                  return ListTile(
                    title: Text('대화 상대: $uid2'),
                 
                    onTap: () {
                      // TODO: 채팅방 클릭 시 동작 정의
                     Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    rname: rooms[index]['rname'],
                    uid1: rooms[index]['uid1'],
                    uid2: rooms[index]['uid2'],
                    id:id,
                  ),),);
                    },
                  );
                } else {
                  return ListTile(
                    title: Text('대화 상대: $uid1'),
                    
                    onTap: () {
                      // TODO: 채팅방 클릭 시 동작 정의
                           Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    rname: rooms[index]['rname'],
                    uid1: rooms[index]['uid2'],
                    uid2: rooms[index]['uid1'],
                    id:id,
                  ),),);
              
                    },
                  );
                }
              } else {
                // 해당 사용자에게 속하지 않는 채팅방은 표시하지 않음
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}