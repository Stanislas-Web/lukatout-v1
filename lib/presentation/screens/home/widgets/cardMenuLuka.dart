// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lukatout/theme.dart';

class CardMenuLuka extends StatefulWidget {
  String? icon;
  String? title;
  bool? active, isNotShadow;
  CardMenuLuka({super.key, this.icon, this.title, required this.active, this.isNotShadow});

  @override
  State<CardMenuLuka> createState() => _CardMenuLukaState();
}

class _CardMenuLukaState extends State<CardMenuLuka> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: widget.isNotShadow == true?[]: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Material(
          color: Colors.transparent,
          child:
              widget.active == true ? _buildActiveCard() : _buildInactiveCard(),
        ),
      ),
    );
  }

  Widget _buildActiveCard() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color:  Colors.white,
        border: Border.all(
            width: 1,
            color:  Colors.white
             ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.icon.toString(),
            width: 40,
            // color: Colors.redAccent,
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.title.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInactiveCard() {
    return Container(
      height: 120.0,
      width: 120.0,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.icon.toString(),
            width: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.title.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
    );
  }
}
