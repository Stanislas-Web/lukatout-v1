import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/signup/signup.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';

// ignore: must_be_immutable
class CardNotification extends StatefulWidget {
  dynamic notifications;
  CardNotification({super.key, required this.notifications});

  @override
  State<CardNotification> createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {
  var amount, amountNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.all(10.0),
      height: 100,
      width: MediaQuery.of(context).size.width,
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage("assets/icons/ft.png")),
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(width: 2, color: Color(0xFFffa020))),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.notifications["title"], style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              Container(width:MediaQuery.of(context).size.width /2 + 50,child: Text(widget.notifications["content"], maxLines: 3, style: TextStyle(fontSize: 11),)),
              SizedBox(height: 10),
            ],
          )
        ],
      ),
    );
  }
}
