import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:untitled1/screens/login.dart';

import '../auth/auth_page.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userName = "Loading...";
  String userEmail = "Loading...";
  String profilePicUrl = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  /// Fetch user details from Firestore
  void fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection("users").doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          userName = userDoc['name'] ?? "Unknown";
          userEmail = userDoc['email'] ?? "No Email";
          profilePicUrl = userDoc['profilePic'] ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back button
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20, // Match your project font size
            fontFamily: 'Poppins', // Replace with the actual font
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture & User Info
            Center(
              child: Column(
                children: [
                  profilePicUrl.isNotEmpty
                      ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profilePicUrl),
                  )
                      : CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xFFF9AFA6),
                    child: Text(
                      userName.isNotEmpty ? userName[0] : "U",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      // Navigate to Edit Profile Page
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Color(0xFFF9AFA6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // List of Options
            ListTile(
              title: Text(
                "App Info",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
              trailing: Icon(Icons.info_outline),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
              trailing: Icon(Icons.rule),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Privacy & Policy",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
              trailing: Icon(Icons.book_outlined),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
              trailing: Icon(Icons.help_outline),
              onTap: () {},
            ),
            Divider(),

            Spacer(),

            // Sign Out Button
            Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    AuthenticationRemote().logout();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return Auth_Page();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Color(0xFFF9AFA6), // Same color as Login Page Button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
