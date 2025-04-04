import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../data/chat_service.dart';
import '../data/data.dart';
import '../utils/constants/sizes.dart';
import '../utils/constants/colors.dart';

class ChatPage extends StatefulWidget {
  final AppUser receiverUser;
  const ChatPage({super.key, required this.receiverUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverUser.id,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    markMessagesAsRead(); // ✅ mark all as read when opening
  }
  void markMessagesAsRead() async {
    print('📩 Marking messages as read...');
    await _chatService.markMessagesAsRead(widget.receiverUser.id);
    print('✅ Messages marked as read');
  }



  String _getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Row(
          children: [

            SizedBox(width: 10),
            Text(
              widget.receiverUser.userName,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUser.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
        }

        final messages = snapshot.data!.docs;
        messages.sort((a, b) {
          final aTime = a['timestamp'] as Timestamp?;
          final bTime = b['timestamp'] as Timestamp?;
          return (aTime?.toDate() ?? DateTime.now())
              .compareTo(bTime?.toDate() ?? DateTime.now());
        });

        return ListView(
          padding: EdgeInsets.all(12),
          children: messages.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
    documentSnapshot.data() as Map<String, dynamic>;
    final isSender = data['senderId'] == _auth.currentUser!.uid;
    final alignment = isSender ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isSender ? Color(0xFFF9AFA6) : Colors.grey.shade300;
    final textColor = isSender ? Colors.white : Colors.black87;

    return Align(
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(isSender ? 16 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 16),
          ),
        ),
        child: Text(
          data['content'],
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Neumorphic(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              style: NeumorphicStyle(
                depth: -3,
                boxShape:
                NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8),
          NeumorphicButton(
            onPressed: sendMessage,
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              boxShape:
              NeumorphicBoxShape.circle(),
              color: Color(0xFFF9AFA6),
            ),
            padding: EdgeInsets.all(14),
            child: Icon(Icons.send, color: Colors.white, size: 20),
          )
        ],
      ),
    );
  }
}