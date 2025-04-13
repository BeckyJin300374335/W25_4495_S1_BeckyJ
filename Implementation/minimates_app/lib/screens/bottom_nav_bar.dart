import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/screens/profile.dart';
import '../auth/main_page.dart';
import 'add_post.dart';
import '../utils/constants/colors.dart';
import 'chats.dart';
import 'home.dart';
import 'my_events.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    // Main_Page(),       // Home (index 0)
    AddPost(showBackArrow: false), // Add Post (index 1)
    ProfileScreen(), // Profile (index 2)
    MyEventsPage(),
    ChatsPage(), // Schedule (index 3)
  ];

  void _onItemTapped(int index) {
    // Ensure no back arrow when accessed from BottomNavBar
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        _pages[3] = new MyEventsPage();
      }
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: StreamBuilder<User?>(
  //           stream: FirebaseAuth.instance.authStateChanges(),
  //           builder: (context, snapshot) {
  //             if (FirebaseAuth.instance.currentUser != null) {
  //               return new BottomNavBar();
  //               // return HomeScreen();
  //             } else {
  //               // return new BottomNavBar();
  //               return OnBoardingScreen();
  //             }
  //           }));
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: IndexedStack(
  //       index: _selectedIndex,
  //       children: _pages,
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _selectedIndex,
  //       onTap: _onItemTapped,
  //       type: BottomNavigationBarType.fixed,
  //       backgroundColor: TColors.white,
  //       selectedItemColor: TColors.accent,
  //       unselectedItemColor: Colors.grey,
  //       showSelectedLabels: true,
  //       showUnselectedLabels: true,
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home),
  //           label: 'Home',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.add_circle_outline),
  //           label: 'Add',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.person),
  //           label: 'Profile',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.calendar_today),
  //           label: 'MyEvents',
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.chat_bubble_outline),
  //           label: 'Chats',
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return IndexedStack(
              index: _selectedIndex,
              children: _pages,
            );
          }),

      // body: IndexedStack(
      //   index: _selectedIndex,
      //   children: _pages,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TColors.white,
        selectedItemColor: TColors.accent,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'MyEvents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
