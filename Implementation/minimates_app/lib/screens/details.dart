import 'package:flutter/material.dart';
import 'package:untitled1/data/firestore.dart';
import '../data/data.dart';
import '../utils/constants/colors.dart';
import 'author_details.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String image;
  final String postID;
  final String userID;

  const DetailsPage({
    super.key,
    required this.title,
    required this.image,
    required this.postID,
    required this.userID,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isCollected = false;
  bool isGoing = false;
  Post? post;

  void _confirmGoing() {
    if (isGoing) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Going"),
        content: Text("Are you sure you want to attend this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Firestore().joinEvent(widget.postID).then((doc) {
                setState(() {
                  isGoing = true;
                });
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFF9AFA6)),
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Unknown date';
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} at ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();

    Firestore().getUserPostRelation(widget.postID).then((value) {
      if (value != null && value.is_going) {
        setState(() {
          isGoing = true;
        });
      }
    });

    Firestore().isPostCollected(widget.postID).then((value) {
      setState(() {
        isCollected = value;
      });
    });

    Firestore().getPostByID(widget.postID).then((value) {
      setState(() {
        post = value;
      });
    });
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20)),
                  child: Image.network(
                    widget.image,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activity",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ✅ User Info Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // ✅ Navigate to Author Details Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthorDetailsPage(userID: widget.userID),
                        ),
                      );
                    },
                    child: FutureBuilder<AppUser>(
                      future: Firestore().getUserById(widget.userID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text("Error loading user");
                        }
                        if (!snapshot.hasData || snapshot.data == null) {
                          return Text("Unknown User");
                        }

                        final author = snapshot.data!;

                        return Row(
                          children: [
                            // ✅ Profile Picture with Border
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white, // ✅ White Border
                                  width: 1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: author.profilePicture != null
                                    ? NetworkImage(author.profilePicture!)
                                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              author.userName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Spacer(),
                  Text(
                    post != null ? _formatTimestamp(post!.timestamp) : 'Loading...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ✅ Description Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                post != null ? post!.description : 'Loading...',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            // ✅ Additional Info Section
            if (post != null) ...[
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (post!.startTime != null)
                      Text(
                        '🕒 Start Time: ${_formatTimestamp(post!.startTime)}',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    if (post!.endTime != null)
                      Text(
                        '🕓 End Time: ${_formatTimestamp(post!.endTime)}',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    if (post!.address != null && post!.address!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          '📍 Address:\n${post!.address!}',
                          style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                        ),
                      ),
                    if (post!.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Wrap(
                          spacing: 8,
                          children: post!.tags.map((tag) {
                            return Chip(
                              label: Text(
                                tag,
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Color(0xFFFC5C65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // ✅ bigger radius
                                side: BorderSide.none, // ✅ no border
                              ),
                            );
                          }).toList(),
                        ),
                      )

                  ],
                ),
              ),
            ],



            SizedBox(height: 20),

            // ✅ Buttons Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ✅ Save Button
                  GestureDetector(
                    onTap: () async {
                      if (isCollected) {
                        await Firestore().uncollectPost(widget.postID);
                      } else {
                        await Firestore().collectPost(widget.postID);
                      }
                      setState(() {
                        isCollected = !isCollected;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          isCollected ? Icons.star : Icons.star_border,
                          color: isCollected ? Colors.yellow[700] : Colors.grey,
                          size: 26,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Like",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // ✅ Going Button
                  GestureDetector(
                    onTap: _confirmGoing,
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isGoing ? Color(0xFFF9AFA6) : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.event,
                            color: isGoing ? Colors.white : Colors.black87,
                          ),
                          SizedBox(width: 6),
                          Text(
                            isGoing ? "Already Joined" : "Going",
                            style: TextStyle(
                              color: isGoing ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
