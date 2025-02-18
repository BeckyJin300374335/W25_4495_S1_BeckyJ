import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/data/auth_data.dart';
import 'package:untitled1/utils/constants/colors.dart';
import 'package:untitled1/utils/constants/sizes.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();

  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();

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
    _focusNode3.addListener(() {
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
            SizedBox(
              height: 50,
            ),
            textfield_email(email, _focusNode1, 'Email', Icons.email),
            SizedBox(
              height: 10,
            ),
            textfield_email(password, _focusNode2, 'Password', Icons.password),
            SizedBox(
              height: 10,
            ),
            textfield_email(passwordConfirm, _focusNode3,
                'PasswordConfirmation', Icons.password),
            SizedBox(
              height: 10,
            ),
            account(),
            Signup_bottom()
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
            "Do you have an account?",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              "Login",
              style: TextStyle(color: Colors.blue, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget Signup_bottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: GestureDetector(
        onTap: () {
          AuthenticationRemote()
              .register(email.text, password.text, passwordConfirm.text);
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(10)),
          child: Text(
            'Sign Up',
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
                  borderSide: BorderSide(color: TColors.primary, width: 2.0))),
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
                  image: AssetImage('assets/images/login.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
