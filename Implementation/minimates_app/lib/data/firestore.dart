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

  Future<bool> createUser(String email) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
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
      post.userID;
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
    }).toList();
  }

  Future<List<Post>> postList(List<String> tags) async {
    final snapshot = await _firestore.collection('posts').get();

    return snapshot.docs.map<Post>((doc) => Post.fromFirestore(doc)).where((post) {
      if (tags.isEmpty) return true;
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
    }).toList();
  }



  // List getPosts(AsyncSnapshot snapshot, List<String> tags) {
  //   return snapshot.data.docs.map((doc) {
  //     return Post(doc.id, doc.get('title'), doc.get('image'), doc.get('tags'), doc.get('description'), doc.get('timestamp'));
  //   }).where((post) {
  //     if (tags.isEmpty) {
  //       return true;
  //     }
  //     return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
  //   }).toList();
  // }
  //
  // Future<List> postList(List<String> tags) async {
  //   final snapshot = await _firestore.collection('posts').get();
  //   return snapshot.docs.map((doc) {
  //     return Post(doc.id, doc.get('title'), doc.get('image'), doc.get('tags'), doc.get('description'), doc.get('timestamp'));
  //   }).where((post) {
  //     if (tags.isEmpty) {
  //       return true;
  //     }
  //     return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
  //   }).toList();
  // }

  // Future<List<Post>> joinedPostList() async {
  //   String user_id = _auth.currentUser!.uid;
  //   final snapshot = await _firestore.collection('users_posts').where('user_id', isEqualTo: user_id).where('is_going', isEqualTo: true).get();
  //   final going_post_id_list = snapshot.docs.map((doc) {
  //     return doc['post_id'];
  //   });
  //   return await _firestore.collection('posts').where(FieldPath.documentId, whereIn: going_post_id_list).get().then((value) {
  //     return value.docs.map((doc) {
  //       return Post(doc.id, doc.get('title'), doc.get('image'), doc.get('tags'));
  //     }).toList();
  //   });
  // }

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

  Future<List<Tag>> tagList() async {
    final snapshot = await _firestore.collection('tags').get();
    return snapshot.docs.map((doc) {
      return Tag(doc.get('name'));
    }).toList();
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
}
