import 'dart:math';
import 'package:flutter/material.dart';
import '../data/firestore.dart';
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
    const Offset(70, 120), //creative
    const Offset(300 , 50),//active
    const Offset(230, 200),//outdoor
    const Offset(30, 240),//indoor
    const Offset(180, 80),//learning
    const Offset(190, 360),//gaming
    const Offset(10, 420),//event
    const Offset(250, 520),//toddlers
    const Offset(130, 500),//kids
    const Offset(30, 10), //free
  ];



  final List<String> selectedPreferences = [];

  final ScrollController _scrollController = ScrollController();

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

  @override
  void initState() {
    super.initState();

    // Wait until layout is built, then scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
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
      appBar: AppBar(
        title: const Text('Select Preferences'),
        backgroundColor: TColors.primary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text("Welcome to your MiniMates"),
          const Text(
            "What do you Prefer?",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
      Container(
        alignment: Alignment.topCenter, // 🔥 pushes up tightly
       // optional tiny padding
        child: SizedBox(
                  width: 400,  // Width based on your bubble layout
                  height: MediaQuery.of(context).size.height * 0.7, // Height based on your bubble layout
                  child: Stack(
                    children: List.generate(preferences.length, (index) {
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
                  ),
                ),
      ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: () async {
                  print("🟡 OK button pressed");
                  await Firestore().savePreferences(selectedPreferences);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preferences saved successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),

    );
  }

}
