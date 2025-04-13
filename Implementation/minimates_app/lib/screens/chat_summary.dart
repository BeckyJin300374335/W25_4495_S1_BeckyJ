import 'package:cloud_firestore/cloud_firestore.dart';

class ChatSummary {
  final String chatId;
  final List<String> participants;
  final Map<String, dynamic> userNames;
  final String lastMessage;
  final DateTime lastTimestamp;

  ChatSummary({
    required this.chatId,
    required this.participants,
    required this.userNames,
    required this.lastMessage,
    required this.lastTimestamp,
  });

  //Factory Constructor from Firestore, convert a Firestore document into a ChatSummary object.
  factory ChatSummary.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatSummary(
      chatId: doc.id,
      participants: List<String>.from(data['participants'] ?? []),
      userNames: Map<String, dynamic>.from(data['userNames'] ?? {}),
      lastMessage: data['lastMessage'] ?? '',
      lastTimestamp: (data['lastTimestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  String? getOtherUserId(String currentUserId) {
    try {
      return participants.firstWhere((id) => id != currentUserId);
    } catch (e) {
      return null; // return null if no match is found
    }
  }

  String getOtherUserName(String currentUserId) {
    return userNames[getOtherUserId(currentUserId)] ?? "Unknown";
  }
}
