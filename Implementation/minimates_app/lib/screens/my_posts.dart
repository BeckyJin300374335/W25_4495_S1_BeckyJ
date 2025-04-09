import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/firestore.dart';
import '../utils/constants/colors.dart';
import 'details.dart';
import 'edit_post.dart'; // 👈 Make sure you have this page created

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  late Future<List<Post>> _myPosts;
  late Future<AppUser?> _userFuture;
  final Firestore _firestore = Firestore();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _myPosts = _firestore.myPostList();
    _userFuture = _firestore.getMySelf();
  }

  Future<void> _handlePostAction(BuildContext context, Post post) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Choose an action"),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'edit'),
            child: const Text("Edit"),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'delete'),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );

    if (result == 'edit') {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditPostPage(post: post)),
      );
      _refreshData();
    } else if (result == 'delete') {
      await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
      _refreshData();
    }
  }

  Widget _actionButton({required String label, required Color color, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF5F3),
        centerTitle: true,
        title: Image.asset(
          'assets/logos/MiniMates_color.png',
          height: 30,
        ),
      ),
      body: FutureBuilder<AppUser?>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          return FutureBuilder<List<Post>>(
            future: _myPosts,
            builder: (context, postSnapshot) {
              if (!userSnapshot.hasData || !postSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = userSnapshot.data!;
              final posts = postSnapshot.data!;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // ✅ Profile Header
                    SizedBox(
                      width: double.infinity,
                      height: 250,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
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
                                backgroundImage: user.profilePicture != null
                                    ? NetworkImage(user.profilePicture!)
                                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              user.userName,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              "${user.age != null ? '${user.age} years old' : ''} · ${user.city}",
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                            Text(
                              user.gender ?? '',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Posts',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          height: 2, // Thickness of the line
                          width: 70,
                          color: Color(0xFFFC5C65), // You can change this to any color you like
                        ),
                      ),
                    ),

                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: posts.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailsPage(
                                title: post.title,
                                image: post.image,
                                postID: post.id,
                                userID: post.userId,
                              ),
                            ),
                          ),
                          onLongPress: () => _handlePostAction(context, post),
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: Image.network(
                                    post.image,
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        post.description,
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

