import 'package:flutter/material.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF5F3),
        centerTitle: true,
        title: Image.asset(
          'assets/logos/MiniMates_color.png',
          height: 30,
        ),
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                Text(
                  'Minimates App Policy',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFC5C65),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  '1. Data Privacy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'We collect limited data including profile information, preferences, and posts. Your data is used solely to enhance your experience on Minimates and is never shared with third parties.',
                ),

                SizedBox(height: 16),
                Text(
                  '2. Content Guidelines',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Users must share respectful, appropriate content. Any harmful or offensive behavior will result in content removal or account suspension.',
                ),

                SizedBox(height: 16),
                Text(
                  '3. Child Safety',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Minimates is designed with family-friendly features. We prioritize safety in all aspects of the app including chat, posts, and activities.',
                ),

                SizedBox(height: 16),
                Text(
                  '4. Activity Participation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'By joining an activity, you agree to share your interest with the organizer. You can cancel your participation at any time.',
                ),

                SizedBox(height: 16),
                Text(
                  '5. Contact Us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'For questions or support, reach out to us at support@minimates.app.',
                ),
              ],
            ),
          ),

          // Footer with Logo
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Text("Made with ❤️ for families"),
                const SizedBox(height: 10),
                Image.asset(
                  'assets/logos/logo_small.png',
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
