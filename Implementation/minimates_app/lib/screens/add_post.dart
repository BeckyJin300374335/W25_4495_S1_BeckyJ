import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:untitled1/data/firestore.dart';
import 'package:untitled1/screens/google_map.dart';
import 'package:untitled1/screens/home.dart';
import '../utils/constants/colors.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:geocoding/geocoding.dart';

import 'bottom_nav_bar.dart';

class AddPost extends StatefulWidget {
  final bool showBackArrow;
  final LatLng? location;

  const AddPost({super.key, this.showBackArrow = false, this.location});
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final title = TextEditingController();
  final desc = TextEditingController();
  final address = TextEditingController();
  double? longitude;
  double? latitude;

  final picker = ImagePicker();
  FocusNode titleNode = FocusNode();
  FocusNode descNode = FocusNode();
  FocusNode addressNode = FocusNode();
  File? _selectedImage;
  Set<String> selectedFilters = {};

  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
  }

  showDateRangePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(const Duration(days: 3652)),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(const Duration(days: 3652)),
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
          opacity: anim1.drive(Tween(begin: 0, end: 1)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    if (dateTimeList != null && dateTimeList.length == 2) {
      setState(() {
        _startTime = dateTimeList[0];
        _endTime = dateTimeList[1];
      });
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'pm' : 'am'}';
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TColors.secondary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleInputField('Enter title...', TextInputType.text, title, 1, titleNode),
              const SizedBox(height: 20),
              _titleInputField('Enter description...', TextInputType.multiline, desc, 5, descNode),
              const SizedBox(height: 10),
              Row(
                children: [
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100, maxHeight: 200),
                child: _imageUploadWidget(),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: FutureBuilder(
                  future: Firestore().tagList(),
                  builder: (context, snapshot) {
                    final tagList = snapshot.data;
                    if (tagList != null) {
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: tagList.map((tag) {
                          final isSelected = selectedFilters.contains(tag.name);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selectedFilters.remove(tag.name)
                                    : selectedFilters.add(tag.name);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? TColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(30), // pill shape
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    tag.name,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(Icons.add,
                                      size: 16,
                                      color: isSelected ? Colors.white : Colors.black54),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) => GoogleMapFlutter()))
                        .then((location) {
                      longitude = location.longitude;
                      latitude = location.latitude;
                      placemarkFromCoordinates(latitude!, longitude!).then((placemarks) {
                        var output = 'No results found.';
                        if (placemarks.isNotEmpty) {
                          output = placemarks[0].toString();
                        }
                        setState(() {
                          address.text = output;
                        });
                      });
                      setState(() {
                        longitude = location.longitude;
                        latitude = location.latitude;
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFC5C65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  ),
                  child: Text("Set Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              _titleInputField('', TextInputType.streetAddress, address, 3, addressNode),
              const SizedBox(height: 10),
              _cancelPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleInputField(String hintText, TextInputType inputType, TextEditingController controller, int maxLines, FocusNode? node) {
    return TextField(
      maxLines: maxLines,
      controller: controller,
      focusNode: node,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  Widget _imageUploadWidget() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: (_selectedImage != null)
              ? Image.file(_selectedImage!, width: double.infinity, height: 200, fit: BoxFit.cover)
              : Image.asset('assets/images/upload_image.png', width: double.infinity, height: 200, fit: BoxFit.cover),
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
                color: Color(0xFFFC5C65),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
            ),
          ),
        )
      ],
    );
  }

  Widget _cancelPostButton() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                _showCancelDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                if (_selectedImage != null && _startTime != null && _endTime != null) {
                  Firestore().addPost(
                    title.text,
                    desc.text,
                    _selectedImage!,
                    selectedFilters.toList(),
                    latitude!,
                    longitude!,
                    address.text,
                    1,
                    _startTime!,
                    _endTime!,
                  );
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => BottomNavBar(),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.secondary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
              child: Text("Post", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
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
        title: Text("Upload a Picture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
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
      label: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
    );
  }

  void _takePhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
  }
}