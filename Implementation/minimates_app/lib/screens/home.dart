import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/onboarding/onboarding_controller.dart';
import 'package:untitled1/utils/constants/sizes.dart';

import '../utils/constants/colors.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import 'package:untitled1/data/auth_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Signout_bottom(),
      Signout_bottom(),
      Signout_bottom(),
      Signout_bottom()
    ]));
  }

  Widget Signout_bottom() {
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
