import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/qrcode/qrcodeV2.dart';
import 'package:lukatout/presentation/screens/qrcode/widgets/qrcode.widget.dart';
import 'package:lukatout/presentation/widgets/caroussel.dart';
import 'package:lukatout/theme.dart';

import 'widgets/cardMenu.dart';
import 'widgets/cardNumberCourse.dart';

class QrCodeScreen extends StatefulWidget {
  bool backNavigation;
  QrCodeScreen({Key? key, required this.backNavigation}) : super(key: key);

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> {
  String? codeStudent = '';
  var test;

  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeStudent();
  }

  getCodeStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      codeStudent = prefs.getString('code');
    });
    print(prefs.getString('code'));
  }

  // var image = Image.asset();
  @override
  Widget build(BuildContext context) {
    test = codeStudent;
    return Scaffold(
        // backgroundColor: Colors.grey.withOpacity(0.1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // brightness: Brightness.light,
          leading: widget.backNavigation == false
              ? null
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AdaptiveTheme.of(context).mode.name != "dark"
                        ? Colors.black
                        : Colors.white,
                  )),
          title: Text(
            "Vote",
            style: TextStyle(
              fontSize: 14,
              color: AdaptiveTheme.of(context).mode.name != "dark"
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Theme.of(context).bottomAppBarColor,
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          // color: Colors.grey.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
       
             SizedBox(
                height: 80.0,
              ),
              Text("En Développement")
              // BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
              //   var qrValue = codeStudent;
              //   return Container(
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.all(10.0),
              //     width: MediaQuery.of(context).size.width,
              //     height: 400.0,
              //     decoration: BoxDecoration(
              //         // color: Colors.white,
              //         color: Theme.of(context).accentColor,
              //         borderRadius: BorderRadius.circular(20.0)),
              //         child: QrCodeScreenV2(backNavigation: true,),
              //   );
              // }),
            ],
          ),
        ),
      ),
    ));
  }
}
