import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key, required this.rname, required this.uid1, required this.uid2, required String rid, required String uid, required String name});

  final String rname;
  final String uid1;
  final String uid2;

  @override
  _ChatRoomState createState() => _ChatRoomState(rname, uid1, uid2);
}

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState(this.rname, this.uid1, this.uid2);

  final String rname;
  final String uid1;
  final String uid2;

  final TextEditingController _controller = TextEditingController();
  late CollectionReference<Map<String, dynamic>> messages;
  late ScrollController _scrollController;

  @override
  void initState() {
    
    super.initState();

    _scrollController = ScrollController();
    messages = FirebaseFirestore.instance.collection('chatRooms').doc(rname).collection('messages');

    // Load messages and scroll to the bottom when done
    messages.orderBy('timestamp').get().then((querySnapshot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      

      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rname),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: messages.orderBy('timestamp').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  
                  List<Map<String, dynamic>> chatMessages = snapshot.data!.docs
                      .map((DocumentSnapshot<Map<String, dynamic>> document) => document.data()!)
                      .toList();

                  return ListView.builder(
                    controller: _scrollController,
                    reverse: false,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      final chat = chatMessages[index];
                      final isMyMessage = chat['uid'] == uid1;
                    
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isMyMessage ? Colors.green : Colors.blueGrey,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
  chat['uid'],
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),
const SizedBox(height: 4.0),
Container(
  constraints: BoxConstraints(
    maxWidth: MediaQuery.of(context).size.width * 0.7, // Adjust the maximum width as needed
  ),
  child: Text(
    chat['chatlog'],
    style: const TextStyle(color: Colors.white),
    softWrap: true, // Set softWrap to true for automatic text wrapping
  ),
),

const SizedBox(height: 4.0),
Text(
  _formatTimestamp(chat['timestamp']),
  style: const TextStyle(
    fontSize: 10.0,
    color: Colors.white70,
  ),
),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const Divider(thickness: 2.5, height: 2.5, color: Colors.white),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
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
                      style: const TextStyle(fontSize: 20, color: Colors.green),
                      textInputAction: TextInputAction.newline,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "메세지 입력창",
                        hintStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var txt = _controller.text.trim();
                    if (txt.isNotEmpty) {
                      var now = DateTime.now().millisecondsSinceEpoch;

                      await messages.add({
                        'uid': uid1,
                        'chatlog': txt,
                        'timestamp': now,
                      });

                      _controller.clear();
                      _scrollToBottom();
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: Icon(
                      Icons.send,
                      size: 33,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${dateTime.hour}:${dateTime.minute}';
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds:150),
      curve: Curves.easeOut,
    );
  }
}
