import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/message.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //store/retrieve data
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendMessage(String receiverId, String content) async {
    final senderId = _auth.currentUser!.uid;
    final timestamp = Timestamp.now();
    Message message = new Message(
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
    );
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    await _firestore.collection('chats').doc(chatId).collection('messages').add(message.toMap());
  }

  Stream<QuerySnapshot> getMessages(String receiverId) {
    final senderId = _auth.currentUser!.uid;
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    return _firestore.collection('chats').doc(chatId).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }
}
