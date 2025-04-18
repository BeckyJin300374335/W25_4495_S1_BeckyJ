import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/data/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../model/article.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String userName, String email) async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "userName": userName,
        "email": email,
        "age": '',
        "gender": '',
        "city": '',
        "profilePicture": '',
        "preferences": [],
      });
      return true;
    } catch (e) {
      print("Error creating user: $e");
      return false;
    }
  }


  Future<List<Post>> getPostsByUser(String userId) async {
    final snapshot = await _firestore
        .collection('posts')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }
  Future<Post> getPostByID(String postID) async {
    final snapshot = await _firestore.collection('posts').doc(postID).get();
    return Post.fromFirestore(snapshot);
  }

  List<Post> getPosts(AsyncSnapshot snapshot, List<String> tags) {
    return snapshot.data.docs.map<Post>((doc) => Post.fromFirestore(doc)).where((post) {
      if (tags.isEmpty) return true;
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
    }).toList();
  }

  Future<List<Post>> myPostList() async {
    String user_id = _auth.currentUser!.uid;
    final snapshot = await _firestore.collection('posts').where('user_id', isEqualTo: user_id).get();
    return snapshot.docs.map<Post>((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<void> unjoinEvent(String postId) async {
    String userId = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('users_posts')
        .where('user_id', isEqualTo: userId)
        .where('post_id', isEqualTo: postId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }


  }

  Future<void> addComment(String postId, String content, bool isAuthor) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await getUserById(user.uid);

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'user_id': user.uid,
      'user_name': userData.userName,
      'user_photo': userData.profilePicture,
      'content': content,
      'timestamp': Timestamp.now(),
      'is_author': isAuthor,
      'likes': [],
    });
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> addReply({
    required String postId,
    required String commentId,
    required String content,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await getUserById(user.uid);

    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .add({
      'user_id': user.uid,
      'user_name': userData.userName,
      'user_photo': userData.profilePicture,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': [],
    });
  }
  Stream<QuerySnapshot> getReplies(String postId, String commentId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> toggleCommentLike(String postId, String commentId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final commentRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    final doc = await commentRef.get();
    List likes = doc['likes'] ?? [];

    if (likes.contains(userId)) {
      await commentRef.update({'likes': FieldValue.arrayRemove([userId])});
    } else {
      await commentRef.update({'likes': FieldValue.arrayUnion([userId])});
    }
  }

  Future<void> toggleReplyLike(String postId, String commentId, String replyId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final replyRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);

    final doc = await replyRef.get();
    List likes = doc['likes'] ?? [];

    if (likes.contains(userId)) {
      await replyRef.update({'likes': FieldValue.arrayRemove([userId])});
    } else {
      await replyRef.update({'likes': FieldValue.arrayUnion([userId])});
    }
  }





  Future<int> getJoinedCount(String postId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users_posts')
        .where('post_id', isEqualTo: postId)        // ✅ MATCHES your Firestore
        .where('is_going', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }

  //provides a live stream of people who joined an event
  Stream<int> joinedCountStream(String postId) {
    return _firestore
        .collection('users_posts')
        .where('post_id', isEqualTo: postId)
        .where('is_going', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  Future<void> savePreferences(List<String> selectedPreferences) async {
    try {
      await _firestore.collection("users").doc(_auth.currentUser!.uid).update({
        'preferences': selectedPreferences,
        'preferencesUpdatedAt': FieldValue.serverTimestamp(),
      });
      developer.log("✅ Preferences saved: $selectedPreferences");
    } catch (e) {
      developer.log("❌ Error saving preferences: $e");
    }
  }

  Future<List<String>> getUserPreferences() async {
    try {
      final doc = await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
      if (doc.exists && doc.data()!.containsKey("preferences")) {
        return List<String>.from(doc["preferences"]);
      }
    } catch (e) {
      developer.log("❌ Error fetching preferences: $e");
    }
    return [];
  }

  Future<void> updateUserProfile({
    required String userName,
    required String email,
    required int age,
    required String gender,
    required String city,
    String? profilePicture, // ✅ add this
  }) async {
    try {
      final data = {
        "userName": userName,
        "email": email,
        "age": age,
        "gender": gender,
        "city": city,
      };

      if (profilePicture != null) {
        data["profilePicture"] = profilePicture; // ✅ save it if provided
      }

      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .update(data);
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final snapshot = await _firestore.collection("users").doc(_auth.currentUser!.uid).get();
      return snapshot.exists ? snapshot.data() : null;
    } catch (e) {
      print("Error loading user profile: $e");
      return null;
    }
  }

  Future<List<Post>> joinedPostList() async {
    String user_id = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('users_posts')
        .where('user_id', isEqualTo: user_id)
        .where('is_going', isEqualTo: true)
        .get();

    final List<String> going_post_id_list =
    snapshot.docs.map((doc) => doc['post_id'] as String).toList();

    if (going_post_id_list.isEmpty) {
      developer.log("⚠️ No joined events found for user: $user_id");
      return [];
    }

    try {
      final postSnapshot = await _firestore
          .collection('posts')
          .where(FieldPath.documentId, whereIn: going_post_id_list)
          .get();

      return postSnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
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

    if (collectedPostIds.isEmpty) return [];

    final postSnapshot = await _firestore
        .collection('posts')
        .where(FieldPath.documentId, whereIn: collectedPostIds)
        .get();

    return postSnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<DocumentReference> addPost(
      String title,
      String desc,
      File imageFile,
      List<String> tags,
      double latitude,
      double longitude,
      String address,
      int spot,
      DateTime startTime,
      DateTime endTime,
      ) async {
    final imageUrl = await uploadImage(imageFile, title);
    return await _firestore.collection('posts').add({
      'title': title,
      'user_id': _auth.currentUser!.uid,
      'image': imageUrl,
      'description': desc,
      'tags': tags,
      'timestamp': FieldValue.serverTimestamp(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'spot': spot,
      'start_time': startTime,
      'end_time': endTime,
    });
  }

  Future<DocumentReference> joinEvent(String post_id) async {
    return await _firestore.collection('users_posts').add({
      'user_id': _auth.currentUser!.uid,
      'post_id': post_id,
      'timestamp': FieldValue.serverTimestamp(),
      'is_going': true
    });
  }

  Future<UserPostRelation?> getUserPostRelation(String post_id) async {
    String user_id = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('users_posts')
        .where('user_id', isEqualTo: user_id)
        .where('post_id', isEqualTo: post_id)
        .get();
    final docs = snapshot.docs.map((doc) =>
        UserPostRelation(doc['user_id'], doc['post_id'], doc['is_going']));
    return docs.isEmpty ? null : docs.first;
  }

  Stream<QuerySnapshot> postsStream() {
    return _firestore.collection('posts').snapshots();
  }

  Stream<QuerySnapshot> myPostsStream() {
    String user_id = _auth.currentUser!.uid;
    return _firestore
        .collection('posts')
        .where('user_id', isEqualTo: user_id)
        .snapshots();
  }

  Future<List<Tag>> tagList() async {
    final snapshot = await _firestore.collection('tags').get();
    return snapshot.docs.map((doc) => Tag(doc.get('name'))).toList();
  }

  Future<List<Post>> postList() async {
    final snapshot = await _firestore.collection('posts').get();
    return snapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
  }

  Future<void> saveArticles(List<Article> articles) async {
    for (var article in articles) {
      try {
        final imageUrl = await uploadArticleImage(article.image);
        final updatedArticle = Article(
          title: article.title,
          content: article.content,
          image: imageUrl,
        );
        await _firestore
            .collection('articles')
            .doc(updatedArticle.title)
            .set(updatedArticle.toFirestore());
      } catch (e) {
        print("❌ Failed to save article ${article.title}: $e");
      }
    }
  }

  Future<List<Article>> getArticles() async {
    final snapshot = await _firestore.collection('articles').get();
    return snapshot.docs.map((doc) => Article.fromFirestore(doc.data())).toList();
  }

  Future<String> uploadArticleImage(String fileName) async {
    final ref = FirebaseStorage.instance.ref().child("articles/$fileName");
    final byteData = await rootBundle.load('assets/images/articles/$fileName');
    final Uint8List data = byteData.buffer.asUint8List();
    final uploadTask = await ref.putData(data);
    final downloadUrl = await uploadTask.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<AppUser> getUserById(String? userID) async {
    final snapshot = await _firestore.collection('users').doc(userID).get();
    return AppUser.fromFirestore(snapshot);
  }

  Future<AppUser> getMySelf() async {
    return await getUserById(_auth.currentUser!.uid);
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
      await FirebaseStorage.instance
          .ref()
          .child("profile_pictures/$userId.jpg")
          .delete()
          .catchError((e) => print('No previous image found'));

      Reference storageRef =
      FirebaseStorage.instance.ref().child("profile_pictures/$userId.jpg");

      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;

      String downloadUrl = await storageRef.getDownloadURL();

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
