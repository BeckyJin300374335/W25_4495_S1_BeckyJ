import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/message.dart';
import '../screens/chat_summary.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //store/retrieve data
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<ChatSummary>> getUserChats() {
    final currentUserId = _auth.currentUser!.uid;

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: currentUserId)
        .orderBy('lastTimestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatSummary.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverId, String message) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final currentUserId = currentUser.uid;
    final chatId = _getChatId(currentUserId, receiverId);

    final messageData = {
      'senderId': currentUserId,
      'content': message,
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [currentUserId],
    };

    // 1. Send the message
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // 2. Fetch usernames
    final currentUserSnap = await _firestore.collection('users').doc(currentUserId).get();
    final receiverSnap = await _firestore.collection('users').doc(receiverId).get();
    final currentUserName = currentUserSnap['userName'] ?? 'Unknown';
    final receiverUserName = receiverSnap['userName'] ?? 'Unknown';

    // 3. Create or update the main chat doc
    await _firestore.collection('chats').doc(chatId).set({
      'participants': [currentUserId, receiverId],
      'userNames': {
        currentUserId: currentUserName,
        receiverId: receiverUserName,
      },
      'lastMessage': message,
      'lastTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _getChatId(String user1, String user2) {
    final sorted = [user1, user2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<int> getUnreadCount(String chatId, String userId) async {
    final snapshot = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .get();

    final unreadMessages = snapshot.docs.where((doc) {
      final data = doc.data();
      final senderId = data['senderId'];
      final readBy = List<String>.from(data['readBy'] ?? []);

      // Show unread if: user hasn't read and it's not their own message
      return senderId != userId && !readBy.contains(userId);
    }).toList();

    return unreadMessages.length;
  }


  Future<void> markMessagesAsRead(String receiverId) async {
    final currentUserId = _auth.currentUser!.uid;
    final chatId = _getChatId(currentUserId, receiverId);

    final unreadMessages = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('senderId', isEqualTo: receiverId)
        .get();

    for (var doc in unreadMessages.docs) {
      final data = doc.data();
      // ✅ Check if 'readBy' exists
      final readBy = data.containsKey('readBy')
          ? List<String>.from(data['readBy'])
          : [];

      if (!readBy.contains(currentUserId)) {
        await doc.reference.update({
          'readBy': FieldValue.arrayUnion([currentUserId]),
        });
      }
    }
  }




  Stream<QuerySnapshot> getMessages(String receiverId) {
    final senderId = _auth.currentUser!.uid;
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }
}
