import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/chat_service.dart';
import '../data/firestore.dart';
import '../screens/chat_summary.dart';
import '../data/data.dart';
import '../utils/constants/colors.dart';
import 'chat_page.dart';
import 'chat_summary.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ChatService _chatService = ChatService();
  final Firestore _firestore = Firestore();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inDays > 0) {
      return "${timestamp.month}/${timestamp.day}";
    } else if (difference.inHours > 0) {
      return "${difference.inHours}h ago";
    } else {
      return "${difference.inMinutes}m ago";
    }
  }

  @override
  Widget build(BuildContext context) {

    print("👤 Current user: $currentUserId");
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF5F3),
        centerTitle: true,
        title: Image.asset(
          'assets/logos/MiniMates_color.png',
          height: 30,
        ),
      ),
      body: StreamBuilder<List<ChatSummary>>(
        stream: _chatService.getUserChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!;
          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final chat = chats[index];
              final partnerId = chat.getOtherUserId(currentUserId);
              if (partnerId == null) {
                return SizedBox(); // 👈 skip rendering this chat if no other user
              }
              final partnerName = chat.getOtherUserName(currentUserId);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(partnerName[0],style: TextStyle(color: TColors.primary),),
                ),
                title: Text(partnerName),
                subtitle: Text(chat.lastMessage),
                trailing: FutureBuilder<int>(
                  future: _chatService.getUnreadCount(chat.chatId, currentUserId),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print("⏳ Loading unread count...");
                      return CircularProgressIndicator(strokeWidth: 2);
                    }

                    if (snapshot.hasError) {
                      print("❌ Error: ${snapshot.error}");
                      return Icon(Icons.error, color: Colors.red);
                    }
                    final count = snapshot.data ?? 0;

                    print("🔍 Chat ID: ${chat.chatId} | Unread Count for $currentUserId: $count");

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatTimestamp(chat.lastTimestamp),
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        if (count > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),


                onTap: () async {
                  final receiverUser = await _firestore.getUserById(partnerId);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(receiverUser: receiverUser),
                    ),
                  );
                  setState(() {}); // 🔁 refresh after returning
                },
              );
            },
          );
        },
      ),
    );
  }
}