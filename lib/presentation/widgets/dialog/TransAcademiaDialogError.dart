import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:lukatout/presentation/widgets/inputs/simplePhoneNumberField.dart';
import 'package:lukatout/routestack.dart';

class TransAcademiaDialogError {
  static stop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static show(BuildContext context, String? text, String? title) {
    showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    if (title == "prelevement") {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
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
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/icons/ft.png")),
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                      width: 2, color: Color(0xFFffa020))),
                            ),
                            SizedBox(height: 20,),
                            Text(
                              text.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
