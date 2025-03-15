import 'package:flutter/material.dart';
import 'package:untitled1/screens/edit_profile.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:untitled1/screens/preference.dart';
import '../auth/auth_page.dart';
import '../data/firestore.dart';
import '../utils/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = false;

  final Firestore _firestore = Firestore();

  String _username = '';
  String _age = '';
  String _gender = '';
  String _city = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await _firestore.getUserProfile();
    if (userData != null) {
      setState(() {
        _username = userData['userName'] ?? '';
        _age = userData['age'] ?? '';
        _gender = userData['gender'] ?? '';
        _city = userData['city'] ?? '';
        _email = userData['email'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: TColors.secondary,
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
                color: TColors.secondary,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
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
                  ProfileRow(title: 'Age', value: _age),
                  ProfileRow(title: 'Gender', value: _gender),
                  ProfileRow(title: 'City', value: _city),
                  ProfileRow(title: 'Email', value: _email),
                  SizedBox(height: 10),
                  ListTile(
                    title: const Text('Preferences'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PreferenceSelectionPage()),
                      );
                    },
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
                      activeColor: TColors.secondary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => EditProfileScreen()),
                        );
                        _loadUserProfile(); // Reload profile after editing
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.secondary,
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
