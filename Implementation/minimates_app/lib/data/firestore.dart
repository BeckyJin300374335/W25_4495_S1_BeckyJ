import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/data/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //store/retrieve data
  final FirebaseAuth _auth = FirebaseAuth.instance; //get the currently logged-in user

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

  List getPosts(AsyncSnapshot snapshot) {
    final postList = snapshot.data.docs.map((doc) {
      return Post(doc.id, doc['title'], doc['image']);
    }).toList();
    return postList;
  }

  Future<bool> addPost(String title, File imageFile) async {
    final imageUrl = await uploadImage(imageFile, title);
    await _firestore
        .collection('posts')
        .add({'title': title, 'user_id': _auth.currentUser!.uid, 'image': imageUrl});
    return true;
  }

  Stream<QuerySnapshot> stream() {
    return _firestore.collection('posts').snapshots();
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
