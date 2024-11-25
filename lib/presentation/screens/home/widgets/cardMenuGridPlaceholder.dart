import 'package:flutter/material.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/utils/string.util.dart';

class CardMenuGridPlaceholder extends StatefulWidget {
  const CardMenuGridPlaceholder({
    super.key,
  });

  @override
  State<CardMenuGridPlaceholder> createState() =>
      _CardMenuGridPlaceholderState();
}

class _CardMenuGridPlaceholderState extends State<CardMenuGridPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.only(left: 5.0),
        margin: EdgeInsets.only(left: 15, bottom: 10, right: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100,
              offset: Offset(0, 3),
              blurRadius: 10,
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            width: 2,
            color: Color(0xFFffa020).withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Row(
              children: [
                ImageViewerWidget(
                  height: 70.0,
                  width: 70.0,
                  url: "",
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    width: 2,
                    color: Color(0xFFffa020),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: MediaQuery.of(context).size.width -120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageViewerWidget(
                        height: 10.0,
                        width: MediaQuery.of(context).size.width - 100,
                        url: "",
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 2,
                          color: Color(0xFFffa020),
                        ),
                      ),
                      SizedBox(height: 10),
                      ImageViewerWidget(
                        height: 10.0,
                        width: MediaQuery.of(context).size.width-100,
                        url: "",
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 2,
                          color: Color(0xFFffa020),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
