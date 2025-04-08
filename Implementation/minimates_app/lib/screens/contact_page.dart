import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF5F3),
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          'assets/logos/MiniMates_color.png',
          height: 30,
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: const [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFC5C65),
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  'We love hearing from our community! Whether you have a question, feedback, or an idea to share — don’t hesitate to reach out.',
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(height: 16),

                Text(
                  '📧 Email:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('support@minimates.app'),
                SizedBox(height: 12),

                Text(
                  '📱 Instagram:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('@minimates.app'),
                SizedBox(height: 12),

                Text(
                  '🌐 Website:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('https://www.minimates.app'),
                SizedBox(height: 12),

                Text(
                  '🕒 Hours of Operation:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Mon–Fri, 9am–5pm (PST)'),
              ],
            ),
          ),

          // Footer Logo
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                const Text("Let's stay connected ❤️!"),
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
