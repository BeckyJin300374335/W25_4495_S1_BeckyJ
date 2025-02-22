// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/post_widget.dart';
import 'package:untitled1/screens/add_post.dart';
import 'package:untitled1/data/firestore.dart';
import '../consts/consts.dart';
import 'package:untitled1/onboarding/onboarding_controller.dart';
import 'package:untitled1/utils/constants/sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import 'package:untitled1/data/auth_data.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFCF5F3)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> filterOptions = ['park', 'painting', 'hiking', 'sports', 'dancing'];
  List<String> name = [
    'Playing at Confederation Park?',
    'Soccer time!!!',
    'Come on! Tennis with us?'
  ];
  List<String> image = [
    'assets/images/park1.jpg',
    'assets/images/park2.jpg',
    'assets/images/park3.jpg'
  ];

  Set<String> selectedFilters = {};

  bool isLiked = false;

  bool isGoing = false; // Track the state of the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        color: Color(0xFFFCF5F3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/MiniMates_color.png', // Replace with your actual image path
              height: 30, // Adjust size as needed
              fit: BoxFit.contain,
            ),
          ],
        ),
        leading: NeumorphicButton(
          style: NeumorphicStyle(
            color: Color(0xFFF9AFA6), // 🔹 Change background color here
          ),
          child: Icon(Icons.person,color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          NeumorphicButton(
            style: NeumorphicStyle(
              color: Color(0xFFF9AFA6), // 🔹 Change background color here
            ),
            child: Icon(Icons.add,color: Colors.white),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return AddPost();
              }));
              // .then((b) {
              //   if (b != null) {
              //     if (b) {
              //       _bloc.getBlog();
              //     }
              //   }
              // });
            },
          )
        ],
      ),
      body: Container(
        color: Color(0xFFFCF5F3),
        child: StreamBuilder<QuerySnapshot>(stream: Firestore().stream(), builder: (context, snapshot) {
            if (!snapshot.hasData) {
            return CircularProgressIndicator();
            }
            final postList = Firestore().getPosts(snapshot);
            return ListView.builder(
            itemCount: postList.length,
            itemBuilder: (context, index) {
            return PostWidget(postList[index]);
            });
        }


        // child: Column(
        //   children: [
        //     SizedBox(
        //       height: 50,
        //       child: ListView(
        //         scrollDirection: Axis.horizontal,
        //         children: filterOptions
        //             .map((option) => NeumorphicButton(
        //                   margin: EdgeInsets.only(right: 10, bottom: 5),
        //                   onPressed: () {
        //                     setState(() {
        //                       selectedFilters.contains(option)
        //                           ? selectedFilters.remove(option)
        //                           : selectedFilters.add(option);
        //                     });
        //                   },
        //                   child: Center(child: Text(option)),
        //                   style: NeumorphicStyle(
        //                     shape: NeumorphicShape.flat,
        //                     boxShape: NeumorphicBoxShape.roundRect(
        //                         BorderRadius.circular(10)),
        //                     depth: 8,
        //                   ),
        //                 ))
        //             .toList(),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(15),
        //     ),
        //
        //     StreamBuilder<QuerySnapshot>(stream: Firestore().stream(), builder: (context, snapshot) {
        //       if (!snapshot.hasData) {
        //         return ListView.builder(
        //                 itemCount: name.length,
        //                 itemBuilder: (context, index) {
        //                   return PostWidget();
        //                 });
        //       }
        //       final postList = Firestore().getPosts(snapshot);
        //       return ListView.builder(
        //           itemCount: postList.length,
        //           itemBuilder: (context, index) {
        //             return PostWidget();
        //           });
        //
        //     })
        //
        //     // Expanded(
        //     //   // height: MediaQuery.of(context).size.height,
        //     //   child: ListView.builder(
        //     //       itemCount: name.length,
        //     //       itemBuilder: (context, index) {
        //     //         return PostWidget();
        //     //       }),
        //     // )
        //   ],
        ),
      ),
    );
  }

  Widget signout_bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationRemote().logout();
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Logout',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
