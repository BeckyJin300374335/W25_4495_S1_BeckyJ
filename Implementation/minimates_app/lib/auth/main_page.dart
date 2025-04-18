import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:untitled1/auth/auth_page.dart';
import 'package:untitled1/onboarding/onboarding.dart';
import 'package:untitled1/screens/home.dart';
import 'package:untitled1/screens/login.dart';
import 'package:untitled1/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/bottom_nav_bar.dart';

class Main_Page extends StatelessWidget {
  const Main_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // return new BottomNavBar();
              if (FirebaseAuth.instance.currentUser != null) {
                return new BottomNavBar();
                // return HomeScreen();
              } else {
                // return new BottomNavBar();
                // return OnBoardingScreen();
                return new Auth_Page();
              }
            }));
  }
}
