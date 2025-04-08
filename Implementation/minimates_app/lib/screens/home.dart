// ✅ Modified home.dart with Gemini "May Like" + Recommended Badge

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/screens/details.dart';
import 'package:untitled1/screens/add_post.dart';
import 'package:untitled1/screens/profile.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../data/data.dart';
import '../model/article.dart';
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
  final Firestore _firestore = Firestore();
  String? _profilePictureUrl;

  List<String> recommendedPostIds = [];
  bool showRecommendations = false;

  String? _username = '';
  int? _age;
  String? _gender;
  String? _city;
  String? _email;

  ArticleList article = ArticleList();


  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  bool _hasInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasInitialized) {
      _hasInitialized = true;
      Firestore().getUserPreferences().then((prefs) {
        if (prefs.isNotEmpty) {
          callGeminiModel(); // Refresh recommendations when returning
        }
      });
    }
  }


  Future<List<Article>> _loadArticles() async {
    return await article.loadArticlesFromFirestore();
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
        _profilePictureUrl = userData['profilePicture'];
      });

      if (userData.containsKey('preferences') && userData['preferences'].isNotEmpty) {
        callGeminiModel();
      }
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: _profilePictureUrl != null
                                ? NetworkImage(_profilePictureUrl!)
                                : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('How are you', style: TextStyle(fontSize: 14, color: Colors.grey)),
                            Text(_username ?? "", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFC5C65)),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPost(showBackArrow: true)));
                            },
                          ),
                        )
                      ],
                    ),
                  ),



                  SizedBox(
                    height: 230,
                    child: FutureBuilder<List<Article>>(
                      future: _loadArticles(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Failed to load articles'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No articles available'));
                        }

                        final articles = snapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true, // ✅ Fixes scroll conflict
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            final articles = snapshot.data!;
                            final article = articles[index];
                            final title = article.title;
                            final content = article.content;



                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailsPage(
                                      title: title,
                                      content: content ?? '',
                                      image: article.image,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                              child: Container(
                                width: 250,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
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
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10)),
                                        child: Image.network(
                                          article.image,
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            content != null &&
                                                content.length > 30
                                                ? '${content.substring(0, 30)}...'
                                                : content ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                            TextStyle(color: Colors.grey),
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



                  // ✅ "May Like" + Tags Row
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder(
                      future: Firestore().tagList(),
                      builder: (context, snapshot) {
                        final tagList = snapshot.data;
                        if (tagList != null) {
                          return Row(
                            children: [
                              ElevatedButton(
                                onPressed: callGeminiModel,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFC5C65),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                ),
                                child: const Text("May Like", style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: tagList.map((tag) {
                                    final isSelected = selectedFilters.contains(tag.name);
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isSelected ? selectedFilters.remove(tag.name) : selectedFilters.add(tag.name);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: isSelected ? TColors.accent : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(tag.name, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),

                  // ✅ Posts Section with Gemini Recommendations
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore().postsStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                      final allPosts = Firestore().getPosts(snapshot, selectedFilters.toList());

                      List<Post> displayPosts;
                      if (showRecommendations && recommendedPostIds.isNotEmpty) {
                        final recommended = allPosts.where((post) => recommendedPostIds.contains(post.id)).toList();
                        final others = allPosts.where((post) => !recommendedPostIds.contains(post.id)).toList();
                        displayPosts = [...recommended, ...others];
                      } else {
                        displayPosts = allPosts;
                      }

                      if (showRecommendations && recommendedPostIds.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              "No recommended posts found. Try setting your preferences!",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }


                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        itemCount: displayPosts.length,
                        itemBuilder: (context, index) {
                          final post = displayPosts[index];
                          final isRecommended = recommendedPostIds.contains(post.id);
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
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                        child: Image.network(
                                          post.image,
                                          width: double.infinity,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      if (isRecommended)
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFC5C65),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: const Text("✨ Recommended", style: TextStyle(color: Colors.white, fontSize: 12)),
                                          ),
                                        ),
                                      // 🔥 People Joined count overlay
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: StreamBuilder<int>(
                                          stream: Firestore().joinedCountStream(post.id),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) return const SizedBox.shrink();
                                            final count = snapshot.data!;
                                            return Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.6),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "$count people joined!",
                                                style: const TextStyle(color: Colors.white, fontSize: 12),
                                              ),
                                            );
                                          },
                                        ),

                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(post.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            FutureBuilder(
                                              future: Firestore().getUserById(post.userId),
                                              builder: (context, snapshot) {
                                                final author = snapshot.data;
                                                if (author != null) {
                                                  return Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage: author.profilePicture != null
                                                            ? NetworkImage(author.profilePicture!)
                                                            : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(author.userName)
                                                    ],
                                                  );
                                                } else {
                                                  return const SizedBox.shrink();
                                                }
                                              },
                                            ),
                                            const Spacer(),
                                            Text("More>>", style: TextStyle(color: TColors.accent)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
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

  Future<void> callGeminiModel() async {
    final model = GenerativeModel(
      model: 'gemini-2.5-pro-exp-03-25',
      apiKey: 'AIzaSyBwmZTKKRECKZwT3SjyEzDsZF7Uk2yq_T0',
    );
    final postList = await Firestore().postList();
    final user = await Firestore().getMySelf();
    final postListJson = postList.map((post) => post.toMap()).toList();
    final preferenceJson = user.preferences;
    final prompt =
        "I have a list of posts in JSON format: $postListJson and my preference tags are $preferenceJson. Please recommend the posts that I like and output their ID in a list only";

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? "";
    final ids = RegExp(r'\w{20,}').allMatches(text).map((match) => match.group(0)!).toList();

    setState(() {
      recommendedPostIds = ids;
      showRecommendations = true;
    });

    print("🔮 Recommended Post IDs: $recommendedPostIds");
  }
}