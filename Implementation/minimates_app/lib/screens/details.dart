import 'package:flutter/material.dart';
import 'package:untitled1/data/firestore.dart';

import '../data/data.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String image;
  final String postID;
  final String userID;

  const DetailsPage(
      {super.key,
      required this.title,
      required this.image,
      required this.postID,required this.userID});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isCollected = false;
  bool isGoing = false;
  Post? post = null;

  void _confirmGoing() {
    if(isGoing){
      return;
    }
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
                  isGoing = !isGoing;
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

  @override
  void initState() {
    // TODO: implement initState
    Firestore().getUserPostRelation(widget.postID).then((value) {
      if (value != null && value.is_going) {
        setState(() {
          isGoing = true;
        });
      } else {
        setState(() {
          isGoing = false;
        });
      }
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
          'assets/images/1.png', // Replace with your logo
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
            // Image Section
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

            // User Info Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/1.png'),
                  ),
                  SizedBox(width: 10),
                  FutureBuilder(
                      future: Firestore()
                          .getUserById(widget.userID),
                      builder: (context, snapshot) {
                        if(snapshot.data != null){
                          return Text(
                            snapshot.data!.name,
                            style: TextStyle(
                                fontWeight:
                                FontWeight.bold),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }

                      }),
                  Spacer(),
                  Text(
                    "Today at 11:40 AM",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Description Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Join us for a fun-filled day at the park! This activity is open for all ages and is a great way to meet new friends.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),

            SizedBox(height: 20),

            // Buttons Section (Placed Right Below the Description)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Save Button
                  GestureDetector(
                    onTap: () {
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
                          "Star",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // Going Button
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
                          Icon(Icons.event,
                              color: isGoing ? Colors.white : Colors.black87),
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
