// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/screens/upload.dart';
import '../consts/consts.dart';
import 'package:untitled1/onboarding/onboarding_controller.dart';
import 'package:untitled1/utils/constants/sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import 'package:untitled1/data/auth_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NeumorphicAppBar(
          title: Text('Playdate'),
          leading: NeumorphicButton(
            child: Icon(Icons.person),
            onPressed: () {},
          ),
          actions: [
            NeumorphicButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return UploadPage();
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
        body: ListView(
          children: [
            Container(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: filterOptions
                    .map((option) => NeumorphicButton(
                          margin: EdgeInsets.only(right: 10, bottom: 5),
                          onPressed: () {
                            AuthenticationRemote().logout();
                          },
                          child: Center(child: Text(option)),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(10)),
                            depth: 8,
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        )
        // body: Column(children: [
        //   signout_bottom(),
        //   signout_bottom(),
        //   signout_bottom(),
        //   signout_bottom()
        // ])
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
