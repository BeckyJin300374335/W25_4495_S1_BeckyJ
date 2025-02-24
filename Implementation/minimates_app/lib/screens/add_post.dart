import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:untitled1/data/firestore.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPost();
}

class _AddPost extends State<AddPost> {
  final title = TextEditingController();
  final picker = ImagePicker();
  FocusNode node = FocusNode();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black), // Back button
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input Field
            _titleInputField(),

            const SizedBox(height: 20),

            // Image Upload Widget
            _imageUploadWidget(),

            const SizedBox(height: 20),

            // Post Button
            _postButton(),
          ],
        ),
      ),
    );
  }

  /// **Title Input Field**
  Widget _titleInputField() {
    return TextField(
      controller: title,
      focusNode: node,
      decoration: InputDecoration(
        hintText: 'Enter title...',
        hintStyle: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
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
            'assets/images/park1.jpg',
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
              showModalBottomSheet(
                  context: context, builder: ((builder) => _bottomSheet()));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFF9AFA6), // Matching theme color
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
  Widget _postButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_selectedImage != null) {
              Firestore().addPost(title.text, _selectedImage!);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF9AFA6), // Same color as login button
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            "Post",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  /// **Bottom Sheet for Image Selection**
  Widget _bottomSheet() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Upload a Picture",
            style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageSourceButton(Icons.camera, "Camera", ImageSource.camera),
              SizedBox(width: 20),
              _imageSourceButton(Icons.image, "Gallery", ImageSource.gallery),
            ],
          )
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
        style: TextStyle(fontSize: 16, fontFamily: 'Poppins', color: Colors.black),
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
