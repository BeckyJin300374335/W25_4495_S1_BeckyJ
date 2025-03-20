import 'dart:io';

import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/firestore.dart';
import '../utils/constants/colors.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController(text: 'Becky Jin');
  final TextEditingController _ageController = TextEditingController(text: '30');
  final TextEditingController _cityController = TextEditingController(text: 'Becky');
  final TextEditingController _emailController = TextEditingController(text: 'beckyjin873@email.com');

  final picker = ImagePicker();
  File? _selectedImage;
  String _selectedGender = 'Female';
  List<String> _genderOptions = ['Male', 'Female', 'Other'];

  List<String> _bcCities = [
    'Abbotsford', 'Burnaby', 'Campbell River', 'Chilliwack', 'Coquitlam',
    'Courtenay', 'Cranbrook', 'Delta', 'Duncan', 'Fort St. John',
    'Kamloops', 'Kelowna', 'Langford', 'Langley', 'Maple Ridge',
    'Nanaimo', 'New Westminster', 'North Vancouver', 'Penticton', 'Port Coquitlam',
    'Port Moody', 'Prince George', 'Richmond', 'Saanich', 'Terrace',
    'Trail', 'Vancouver', 'Vernon', 'Victoria', 'West Kelowna',
    'West Vancouver', 'Whistler', 'White Rock'
  ];

  String _selectedCity = 'Vancouver';

  final List<String> _ageGroups = [
    'Toddlers (0 - 2 years)',
    'Kids (3 - 12 years)',
    'Teens (13 - 18 years)',
  ];

  String _selectedAgeGroup = 'Toddlers (0 - 2 years)';

  final Firestore _firestore = Firestore();


  // ✅ Load user profile when the screen opens
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userData = await _firestore.getUserProfile();
    if (userData != null) {
      setState(() {
        _usernameController.text = userData['userName'] ?? '';
        _ageController.text = userData['age'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _selectedGender = userData['gender'] ?? 'Female';
        _selectedCity = userData['city'] ?? 'Vancouver';
      });
    }
  }

  Future<void> _saveProfile() async {
    String? profilePictureUrl;

    if (_selectedImage != null) {
      profilePictureUrl = await _firestore.uploadProfilePicture(_selectedImage!);
    }

    await _firestore.updateUserProfile(
      userName: _usernameController.text,
      email: _emailController.text,
      age: _ageController.text,
      gender: _selectedGender,
      city: _selectedCity,
    );

    if (profilePictureUrl != null) {
      print('Profile picture uploaded: $profilePictureUrl');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );

    if (context.mounted) {
      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: TColors.secondary,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageUploadWidget(),
            SizedBox(height: 20),
            _buildTextField('Username', _usernameController),
            _buildTextField('Age', _ageController, keyboardType: TextInputType.number),
            _buildDropdownField('Gender', _selectedGender, _genderOptions, (String? newValue) {
              setState(() {
                _selectedGender = newValue!;
              });
            }),
            _buildCityPicker(),
            _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveProfile();
                  // if (context.mounted) {
                  //   Navigator.pop(context);
                  // }// Close the screen after saving
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **City Picker**
  Widget _buildCityPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedCity,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCity = newValue!;
              });
            },
            items: _bcCities.map((String city) {
              return DropdownMenuItem<String>(
                value: city,
                child: Text(city),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _imageUploadWidget() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.grey[300],
            backgroundImage: _selectedImage != null
                ? FileImage(_selectedImage!) as ImageProvider
                : AssetImage('assets/images/upload_image.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
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
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Upload a Picture",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.black),
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

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            onChanged: onChanged,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
