import 'package:flutter/material.dart';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/utils/constants/sizes.dart';
import '../auth/auth_page.dart';
import '../data/auth_data.dart';
import '../data/data.dart';
import '../utils/constants/colors.dart'; // Import your theme colors

class MyEventsPage extends StatefulWidget {
  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  int _selectedFilter = 0; // 0: Upcoming, 1: Past, 2: Cancelled
  List<Post> joinedPost = [];

  // final List<Map<String, dynamic>> events = [
  //   {
  //     "id": "GBD99763JS",
  //     "date": "24/09/2024",
  //     "organizer": "Infinity Event Organizer",
  //     "title": "Summer Music Festival",
  //     "status": "Upcoming",
  //     "color": TColors.primary,
  //   },
  //   {
  //     "id": "GBD99763KL",
  //     "date": "20/10/2024",
  //     "organizer": "AvantGarde Events",
  //     "title": "Fashion Forward Fest",
  //     "status": "Upcoming",
  //     "color": TColors.secondary,
  //   },
  // ];

  // @override
  // void initState() {
  //   Firestore().joinedPostList().then((value) {
  //     setState(() {
  //       joinedPost = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _fetchJoinedPosts();
  }

  void _fetchJoinedPosts() async {
    List<Post> fetchedPosts = await Firestore().joinedPostList();
    print("Fetched Posts: $fetchedPosts");

    if (mounted) {
      setState(() {
        joinedPost = fetchedPosts;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: TColors.secondary,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildFilterButtons(),
          const SizedBox(height: 20),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
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
                    'Becky Jin',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
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
            _filterButton("Posted", 1),
            _filterButton("Cancelled", 2),
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
    print("📝 UI is building with ${joinedPost.length} posts");

    if (joinedPost.isEmpty) {
      return Expanded(  // ✅ Ensure it takes available space
        child: Center(
          child: Text(
            "No joined events found.",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
        ),
      );
    }

    return Expanded( // ✅ Ensure ListView is inside Expanded
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        itemCount: joinedPost.length,
        itemBuilder: (context, index) {
          final post = joinedPost[index];
          print("🎉 Rendering event: ${post.title}");
          return _buildEventCard(post);
        },
      ),
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
              color: TColors.secondary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(post.tags.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(post.timestamp.toString(), style: TextStyle(color: Colors.white)),
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
                Text(post.title, style: TextStyle(color: Colors.black, fontSize: TSizes.fontSizeMd,fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  post.description.toString(),
                  style: TextStyle(color: Colors.black, fontSize: TSizes.fontSizeSm, fontWeight: FontWeight.normal),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _eventButton("Cancel", Color(0xFFD32F2F), () => _showCancelDialog()),
                    _eventButton("detail", TColors.accent,(){} ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventButton(String title, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: (){},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(title, style: TextStyle(color: Colors.white)),
    );
  }


  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.zero, // Remove default padding
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColors.secondary, // Title background color
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)), // Rounded top corners
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
            onPressed: () {
              Navigator.pop(context);
              // Handle cancellation logic here
            },
            child: Text("Yes", style: TextStyle(color: TColors.accent)),
          ),
        ],
      ),
    );
  }
}