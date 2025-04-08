import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String title;
  String image;
  String description;
  List<String> tags;
  DateTime timestamp;
  double? latitude;
  double? longitude;

  String userId;
  DateTime? startTime;
  DateTime? endTime;
  String? address;

  Post({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.tags,
    required this.timestamp,
    required this.userId,
    this.startTime,
    this.endTime,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,
      title: data['title'] ?? "No Title",
      image: data['image'] ?? "",
      description: data['description'] ?? "No Description",
      tags: List<String>.from(data['tags'] ?? []),
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      userId: data['user_id'] ?? "Unknown User",
      startTime: data['start_time'] != null && data['start_time'] is Timestamp
          ? (data['start_time'] as Timestamp).toDate()
          : null,
      endTime: data['end_time'] != null && data['end_time'] is Timestamp
          ? (data['end_time'] as Timestamp).toDate()
          : null,
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
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

class AppUser {
  String userName;
  String? profilePicture;
  String id;
  int? age;
  String? gender;
  String? city;
  List<String>? preferences;

  AppUser({
    required this.id,
    required this.userName,
    required this.profilePicture,
    this.age,
    this.gender,
    this.city,
    this.preferences,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AppUser(
      id: doc.id,
      userName: data['userName'] ?? "No Title",
      profilePicture: data['profilePicture'] ?? null,
      age: data['age'] != null ? int.tryParse(data['age'].toString()) : null,
      gender: data['gender'] ?? "Unknown",
      city: data['city'] ?? "Unknown",
      preferences: data['preferences'] != null
          ? List<String>.from(data['preferences'])
          : [],
    );
  }
}