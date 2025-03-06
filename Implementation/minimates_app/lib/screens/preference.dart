import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';

class PreferenceSelectionPage extends StatefulWidget {
  const PreferenceSelectionPage({super.key});

  @override
  State<PreferenceSelectionPage> createState() => _PreferenceSelectionPageState();
}

class _PreferenceSelectionPageState extends State<PreferenceSelectionPage> {
  final List<Map<String, dynamic>> preferences = [
    {"name": "🎨 Creative", "size": 100.0, "color": TColors.secondary},
    {"name": "⚽ Active", "size": 90.0, "color": TColors.primary},
    {"name": "🌳 Outdoor", "size": 160.0, "color": TColors.secondary},
    {"name": "🏠 Indoor", "size": 180.0, "color": TColors.primary},
    {"name": "🧪 Learning", "size": 120.0, "color": TColors.secondary},
    {"name": "🎮 Gaming", "size": 140.0, "color": TColors.secondary},
    {"name": "🥳 Events", "size": 130.0, "color": TColors.primary},
    {"name": "👶 Toddlers", "size": 120.0, "color": TColors.primary},
    {"name": "🧒 Kids", "size": 100.0, "color": TColors.secondary},
    {"name": "🎟️ Free", "size": 90.0, "color": TColors.secondary},
  ];

  final List<Offset> positions = [
    const Offset(80, 200),
    const Offset(300 , 200),
    const Offset(230, 400),
    const Offset(20, 320),
    const Offset(180, 130),
    const Offset(190, 260),
    const Offset(50, 580),
    const Offset(200, 570),
    const Offset(130, 490),
    const Offset(30, 120),
  ];

  final List<String> selectedPreferences = [];

  void togglePreference(int index) {
    setState(() {
      String preferenceName = preferences[index]["name"];
      if (selectedPreferences.contains(preferenceName)) {
        selectedPreferences.remove(preferenceName);
        preferences[index]["color"] = getOriginalColor(preferenceName);
      } else {
        selectedPreferences.add(preferenceName);
        preferences[index]["color"] = TColors.accent;
      }
    });
  }

  Color getOriginalColor(String preferenceName) {
    return {
      "🎨 Creative": Colors.blue,
      "⚽ Active": Colors.green,
      "🌳 Outdoor": Colors.orange,
      "🏠 Indoor": Colors.purple,
      "🧪 Learning": Colors.red,
      "🎮 Gaming": Colors.teal,
      "🥳 Events": TColors.primary,
      "👶 Toddlers": Colors.pink,
      "🧒 Kids": Colors.cyan,
      "🎟️ Free": TColors.secondary,
    }[preferenceName] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Preferences'), backgroundColor: TColors.secondary,),
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Welcome to your MiniMates"),
                    ),
                    Text("What do you Prefer?", style: TextStyle(fontSize: 30,fontWeight:FontWeight.bold),),
                  ]
              )
            ],
          ),
          ...List.generate(preferences.length, (index) {
            double size = preferences[index]["size"] ?? 100.0;

            return Positioned(
              left: positions[index].dx,
              top: positions[index].dy,
              child: GestureDetector(
                onTap: () => togglePreference(index),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: preferences[index]["color"],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    preferences[index]["name"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            );
          }),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
