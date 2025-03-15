import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/screens/details.dart';
import 'package:untitled1/screens/add_post.dart';
import 'package:untitled1/screens/profile.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../utils/constants/colors.dart';
import 'article_detail.dart';
import 'article_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<String> selectedFilters = {};

  Article article = Article();

  @override
  void initState() {
    super.initState();
    _loadArticles(); // Load articles when HomeScreen is initialized
  }

  Future<Map<String, String>> _loadArticles() async {
    final articles = await article.loadArticlesFromFirestore();
    return articles;
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/profile.jpg'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How are you',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              'Becky Jin',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: TColors.secondary,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddPost(showBackArrow: true),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  // Filter Tags

                  // Popular Articles
                  SizedBox(
                    height: 250,
                    child: FutureBuilder<Map<String, String>>(
                      future: _loadArticles(),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load articles'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No articles available'));
                      }

                      final articles = snapshot.data!;


                          return ListView.builder(
                            shrinkWrap: true, // ✅ Fixes scroll conflict
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final titles = articles.keys.toList();
                              final title = titles[index];
                              final content = articles[title];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleDetailsPage(
                                        title: title,
                                        content: content ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 250,
                                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                        child: Image.asset(
                                          'assets/images/park1.jpg',
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              content != null && content.length > 30
                                                  ? '${content.substring(0, 30)}...'
                                                  : content ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            SizedBox(height: 5),

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
                  ),



                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder(
                        future: Firestore().tagList(),
                        builder: (context, snapshot) {
                          final tagList = snapshot.data;
                          if (tagList != null) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: tagList
                                  .map((tag) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedFilters.contains(tag.name)
                                                ? selectedFilters
                                                    .remove(tag.name)
                                                : selectedFilters.add(tag.name);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 8),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: selectedFilters
                                                    .contains(tag.name)
                                                ? TColors.accent
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            tag.name,
                                            style: TextStyle(
                                              color: selectedFilters
                                                      .contains(tag.name)
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                  ),


                  // Posts Section
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore().postsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final postList = Firestore()
                          .getPosts(snapshot, selectedFilters.toList());

                      return ListView.builder(
                        shrinkWrap:
                            true, // Ensures ListView takes only needed space
                        physics:
                            ClampingScrollPhysics(), // Allows vertical scrolling
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          var post = postList[index];
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
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15)),
                                    child: Image.network(
                                      post.image,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.title,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 14,
                                              backgroundImage: AssetImage(
                                                  'assets/images/profile.jpg'),
                                            ),
                                            SizedBox(width: 8),
                                            // FutureBuilder(
                                            //     future: Firestore()
                                            //         .getUserById(post.userId),
                                            //     builder: (context, snapshot) {
                                            //       return Text(
                                            //         snapshot!.data!.name,
                                            //         style: TextStyle(
                                            //             fontWeight:
                                            //                 FontWeight.bold),
                                            //       );
                                            //     }),
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 6),
                                                child: Row(
                                                  children: [
                                                    // Icon(Icons.arrow_forward, color: TColors.secondary),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "More>>",
                                                      style: TextStyle(
                                                          color: TColors.accent,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
