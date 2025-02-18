import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../consts/consts.dart';
import 'package:untitled1/onboarding/onboarding_controller.dart';
import 'package:untitled1/utils/constants/sizes.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/image_strings.dart';
import '../utils/constants/text_strings.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  late File _file;
  var selectedCategoryId;
  var titleTec = TextEditingController();
  var descTec = TextEditingController();
  pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: NeumorphicAppBar(
          title: Text('NewPost'),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            NeumorphicButton(
              onPressed: pickImage,
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 8,
                lightSource: LightSource.topLeft,
              ),
              child: Container(
                height: 200,
                child: _file != null
                    ? Image.file(
                        _file,
                        fit: BoxFit.cover,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Upload\nPhoto",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                lightSource: LightSource.topLeft,
//                    color: Colors.grey
              ),
              child: TextField(
                controller: titleTec,
                decoration: InputDecoration(
                    hintText: "Enter title",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                lightSource: LightSource.topLeft,
//                    color: Colors.grey
              ),
              child: TextField(
                controller: descTec,
                decoration: InputDecoration(
                    hintText: "Enter Description",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 10, top: 10, bottom: 10)),
                minLines: 4,
                maxLines: 4,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: -4,
                lightSource: LightSource.topLeft,
//                    color: Colors.grey
              ),
              // child: DropdownButtonFormField<int>(
              //   onChanged: (i) {
              //     selectedCategoryId = i;
              //   },
              //   items: filterOptions.map((option) {
              //     return DropdownMenuItem(
              //       child: Text(option),
              //       value: option,
              //     );
              //   }).toList(),
              //   decoration: InputDecoration(
              //       hintText: "Select Category",
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.only(left: 10)),
              // ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
}
