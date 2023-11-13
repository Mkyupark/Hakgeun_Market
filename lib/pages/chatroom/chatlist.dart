import 'package:flutter/material.dart';
import 'package:hakgeun_market/pages/chatroom/chatroom.dart';


class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView.builder(
        itemCount: 5, // 더미 데이터 개수
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatRoom(
                    rname: '채팅 상대 $index',
                    rid: 'room$index',
                    uid: 'user1', // 임의의 사용자 ID
                    name: 'John', // 임의의 사용자 이름
                  ),
                ),
              );
            },
            title: Text('채팅 상대 $index'),
            subtitle: Text('Click you want watch message'),
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
