// ignore_for_file: must_be_immutable, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/utils/string.util.dart';

class CardMenu extends StatefulWidget {
  String? content, date, title, icon, videoLink;
  List? images;
  CardMenu(
      {super.key,
      this.icon,
      this.title,
      this.content,
      this.images,
      this.date,
      this.videoLink});

  @override
  State<CardMenu> createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ActuDetailScreen(
        //               title: widget.title,
        //               content: widget.content,
        //               image: widget.icon,
        //               images: widget.images,
        //               date: widget.date,
        //               videoLink: widget.videoLink,
        //             )));
      },
      child: Ink(
        child: Stack(
          children: [
            // Le container avec l'image
            ImageViewerWidget(
              height: 500.0,
              width: 600.0,
              url: StringFormat.photoUrl(widget.icon.toString()),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(width: 5, color: Color(0xFFffa020)),
              // marginLeft: 20.0 ,
            ),
            // L'overlay dégradé
            Opacity(
              opacity: 1,
              child: Container(
                height: (500.0),
                width: (600.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(245, 15, 64, 101),
                      Colors.transparent
                    ],
                    stops: [0.2, 2.0],
                    end: Alignment.topCenter,
                    begin: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Container(
                height: 500.0,
                width: 600.0,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          StringFormat.addLineBreaks(widget.title.toString(), 30),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          StringFormat.truncateWithEllipsisAndSpacesWithoutPTags(
                              widget.content.toString(), 135),
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
