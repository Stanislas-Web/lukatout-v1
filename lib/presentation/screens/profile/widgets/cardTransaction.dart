// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CardTransaction extends StatefulWidget {
  final String? title;
  final String? response;

  const CardTransaction({super.key, this.title, this.response});

  @override
  State<CardTransaction> createState() => _CardTransactionState();
}

class _CardTransactionState extends State<CardTransaction> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: Colors.white,
        // color: AdaptiveTheme.of(context).brightness,
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              // Text("icon"),
              Row(
                children: [
                                    SizedBox(
                    width: 10.0,
                  ),
                  Text(widget.title.toString(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),),
                  SizedBox(
                    width: 50.0,
                  ),
                  Text(widget.response.toString(), style: TextStyle(fontSize: 17),),

                
         
                ],
              ),
      
            ],
          ),

        ],
      ),
    );
  }
}
