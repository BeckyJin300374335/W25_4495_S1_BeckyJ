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

  List getPosts(AsyncSnapshot snapshot, List<String> tags) {
    return snapshot.data.docs.map((doc) {
      return Post(doc.id, doc.get('title'), doc.get('image'), doc.get('tags'));
    }).where((post) {
      if (tags.isEmpty) {
        return true;
      }
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
    }).toList();
  }

  Future<List> postList(List<String> tags) async {
    final snapshot = await _firestore.collection('posts').get();
    return snapshot.docs.map((doc) {
      return Post(doc.id, doc.get('title'), doc.get('image'), doc.get('tags'));
    }).where((post) {
      if (tags.isEmpty) {
        return true;
      }
      return Set.from(tags).intersection(Set.from(post.tags)).isNotEmpty;
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

  Stream<QuerySnapshot> postsStream() {
    return _firestore.collection('posts').snapshots();
  }

  Future<List<Tag>> tagList() async {
    final snapshot = await _firestore.collection('tags').get();
    return snapshot.docs.map((doc) {
      return Tag(doc.get('name'));
    }).toList();
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
