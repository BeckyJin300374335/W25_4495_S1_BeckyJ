import 'package:flutter/material.dart';
import 'package:untitled1/auth/main_page.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:untitled1/utils/constants/colors.dart';
import 'package:untitled1/utils/constants/sizes.dart';

import 'bottom_nav_bar.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode1.addListener(() {
      setState(() {});
    });
    _focusNode2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            image(context),

            textfield_email(email, _focusNode1, 'Email', Icons.email),
            SizedBox(
              height: 20,
            ),
            textfield_email(password, _focusNode2, 'Password', Icons.password),
            SizedBox(
              height: 20,
            ),
            account(),
            SizedBox(height: 20),
            Login_bottom()
          ],
        ),
      )),
    );
  }

  Widget account() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Signup ",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  Widget Login_bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationRemote().login(email.text, password.text);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Main_Page(),
          ));
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: TColors.secondary, borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget textfield_email(TextEditingController _controller,
      FocusNode _focusNode, String typeName, IconData iconss) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          style: TextStyle(fontSize: TSizes.fontSizeMd, color: Colors.black),
          decoration: InputDecoration(
              prefixIcon: Icon(
                iconss,
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: typeName,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: TColors.secondary, width: 2.0))),
        ),
      ),
    );
  }

  Widget image(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/fingerprint.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
