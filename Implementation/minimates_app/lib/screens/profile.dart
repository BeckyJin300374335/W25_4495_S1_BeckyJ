import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screens/edit_profile.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:untitled1/screens/policy_page.dart';
import 'package:untitled1/screens/preference.dart';
import '../auth/auth_page.dart';
import '../auth/main_page.dart';
import '../data/firestore.dart';
import '../utils/constants/colors.dart';
import 'contact_page.dart';
import 'my_posts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = false;

  final Firestore _firestore = Firestore();

  String? _profilePictureUrl;

  String _username = '';
  int? _age;
  String _gender = '';
  String _city = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  Future<void> _loadUserProfile() async {
    // // ✅ Wait a short moment to ensure FirebaseAuth is fully settled
    // await Future.delayed(Duration(milliseconds: 300));

    final userData = await _firestore.getUserProfile();
    if (userData != null) {
      setState(() {
        _username = userData['userName'] ?? 'Unnamed';
        _age = userData['age'] ?? 0; // or cast safely
        _gender = userData['gender'] ?? 'Unknown';
        _city = userData['city'] ?? 'Unknown';
        _email = userData['email'] ?? 'No email';
        _profilePictureUrl = userData['profilePicture'];
      });
    } else {
      print("⚠️ No profile data found");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: TColors.primary,
        centerTitle: true,
        // title: Text(
        //   'Profile',
        //   style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: TColors.primary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white, // ✅ White border
                          width: 2, // ✅ Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: _profilePictureUrl != null
                            ? NetworkImage(_profilePictureUrl!)
                            : AssetImage('assets/images/profile.jpg') as ImageProvider,
                      ),
                    ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _username,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),

                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () {
                      AuthenticationRemote().logout();
                      Navigator.of(context)
                          .pushReplacement(MaterialPageRoute(builder: (context) => Auth_Page()));
                    },
                  )
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileRow(title: 'Age', value: _age != null ? _age.toString() : 'Unknown'),
                  ProfileRow(title: 'Gender', value: _gender),
                  ProfileRow(title: 'City', value: _city),
                  ProfileRow(title: 'Email', value: _email),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: ListTile(
                      title: const Text('Posts',style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyPostsPage()),
                        );                      },
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: ListTile(
                      title: const Text('Preferences',style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PreferenceSelectionPage()),
                        ).then((_) {
                           // Refresh when returning from preference screen
                        });
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: ListTile(
                      title: const Text('Policy',style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PolicyPage()),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    child: ListTile(
                      title: const Text('Contact',style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ContactPage()),
                        );
                      },
                    ),
                  ),
                  ProfileRowWithTrailing(
                    title: 'Notifications',
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: TColors.primary,
                    ),
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                        _loadUserProfile(); // Reload profile after editing
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      ),
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final String title;
  final String value;

  ProfileRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class ProfileRowWithTrailing extends StatelessWidget {
  final String title;
  final Widget trailing;

  ProfileRowWithTrailing({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing,
        ],
      ),
    );
  }
}
