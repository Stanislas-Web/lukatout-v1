
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TransAcademiaLoadingDialogPhone {
  static stop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static show(BuildContext context) {
    showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 7.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AdaptiveTheme.of(context).mode.name == "dark"
                            ? Colors.black
                            : Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: const Icon(Icons.close))),
                            ],
                          ),

                          //icon
                          Lottie.asset('assets/images/phone.json',
                              height: 100),
                          const SizedBox(
                            height: 20,
                          ),
                          Lottie.asset('assets/images/counter.json',
                              height: 50),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}
