import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/screens/home.dart';
import '../utils/constants/colors.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import 'bottom_nav_bar.dart';


class AddPost extends StatefulWidget {
  final bool showBackArrow;

  const AddPost({super.key, this.showBackArrow = false});
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final picker = ImagePicker();
  FocusNode titleNode = FocusNode();
  FocusNode descNode = FocusNode();
  File? _selectedImage;
  Set<String> selectedFilters = {};

  DateTime? _startTime;
  DateTime? _endTime;

  showDateRangePicker() async {
    List<DateTime>? dateTimeList =
        await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate:
      DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate:
      DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,);
      // Handle the selected dates here
    // **Update UI with selected date & time**
    if (dateTimeList != null && dateTimeList.length == 2) {
      setState(() {
        _startTime = dateTimeList[0];
        _endTime = dateTimeList[1];
      });
    }
  }

  /// **Format Date/Time for Display**
  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'pm' : 'am'}';
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
        content: Text("Discard this post?", style: TextStyle(color: TColors.accent, fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: TextStyle(color: TColors.accent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);

              // Handle cancellation logic here
            },
            child: Text("Yes", style: TextStyle(color: TColors.accent)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      leading: widget.showBackArrow
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),

        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,
      title: const Text(
          'Create Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input Field
              _titleInputField('Enter title...', TextInputType.text, title, 1, titleNode),
              const SizedBox(height: 20),
              _titleInputField(
                  'Enter description...', TextInputType.multiline, desc, 5, descNode),
              const SizedBox(height: 10),
              // **Duration Picker Row**
              Row(
                children: [
                  // **Time Icon & Duration Button**
                  TextButton.icon(
                    onPressed: () {
                      showDateRangePicker();
                    },
                    icon: Icon(Icons.access_time, color: Colors.black),
                    label: Text(
                      (_startTime == null || _endTime == null)
                          ? "Please select the time:"
                          : "${formatDateTime(_startTime)} - ${formatDateTime(_endTime)}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              // Image Upload Widget
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 100,
                  maxHeight: 200, // ✅ Define height to avoid size conflict
                ),
                child: _imageUploadWidget(),
              ),

              const SizedBox(height: 20),
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
                                selectedFilters
                                    .contains(tag.name)
                                    ? selectedFilters
                                    .remove(tag.name)
                                    : selectedFilters
                                    .add(tag.name);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5),
                              decoration: BoxDecoration(
                                color:
                                selectedFilters.contains(tag.name)
                                    ? TColors.secondary
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
              const SizedBox(height: 20),
              // Post Button
              _cancelPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// **Title Input Field**
  Widget _titleInputField(String hintText, TextInputType inputType,
      TextEditingController controller, int maxLines, FocusNode node) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      focusNode: node,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  /// **Image Upload Widget**
  Widget _imageUploadWidget() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: (_selectedImage != null)
              ? Image.file(
                  _selectedImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/upload_image.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              _showImageSourceDialog();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: TColors.secondary, // Matching theme color
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        )
      ],
    );
  }

  /// **Post Button**
  Widget _cancelPostButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              child: ElevatedButton(
                onPressed: (){
                  _showCancelDialog();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              )
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                if (_selectedImage != null) {
                  Firestore().addPost(title.text, desc.text, _selectedImage!, selectedFilters.toList());
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavBar(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Bottom Sheet for Image Selection**
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Upload a Picture",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _imageSourceButton(Icons.camera, "Camera", ImageSource.camera),
            SizedBox(height: 15),
            _imageSourceButton(Icons.image, "Gallery", ImageSource.gallery),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: TColors.secondary, fontSize: 16)),
          ),
        ],
      ),
    );
  }



  /// **Image Source Selection Button**
  Widget _imageSourceButton(IconData icon, String label, ImageSource source) {
    return TextButton.icon(
      icon: Icon(icon, color: Colors.black),
      onPressed: () {
        _takePhoto(source);
      },
      label: Text(
        label,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  /// **Pick Image from Camera/Gallery**
  void _takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
    Navigator.pop(context); // Close bottom sheet after selecting image
  }
}
