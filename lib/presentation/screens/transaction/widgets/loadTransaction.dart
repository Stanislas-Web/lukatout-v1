import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';

// ignore: must_be_immutable
class loadTransaction extends StatefulWidget {
  String? icon;
  String? title;
  String? amount;
  String? date;
  loadTransaction({super.key, this.icon, this.title});

  @override
  State<loadTransaction> createState() => _loadTransactionState();
}

class _loadTransactionState extends State<loadTransaction> {
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
          ImageViewerWidget(
            url: "",
            height: 70,
            width: 70,
            borderRadius: BorderRadius.circular(50.0),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageViewerWidget(
                url: "",
                height: 10,
                width: 150,
                borderRadius: BorderRadius.circular(50.0),
              ),
              SizedBox(
                height: 10,
              ),
              ImageViewerWidget(
                url: "",
                height: 10,
                width: 150,
                borderRadius: BorderRadius.circular(50.0),
              ),
              SizedBox(height: 10),
              ImageViewerWidget(
                url: "",
                height: 10,
                width: 150,
                borderRadius: BorderRadius.circular(50.0),
              ),
            ],
          )
        ],
      ),
    );
  }
}
