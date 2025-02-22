import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled1/data/post.dart';

class Firestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      return true;
    }
  }

  List getPosts(AsyncSnapshot snapshot) {
    final postList = snapshot.data.docs.map((doc)  {
      return Post(doc.id, doc['title']);
    }).toList();
    return postList;
  }

  Future<bool> addPost(String title) async{
    await _firestore.collection('posts').add({'title': title, 'user_id': _auth.currentUser!.uid});
    return true;
  }

  Stream<QuerySnapshot> stream() {
    return _firestore.collection('posts').snapshots();
  }
}
