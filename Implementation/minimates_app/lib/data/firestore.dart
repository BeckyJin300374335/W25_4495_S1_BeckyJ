import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/data/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Firestore {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; //store/retrieve data
  final FirebaseAuth _auth =
      FirebaseAuth.instance; //get the currently logged-in user

  Future<bool> createUser(String userName, String email) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid,"userName": userName, "email": email});
      return true;
    } catch (e) {
      return false;
    }
  }



  Future<Post> getPostByID(String postID) async {
    final snapshot = await _firestore.collection('posts').doc(postID).get();
    return Post.fromFirestore(snapshot);
  }


  List<Post> getPosts(AsyncSnapshot snapshot, List<String> tags) {
    return snapshot.data.docs.map<Post>((doc) => Post.fromFirestore(doc)).where((post) {
      if (tags.isEmpty) return true;
      post.userId;
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
    }).toList();
  }

  Future<List<Post>> myPostList() async {
    String user_id = _auth.currentUser!.uid;
    final snapshot = await _firestore.collection('posts').where('user_id', isEqualTo: user_id).get();
    return snapshot.docs.map<Post>((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<void> updateUserProfile({
    required String userName,
    required String email,
    required String age,
    required String gender,
    required String city,
  }) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update({
        "userName": userName,
        "email": email,
        "age": age,
        "gender": gender,
        "city": city,
      });
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      print("Error loading user profile: $e");
      return null;
    }
  }

  Future<List<Post>> joinedPostList() async {
    String user_id = _auth.currentUser!.uid;

    // Step 1: Fetch post IDs where the user is "going"
    final snapshot = await _firestore
        .collection('users_posts')
        .where('user_id', isEqualTo: user_id)
        .where('is_going', isEqualTo: true)
        .get();

    // Convert to List
    final List<String> going_post_id_list =
    snapshot.docs.map((doc) => doc['post_id'] as String).toList();

    // Step 2: If no posts found, return empty list
    if (going_post_id_list.isEmpty) {
      developer.log("⚠️ No joined events found for user: $user_id");
      return [];
    }

    developer.log("✅ Found ${going_post_id_list.length} joined events");

    // Step 3: Fetch events using post IDs
    try {
      final postSnapshot = await _firestore
          .collection('posts')
          .where(FieldPath.documentId, whereIn: going_post_id_list)
          .get();

      print("✅ Fetched ${postSnapshot.docs.length} joined events");

      return postSnapshot.docs.map((doc) {
        print("📌 Post Data: ${doc.data()}");
        return Post(
          id: doc.id,
          title: doc.get('title'),
          image: doc.get('image'),
          tags: List<String>.from(doc.get('tags') ?? []), // Ensures a List<String>
          description: doc.get('description') ?? "",
          timestamp: (doc.get('timestamp') is Timestamp)
              ? (doc.get('timestamp') as Timestamp).toDate()
              : DateTime.now(), userId: '',
        );      }).toList();
    } catch (e) {
      developer.log("❌ Firestore Query Error: $e");
      return [];
    }
  }

  Future<void> collectPost(String postID) async {
    try {
      await _firestore
          .collection('collected_posts')
          .doc(_auth.currentUser!.uid)
          .collection('posts')
          .doc(postID)
          .set({
        'post_id': postID,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("✅ Post collected: $postID");
    } catch (e) {
      print("❌ Error collecting post: $e");
    }
  }
  Future<void> uncollectPost(String postID) async {
    try {
      await _firestore
          .collection('collected_posts')
          .doc(_auth.currentUser!.uid)
          .collection('posts')
          .doc(postID)
          .delete();
      print("✅ Post uncollected: $postID");
    } catch (e) {
      print("❌ Error uncollecting post: $e");
    }
  }

  Future<bool> isPostCollected(String postID) async {
    final doc = await _firestore
        .collection('collected_posts')
        .doc(_auth.currentUser!.uid)
        .collection('posts')
        .doc(postID)
        .get();
    return doc.exists;
  }

  Future<List<Post>> getCollectedPosts() async {
    String user_id = _auth.currentUser!.uid;

    final snapshot = await _firestore
        .collection('collected_posts')
        .doc(user_id)
        .collection('posts')
        .get();

    final List<String> collectedPostIds =
    snapshot.docs.map((doc) => doc['post_id'] as String).toList();

    if (collectedPostIds.isEmpty) {
      return [];
    }

    final postSnapshot = await _firestore
        .collection('posts')
        .where(FieldPath.documentId, whereIn: collectedPostIds)
        .get();

    return postSnapshot.docs.map((doc) {
      return Post(
        id: doc.id,
        title: doc.get('title'),
        image: doc.get('image'),
        tags: List<String>.from(doc.get('tags') ?? []),
        description: doc.get('description') ?? "",
        timestamp: (doc.get('timestamp') is Timestamp)
            ? (doc.get('timestamp') as Timestamp).toDate()
            : DateTime.now(),
        userId: doc.get('user_id'),
      );
    }).toList();
  }



  Future<DocumentReference> addPost(
      String title, String desc, File imageFile, List<String> tags) async {
    final imageUrl = await uploadImage(imageFile, title);
      return await _firestore.collection('posts').add({
        'title': title,
        'user_id': _auth.currentUser!.uid,
        'image': imageUrl,
        'description': desc,
        'tags': tags,
        'timestamp': FieldValue.serverTimestamp()
      });
  }


  Future<DocumentReference> joinEvent(
      String post_id) async {
    return await _firestore.collection('users_posts').add({
      'user_id': _auth.currentUser!.uid,
      'post_id': post_id,
      'timestamp': FieldValue.serverTimestamp(),
      'is_going': true
    });
  }

  Future<UserPostRelation?> getUserPostRelation(
      String post_id) async {
    String user_id = _auth.currentUser!.uid;
    final snapshot = await _firestore.collection('users_posts').where('user_id', isEqualTo: user_id).where('post_id', isEqualTo: post_id).get();
    final docs = snapshot.docs.map((doc) {
      return UserPostRelation(doc['user_id'], doc['post_id'], doc['is_going']);
    });
    return docs.isEmpty ? null : docs.first;
  }


  Stream<QuerySnapshot> postsStream() {
    return _firestore.collection('posts').snapshots();
  }

  Stream<QuerySnapshot> myPostsStream() {
    String user_id = _auth.currentUser!.uid;
    return _firestore.collection('posts').where('user_id', isEqualTo: user_id).snapshots();
  }

  Future<List<Tag>> tagList() async {
    final snapshot = await _firestore.collection('tags').get();
    return snapshot.docs.map((doc) {
      return Tag(doc.get('name'));
    }).toList();
  }

  Future<void> saveArticles(Map<String, String> articles) async {
    for (var entry in articles.entries) {
      try {
        await _firestore.collection('articles').doc(entry.key).set({
          'title': entry.key,
          'content': entry.value,
        });
        developer.log("✅ Saved article: ${entry.key}");
      } catch (e) {
        developer.log("❌ Failed to save article ${entry.key}: $e");
      }
    }
  }


  /// ✅ Load articles from Firestore
  Future<Map<String, String>> getArticles() async {
    final snapshot = await _firestore.collection('articles').get();
    Map<String, String> articles = {};
    developer.log("data: ${snapshot.docs.toString()}");
    for (var doc in snapshot.docs) {
      articles[doc['title']] = doc['content'];
    }
    return articles;
  }

  Future<AppUser> getUserById(String? userID) async {
    final snapshot = await _firestore.collection('users').doc(userID).get();
    return AppUser.fromFirestore(snapshot);
  }

  Future<String> uploadImage(File imageFile, String postTitle) async {
    final uploadTask = FirebaseStorage.instance
        .ref()
        .child("images/${postTitle}.jpg")
        .putFile(imageFile);
    await uploadTask;
    return uploadTask.snapshot.ref.getDownloadURL();
  }

  Future<String> uploadProfilePicture(File imageFile) async {
    try {
      String userId = _auth.currentUser!.uid;

      // 🔥 Delete old image if it exists
      await FirebaseStorage.instance
          .ref()
          .child("profile_pictures/$userId.jpg")
          .delete()
          .catchError((e) {
        print('No previous image found');
      });

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/$userId.jpg");

      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      // Get download URL
      String downloadUrl = await storageRef.getDownloadURL();

      // Update profile picture in Firestore
      await _firestore.collection("users").doc(userId).update({
        'profilePicture': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      throw e;
    }
  }


}
