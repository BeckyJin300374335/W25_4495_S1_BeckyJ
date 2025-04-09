import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/utils/constants/sizes.dart';
import '../auth/auth_page.dart';
import '../data/auth_data.dart';
import '../data/data.dart';
import '../utils/constants/colors.dart';
import 'details.dart'; // Import your theme colors
import 'package:intl/intl.dart';


class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  int _selectedFilter = 0;
  Future<AppUser?>? _cachedUserFuture;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          _cachedUserFuture = Firestore().getUserById(user.uid);
        });
      } else {
        setState(() {
          _cachedUserFuture = null;
        });
      }
    });
  }

  Future<List<Post>> _getCurrentList() async {
    List<Post> posts;
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 0:
        posts = await Firestore().joinedPostList();
        posts = posts.where((post) => post.startTime != null && post.startTime!.isAfter(now)).toList();
        break;
      case 1:
        posts = await Firestore().joinedPostList();
        posts = posts.where((post) => post.startTime != null && post.startTime!.isBefore(now)).toList();
        break;
      case 2:
        posts = await Firestore().getCollectedPosts();
        break;
      default:
        posts = [];
    }
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF5F3),
        centerTitle: true,
        title: Image.asset(
          'assets/logos/MiniMates_color.png',
          height: 30,
        ),
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 10),
          _buildFilterButtons(),
          const SizedBox(height: 10),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    if (_cachedUserFuture == null) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: Text("⚠️ No logged-in user")),
      );
    }

    return FutureBuilder<AppUser?>(
      future: _cachedUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("Error loading profile")),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text("No user data available")),
          );
        }

        final user = snapshot.data!;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFFF9AFA6),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: user.profilePicture != null
                      ? NetworkImage(user.profilePicture!)
                      : AssetImage('assets/images/profile.jpg') as ImageProvider,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user.userName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "${user.age != null ? '${user.age} years old' : ''} · ${user.city ?? ''}",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              Text(
                user.gender ?? '',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _filterButton("Upcoming", 0),
            _filterButton("Past", 1),
            _filterButton("Likes", 2),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String title, int index) {
    return Container(
      width: 120,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFilter = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: _selectedFilter == index ? TColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: _selectedFilter == index ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return FutureBuilder<List<Post>>(
      future: _getCurrentList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return Center(
            child: Text(
              "No joined events found.",
              style: TextStyle(color: Colors.black54, fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildEventCard(post);
          },
        );
      },
    );
  }

  Widget _buildEventCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFF9AFA6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  post.startTime != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(post.startTime!)
                      : 'No start time',
                  style: TextStyle(color: Colors.white),
                ),

              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title, style: TextStyle(color: Colors.black, fontSize: TSizes.fontSizeMd, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  post.description,
                  style: TextStyle(color: Colors.black, fontSize: TSizes.fontSizeSm, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _eventButton("Cancel", Color(0xFFFC5C65), post),
                    _eventButton("detail", TColors.accent, post),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventButton(String title, Color color, Post post) {
    return ElevatedButton(
      onPressed: () async {
        if (title == "Cancel") {
          _showCancelDialog(() async {
            Navigator.pop(context); // Close the dialog

            if (_selectedFilter == 0 || _selectedFilter == 1) {
              await Firestore().unjoinEvent(post.id);
            } else if (_selectedFilter == 2) {
              await Firestore().uncollectPost(post.id);
            }

            setState(() {}); // Refresh UI
          });
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                title: post.title,
                image: post.image,
                postID: post.id,
                userID: post.userId,
              ),
            ),
          );
          setState(() {}); // ✅ refreshes MyEventsPage
// Refresh after navigating back
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }


  void _showCancelDialog(VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColors.secondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Text(
            "Confirm Cancellation",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Text("Are you sure you want to cancel this event?", style: TextStyle(color: TColors.accent, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: TextStyle(color: TColors.accent)),
          ),
          TextButton(
            onPressed: onConfirm,
            child: Text("Yes", style: TextStyle(color: TColors.accent)),
          ),
        ],
      ),
    );
  }

}