
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:untitled1/data/data.dart';


class PostWidget extends StatefulWidget {
  final Post _post;
  const PostWidget(this._post, {super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}
class _PostWidgetState extends State<PostWidget> {


  @override
  Widget build(BuildContext context) {
    return Card(

          margin: EdgeInsets.all(15),
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => AttractionDetail(attractionsDataModel:attractionData[index])));
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                      15), // ✅ Rounded top left corner
                  topRight: Radius.circular(
                      15), // ✅ Rounded top right corner
                ),
                child: Image.network(
                  widget._post.image,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top:8.0, left: 8),
                    child: Text(widget._post.title),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    // Like Button
                    GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   isLiked = !isLiked;
                        // });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(
                              128), // Button background
                          shape:
                          BoxShape.circle, // Circular shape
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                  25), // Shadow effect
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            // isLiked
                            //     ? Icons.favorite
                            //     : Icons.favorite_border,
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Going Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // isGoing =
                          // !isGoing; // Toggle the state
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 60, // Adjust width
                        height: 30, // Adjust height
                        decoration: BoxDecoration(
                          color: Colors.green,

                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 5),
                        child: Stack(
                          children: [
                            // Text (No / Going)
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Text(
                                  "Go",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),

                            // Circular switch
                            AnimatedAlign(
                              duration: Duration(milliseconds: 300),
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 20, // Circle button size
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white, // Circle color
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));

  }
}