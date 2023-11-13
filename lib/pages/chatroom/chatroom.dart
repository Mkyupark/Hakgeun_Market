import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key, required this.rname, required this.rid, required this.uid, required this.name});

  final String rname;
  final String rid;
  final String uid;
  final String name;

  @override
  _ChatRoomState createState() => _ChatRoomState(rname, rid, uid, name);
}

List<Map<String, dynamic>> dummyChatMessages = [
    
];

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState(this.rname, this.rid, this.uid, this.name);

  final String rname;
  final String rid;
  final String uid;
  final String name;

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rname),
        backgroundColor: Colors.green, // Set the app bar color to green
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white, // Set the chat area background color to white
              child: ListView.builder(
                reverse: true,
                itemCount: dummyChatMessages.length,
                itemBuilder: (context, index) {
                  final chat = dummyChatMessages[index];
                  final isMyMessage = chat['uid'] == uid;

                  return ListTile(
                    title: Align(
                      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        chat['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMyMessage ? Colors.green : Colors.green,
                        ),
                      ),
                    ),
                    subtitle: Align(
                      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        chat['txt'],
                        style: TextStyle(color: isMyMessage ? Colors.green : Colors.green),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(thickness: 2.5, height: 2.5, color: Colors.white),
        Container(
  decoration: BoxDecoration(
    color: Colors.white, // Set the input area background color to white
    borderRadius: BorderRadius.circular(10), // Set border radius for rounded corners
    border: Border.all(color: Colors.green), // Set the border color to green
  ),
  constraints: BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height * 0.3, // Adjust the chat input area size
  ),
  margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
  child: Row(
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: TextField(
            controller: _controller,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 20, color: Colors.green), // Set text color to green
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "메세지 입력창",
              hintStyle: TextStyle(color: Colors.green), // Set hint text color to green
            ),
          ),
        ),
      ),
      
GestureDetector(
  onTap: () async {
    var txt = _controller.text.trim(); // Trim the message to remove leading and trailing whitespaces
    if (txt.isNotEmpty) {
      var now = DateTime.now().millisecondsSinceEpoch;
      _controller.clear();
      dummyChatMessages.insert(0, {'uid': uid, 'name': name, 'txt': txt, 'timestamp': now});
      setState(() {});
    }
  },
  child: Padding(
    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    child: Icon(
      Icons.send,
      size: 33,
      color: Colors.green,
    ),
  ),
)

    ],
  ),
)
        ],
      ),
    );
  }
}
