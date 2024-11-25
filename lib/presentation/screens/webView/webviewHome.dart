import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
import 'package:lukatout/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'menu.dart';
import 'navigation_controls.dart';
import 'web_view_stack.dart';

class WebViewApp extends StatefulWidget {
  final String? amount;
  final String? currency;
  final String? phonenumber;
  final String url;
  final String title;
  final bool backNavigation;
  const WebViewApp(
      {super.key,
      this.amount,
      this.currency,
      this.phonenumber,
      required this.url,
      required this.backNavigation,
      required this.title});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  late bool isOnline = true;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  Future<void> initConnectivity() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        print("connected");
      }
    } on SocketException catch (err) {

      setState(() {
        isOnline = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isOnline) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ftPrimary,
          automaticallyImplyLeading: false,
          // brightness: Brightness.light,
          leading: widget.backNavigation == false
              ? null
              : FadeInDown(
                  from: 30,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AdaptiveTheme.of(context).mode.name != "dark"
                            ? Colors.white
                            : Colors.white,
                      )),
                ),
          title: FadeInDown(
            from: 30,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                color: AdaptiveTheme.of(context).mode.name != "dark"
                    ? Colors.white
                    : Colors.white,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          // backgroundColor: Theme.of(context).bottomAppBarColor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/icons/ft.png")),
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(width: 2, color: Color(0xFFffa020))),
                ),
                SizedBox(height: 30,),
                Text('Veuillez vérifier votre connexion internet.', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400
                ), ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ftPrimary,
        automaticallyImplyLeading: false,
        // brightness: Brightness.light,
        leading: widget.backNavigation == false
            ? null
            : FadeInDown(
                from: 30,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AdaptiveTheme.of(context).mode.name != "dark"
                          ? Colors.white
                          : Colors.white,
                    )),
              ),
        title: FadeInDown(
          from: 30,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14,
              color: AdaptiveTheme.of(context).mode.name != "dark"
                  ? Colors.white
                  : Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: WebViewStack(controller: controller),
    );
  }
}
