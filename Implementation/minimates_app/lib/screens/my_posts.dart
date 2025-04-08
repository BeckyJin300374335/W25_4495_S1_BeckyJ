import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/firestore.dart';
import 'details.dart';
import 'edit_post.dart'; // 👈 Make sure you have this page created

class MyPostsPage extends StatefulWidget {
  const MyPostsPage({super.key});

  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  late Future<List<Post>> _myPosts;

  @override
  void initState() {
    super.initState();
    _refreshPosts();
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _myPosts = Firestore().myPostList();
    });
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
      // Navigate to EditPostPage and pass the post
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditPostPage(post: post)),
      );
      _refreshPosts();
    } else if (result == 'delete') {
      await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
      _refreshPosts(); // Refresh UI immediately after deletion
    }
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
      body: FutureBuilder<List<Post>>(
        future: _myPosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!;
          if (posts.isEmpty) {
            return const Center(child: Text("No posts yet."));
          }

          return GridView.builder(
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
          );
        },
      ),
    );
  }
}
