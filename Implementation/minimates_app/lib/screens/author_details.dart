import 'package:flutter/material.dart';
import '../data/data.dart';
import '../data/firestore.dart';
import 'chat_page.dart';
import 'details.dart';

class AuthorDetailsPage extends StatefulWidget {
  final String userID;

  const AuthorDetailsPage({super.key, required this.userID});

  @override
  _AuthorDetailsPageState createState() => _AuthorDetailsPageState();
}

class _AuthorDetailsPageState extends State<AuthorDetailsPage> {
  bool isFollowing = false;
  AppUser? author;

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });

    // ✅ Handle follow/unfollow logic
    if (isFollowing) {
      print('Following user');
    } else {
      print('Unfollowed user');
    }
  }

  @override
  void initState() {
    super.initState();
    Firestore().getUserById(widget.userID).then((appUser) => {
          setState(() {
            author = appUser;
          })
        });
  }

  void _startChat() {
    if (author != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(receiverUser: author!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFCF5F3),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF5F3),
          centerTitle: true,
          title: Image.asset(
            'assets/logos/MiniMates_color.png',
            height: 30,
            fit: BoxFit.contain,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ✅ Profile Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF9AFA6),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: author?.profilePicture != null
                          ? NetworkImage(author!.profilePicture!)
                          : AssetImage('assets/images/profile.jpg')
                              as ImageProvider,
                    ),
                    SizedBox(height: 10),
                    Text(
                      author?.userName ?? 'Unknown User',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "${author?.age != null ? '${author!.age} years old' : ''} · ${author?.city ?? ''}",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    Text(
                      author?.gender != null ? author!.gender! : '',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    SizedBox(height: 12),

                    // ✅ Follow & Chat Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _actionButton(
                          label: isFollowing ? 'Following' : 'Follow',
                          color: isFollowing ? Colors.grey : Color(0xFFF9AFA6),
                          onPressed: _toggleFollow,
                        ),
                        SizedBox(width: 10),
                        _actionButton(
                          label: 'Message',
                          color: Color(0xFFFC5C65),
                          onPressed: _startChat,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // ✅ Posts Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Posts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              FutureBuilder<List<Post>>(
                future: Firestore().getPostsByUser(widget.userID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final posts = snapshot.data!
                      .where((post) => post.userId == widget.userID)
                      .toList();
                  return _postList(posts);
                },
              ),
            ],
          ),
        ));
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  Widget _postList(List<Post> posts) {
    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No posts yet',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  title: post.title,
                  image: post.image,
                  postID: post.id,
                  userID: post.userId,
                ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    post.image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 5),
                      Text(
                        post.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
  }
}
