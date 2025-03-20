import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String title;
  String image;
  String description;
  List<String> tags;
  DateTime timestamp;
  String userId;

  Post({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.tags,
    required this.timestamp,
    required this.userId,
  });

  // Factory constructor to convert Firestore DocumentSnapshot into a Post object
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,
      title: data['title'] ?? "No Title",
      image: data['image'] ?? "", // Handle missing image case
      description: data['description'] ?? "No Description",
      tags: List<String>.from(data['tags'] ?? []), // Ensure 'tags' is a list of strings
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate() // Convert Firestore Timestamp to DateTime
          : DateTime.now(), // Fallback to current time if no timestamp exists
      userId: data['user_id'] ?? "Unknown User",
    );
  }
}

class Tag {
  String name;
  Tag(this.name);
}

class UserPostRelation {
  String user_id;
  String post_id;
  bool is_going;
  UserPostRelation(this.user_id, this.post_id, this.is_going);
}

// {'userName': name, 'email': email, 'password': password, 'profilePicture': url, 'age': age, 'gender': gender, 'city': city}

class AppUser {
  String userName;
  String? profilePicture;
  String id;


  AppUser({
    required this.id,
    required this.userName,
    required this.profilePicture,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      id: doc.id,
      userName: data['userName'] ?? "No Title",
      profilePicture: data['profilePicture'] ?? null,
    );
  }
}