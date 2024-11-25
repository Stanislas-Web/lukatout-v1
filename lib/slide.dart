import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/login/login_screen.dart';
import 'package:lukatout/presentation/screens/signup/signup-step1.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lukatout/routestack.dart';
import 'package:lukatout/theme.dart';

class ItemData {
  final Color color;
  final String image;
  final String text1;
  final String text2;
  final String text3;

  ItemData(this.color, this.image, this.text1, this.text2, this.text3);
}

/// Example of LiquidSwipe with itemBuilder
class SlideScreen extends StatefulWidget {
  @override
  _SlideScreen createState() => _SlideScreen();
}

class _SlideScreen extends State<SlideScreen> {
  int page = 0;
  late LiquidController liquidController;
  late UpdateType updateType;
  bool isIpad = false;
  String modelDevice = '';
  String deviceVersion = '';
  String iosId = '';
  String nameDevice = '';

  List<ItemData> data = [
    ItemData(Colors.transparent, "assets/images/splashlukatout.png", "Hi", "It's Me",
        "Sahdeep"),
    ItemData(Colors.transparent, "assets/images/splashlukatout.png", "Liked?",
        "Fork!", "Sahdeep")
  ];

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  load() async {
   Map response = await SignUpRepository.loginApi();
   print(response);
  }

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Container(
          width: 8.0 * zoom,
          height: 8.0 * zoom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LiquidSwipe.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                color: data[index].color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      data[index].image,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox.shrink(),
                  ],
                ),
              );
            },
            // positionSlideIcon: 0.8,
            // slideIconWidget: Icon(
            //   Icons.arrow_back_ios,
            //   color: ftBlue,
            // ),
            onPageChangeCallback: pageChangeCallback,
            waveType: WaveType.liquidReveal,
            liquidController: liquidController,
            fullTransitionValue: 880,
            enableSideReveal: true,
            preferDragFromRevealedArea: true,
            enableLoop: true,
            ignoreUserGestureWhileAnimating: true,
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(data.length, _buildDot),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: TextButton(
                onPressed: () {
                  if (page == 1) {
                 Navigator.of(context).pushNamedAndRemoveUntil(
                            '/home', (Route<dynamic> route) => false);
                       
                  } else {
                    load();
                    liquidController.jumpToPage(
                        page: liquidController.currentPage + 1 > data.length - 1
                            ? 0
                            : liquidController.currentPage + 1);
                    load();
                  }
                },
                child: page == 1
                    ? Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width / 2 + 20,
                        decoration: BoxDecoration(
                            color: ftPrimary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Lancer",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ))
                    : Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width / 2 + 20,
                        decoration: BoxDecoration(
                            color: ftPrimary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          "Suivant",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.01),
                    foregroundColor: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }
}

///Example of App with LiquidSwipe by providing list of widgets



// class SlideScreen extends StatelessWidget {
//   final Color kDarkBlueColor = const Color(0xFF204f97);

//   const SlideScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return OnBoardingSlider(
//       finishButtonText: "S'inscrire",
//       onFinish: () {
//         Navigator.push(
//           context,
//           CupertinoPageRoute(
//             builder: (context) => const SignupStep1(),
//           ),
//         );
//       },
//       // finishButtonStyle: FinishButtonStyle(
//       //   backgroundColor: kDarkBlueColor,
//       // ),
//       finishButtonStyle: FinishButtonStyle(
//         backgroundColor: kDarkBlueColor,
//         shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.all(Radius.circular(20.0))), // Ajoutez cette ligne
//       ),
//       finishButtonTextStyle: TextStyle(
//           color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
//       // skipTextButton: Text(
//       //   'Passer',
//       //   style: TextStyle(
//       //     fontSize: 16,
//       //     color: kDarkBlueColor,
//       //     fontWeight: FontWeight.w600,
//       //   ),
//       // ),
//       // trailing: Text(
//       //   'Se Connecter',
//       //   style: TextStyle(
//       //     fontSize: 16,
//       //     color: kDarkBlueColor,
//       //     fontWeight: FontWeight.w600,
//       //   ),
//       // ),
//       trailingFunction: () {
//         Navigator.push(
//           context,
//           CupertinoPageRoute(
//             builder: (context) => const LoginScreen(),
//           ),
//         );
//       },
//       controllerColor: kDarkBlueColor,
//       totalPage: 3,
//       headerBackgroundColor: Colors.white,
//       pageBackgroundColor: Colors.white,
//       centerBackground: true,

//       background: [
//         Image.asset(
//           'assets/images/splash02.png',
//         ),
//         Image.asset(
//           'assets/images/splash03.png',
//         ),
//         Image.asset(
//           'assets/images/splash04.png',
//         ),
//       ],
//       speed: 1.8,
//       pageBodies: [
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           // padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               // const SizedBox(
//               //   height: 480,
//               // ),
//               // Text(
//               //   'On your way...',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: kDarkBlueColor,
//               //     fontSize: 24.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//               // const SizedBox(
//               //   height: 20,
//               // ),
//               // const Text(
//               //   'to find the perfect looking Onboarding for your app?',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: Colors.black26,
//               //     fontSize: 18.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(
//                 height: 480,
//               ),
//               // Text(
//               //   'You’ve reached your destination.',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: kDarkBlueColor,
//               //     fontSize: 24.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 20,
//               ),
//               // const Text(
//               //   'Sliding with animation',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: Colors.black26,
//               //     fontSize: 18.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           // padding: const EdgeInsets.symmetric(horizontal: 40),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const SizedBox(
//                 height: 480,
//               ),
//               // Text(
//               //   'Start now!',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: kDarkBlueColor,
//               //     fontSize: 24.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//               const SizedBox(
//                 height: 20,
//               ),
//               // const Text(
//               //   'Where everything is possible and customize your onboarding.',
//               //   textAlign: TextAlign.center,
//               //   style: TextStyle(
//               //     color: Colors.black26,
//               //     fontSize: 18.0,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ],
//     );
  
//   }
// }
