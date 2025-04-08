import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/screens/bottom_nav_bar.dart';
import 'package:untitled1/screens/google_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:untitled1/screens/my_posts.dart';
import '../utils/constants/colors.dart';

class EditPostPage extends StatefulWidget {
  final Post post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final address = TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();

  Set<String> selectedFilters = {};
  double? longitude;
  double? latitude;
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    title.text = widget.post.title;
    desc.text = widget.post.description;
    address.text = widget.post.address ?? '';
    longitude = widget.post.longitude ?? 0.0;
    latitude = widget.post.latitude ?? 0.0;
    selectedFilters = widget.post.tags.toSet();
    _startTime = widget.post.startTime;
    _endTime = widget.post.endTime;
  }

  Future<void> _updatePost() async {
    try {
      String imageUrl = widget.post.image;

      // ✅ Upload new image if selected
      if (_selectedImage != null) {
        final fileName = 'images/${widget.post.title}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = FirebaseStorage.instance.ref().child(fileName);
        final uploadTask = await ref.putFile(_selectedImage!);
        imageUrl = await uploadTask.ref.getDownloadURL();
      }

      // ✅ Update Firestore with new data (including image URL)
      await FirebaseFirestore.instance.collection('posts').doc(widget.post.id).update({
        'title': title.text,
        'description': desc.text,
        'tags': selectedFilters.toList(),
        'longitude': longitude,
        'latitude': latitude,
        'address': address.text,
        'start_time': _startTime,
        'end_time': _endTime,
        'image': imageUrl, // ✅ Store the updated image
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyPostsPage()));
    } catch (e) {
      print('❌ Error updating post: $e');
    }
  }


  Future<void> _pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.camera_alt),
              label: const Text("Camera"),
              onPressed: () async {
                Navigator.pop(context); // ✅ Close the dialog FIRST
                await _pickImage(ImageSource.camera);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Gallery"),
              onPressed: () async {
                Navigator.pop(context); // ✅ Close the dialog FIRST
                await _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickDateRange() async {
    final dates = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: _startTime ?? DateTime.now(),
      endInitialDate: _endTime ?? DateTime.now().add(const Duration(hours: 1)),
    );
    if (dates != null && dates.length == 2) {
      setState(() {
        _startTime = dates[0];
        _endTime = dates[1];
      });
    }
  }

  String formatDate(DateTime? dt) {
    if (dt == null) return "";
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Edit Post", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Enter title...", title, 1),
            const SizedBox(height: 16),
            _buildInputField("Enter description...", desc, 4),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _pickDateRange,
              icon: const Icon(Icons.access_time),
              label: Text(
                (_startTime != null && _endTime != null)
                    ? '${formatDate(_startTime)} - ${formatDate(_endTime)}'
                    : 'Please select the time:',
                style: const TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.grey[200]),
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (_selectedImage != null)
                      ? Image.file(_selectedImage!, height: 200, width: double.infinity, fit: BoxFit.cover)
                      : Image.network(widget.post.image, height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: const CircleAvatar(
                      backgroundColor: Color(0xFFFC5C65),
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder(
              future: Firestore().tagList(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final tags = snapshot.data!;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: tags.map((tag) {
                    final selected = selectedFilters.contains(tag.name);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected ? selectedFilters.remove(tag.name) : selectedFilters.add(tag.name);
                        });
                      },
                      child: Chip(
                        label: Text(tag.name),
                        backgroundColor: selected ? TColors.primary : Colors.grey[300],
                        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final picked = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => GoogleMapFlutter()),
                );
                if (picked != null) {
                  setState(() {
                    longitude = picked.longitude;
                    latitude = picked.latitude;
                  });
                  final placemarks = await placemarkFromCoordinates(latitude!, longitude!);
                  if (placemarks.isNotEmpty) {
                    address.text = placemarks[0].toString();
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFC5C65)),
              child: const Text("Set Location"),
            ),
            const SizedBox(height: 10),
            _buildInputField("Address", address, 2),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: TColors.accent),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updatePost,
                    style: ElevatedButton.styleFrom(backgroundColor: TColors.secondary),
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller, int maxLines) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
