import 'package:flutter/material.dart';
import 'package:lukatout/theme.dart';

class CardStatWidget extends StatefulWidget {
  final String? number;
  final String? type;
  final String? total;
  final String? title;
  const CardStatWidget(
      {super.key, this.number, this.type, this.total, this.title});

  @override
  State<CardStatWidget> createState() => _CardStatWidgetState();
}

class _CardStatWidgetState extends State<CardStatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      constraints: BoxConstraints(
        minWidth: 100.0, // Largeur minimale de 100 pixels
      ),
      // height: 50,
      // width: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: widget.type == "error"
                  ? ftRed
                  : widget.type == "success"
                      ? primaryColor
                      : ftOrange,
              width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.shade100,
                offset: Offset(0, 3),
                blurRadius: 10)
          ]),
      child: Column(
        children: [
          Text(
            widget.title.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text("${widget.number.toString()}"),
        ],
      ),
    );
  }
}
