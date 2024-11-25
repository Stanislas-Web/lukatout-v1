// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/profile/profile.dart';
import 'package:lukatout/presentation/screens/webView/webviewHome.dart';
import 'package:lukatout/presentation/screens/webView/webviewHomeChallenge.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_dart/webview_dart.dart';

class PresidentWidget extends StatefulWidget {
  const PresidentWidget({Key? key}) : super(key: key);

  @override
  _PresidentWidgetState createState() => _PresidentWidgetState();
}

class _PresidentWidgetState extends State<PresidentWidget> {

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

    Future<void> openWebsite(String url) async {
    if (!await launchUrl(Uri.parse(url), mode:  Platform.isAndroid ? LaunchMode.externalNonBrowserApplication: LaunchMode.externalApplication  )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 8 * 100),
      child: AnimatedContainer(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.only(bottom: 20),
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border:
                Border.all(color: Color(0xFFffa020).withOpacity(0.2), width: 2),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.shade100,
                  offset: Offset(0, 3),
                  blurRadius: 10)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInLeftBig(
              from: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                      backNavigation: true,
                                    )));
                      },
                      child: Ink(
                        child: Center(
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Color(0xFFffa020)),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                "assets/images/beton.webp",
                                fit: BoxFit
                                    .cover, // Adjust this based on your needs
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fatshi Challenge",
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "#Le20jevote20",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<SignupCubit, SignupState>(
              builder: (context, state) {
                return InkWell(
                  onTap: () async {
                    if (state.field!["username"] == "SID-000001") {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/login', (Route<dynamic> route) => false);
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var token = prefs.getString('token');

                      // final url = "https://fatshi.dillhub.com/?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE3MDI3NTI5NjcsImV4cCI6MTc5NzQyNTc2Nywicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiKzI0Mzk5MTU1MDI1OSIsImF1dGhvcml6ZWRWaWRlbyI6ZmFsc2UsImdlbmRlciI6IiIsIm5hbWUiOiJjcmlzbXVnaXNobyIsImlkIjozOH0.Em4gEqJdwIE7rFkp_EHZUBJC4UHYoOy0_TawN7Wdyx0zaulvmyrbCkXQbeeAKrBwcXrlDgka05Rr2oZM6E8PETkFaoGXmGcIQ19dpDWykYywX_vz5R5abq6ZuBZYEpR2lMNSYC_DGPI2WVyI_b5tzqRI3JBHlq5Tqtk4IxjEAvlgGOwkMGIFjdnrSZmfCEJClJAbvQ0W5yMJXViwdSOvatFQhLK7wJskQC5PV9ToNLUol7N-Jam1b25gQ1LtIooyg9DwBQUHXMP-GsHoctX33d9Dmd_xjTjZ_p6XuEXtCSz3dCX7d1tX4wi49ItmEjSxVrAWS4cmnGPGR8-K1DR7hKueQDa6MPyNJMCS4aU2mhQHCEa9QmiDdXUaJ_jhdQAFwxmMsmcUyJ0umEnQEo0Qsp2TTJ0jzYYk9pJABtzLBRcQJBH24-tJ2iYLK4m45GXmEFQ6JA5DQFY9FeUo-ywxwsGnOyICyjnyPChT6oSmsHPGi8U6S2Oy0qC4Y51k8DEb2kG76i5y9BtXfJ-mn7-nCTTni3ZUqcKBfSCDHzLC_aWPAWdeoNCgNnF-WKdNZ8FoL5wchbbMEK1XvV27rFbSYTx1f4os3_gx8UIYEk3kqGvJ7eqaFPiH5gAr6ekavjA8RT7zvpAWqDfFUNE2vtgVaWh0Pp3r3mTYQy672Nd2sqk";
                      // Webview(true)
                      //     .setTitle("title")
                      //     .setSize(1280, 800, SizeHint.none)
                      //     .navigate(url)
                      //     .run();

                      // openWebsite("https://wa.me/?text=bjr");

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => WebViewAppChallenge(
                      //               url:
                      //                   "https://fatshi.dillhub.com?token=$token",
                      //               backNavigation: true,
                      //               title: "Fatshi Challenge",
                      //             )));

                      //                     Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      //     builder: (context) => WebViewExample(
                      //           url:
                      //               "https://fatshi.dillhub.com?token=$token",
                      //           // backNavigation: true,
                      //           // title: "Fatshi Challenge",
                      //         )));

                      // await launchUrl(
                      //   Uri.parse("https://fatshi.dillhub.com?token=$token"),
                      //   mode: LaunchMode.externalNonBrowserApplication,
                      // );

                      openWebsite("https://fatshi.dillhub.com?token=$token");

// WebView(
//   initialUrl: getUrl(_url),
//   javascriptMode: JavascriptMode.unrestricted,
//   navigationDelegate: (NavigationRequest request) async {
//     if (request.url.startsWith('https://api.whatsapp.com/send?phone')) {
//       print('blocking navigation to $request');
//       List<String> urlSplitted = request.url.split("&text=");

//       String phone = "0123456789";
//       String message =
//           urlSplitted.last.toString().replaceAll("%20", " ");

//       await _launchURL(
//           "https://wa.me/$phone/?text=${Uri.parse(message)}");
//       return NavigationDecision.prevent;
//     }

//     print('allowing navigation to $request');
//     return NavigationDecision.navigate;
//   },
// );

                    }
                  },
                  child: Ink(
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ftRed,
                        borderRadius: BorderRadius.circular(50),
                        // border: Border.all(width: 2, color: ftPrimary)
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/video.svg",
                        color: Colors.white,
                        width: 10,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Column(
            //   children: [
            //     Text("Numéro",
            //         style: TextStyle(
            //             color: Colors.blueGrey.shade400, fontSize: 10)),
            //     Text("20",
            //         style: TextStyle(
            //             color: Colors.blueGrey.shade400,
            //             fontSize: 24,
            //             fontWeight: FontWeight.bold)),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
