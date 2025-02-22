
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:untitled1/data/firestore.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPost();
}
class _AddPost extends State<AddPost> {
  final title = TextEditingController();

  FocusNode node = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        title_widget(title, node),
        Row(children: [
          ElevatedButton(onPressed: (){
            Firestore().addPost(title.text);
            Navigator.pop(context);
          }, child: Text('Add Task')),
          ]),
        ])
    ));
  }
}

Widget title_widget(TextEditingController title,
    FocusNode node) {
  return Padding(padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(child: TextField(controller: title, focusNode: node, decoration: InputDecoration(
          hintText: 'title'
      ),),)
  );
}