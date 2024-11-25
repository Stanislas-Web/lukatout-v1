import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:custom_qr_generator/options/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/qrcode/widgets/qrcode.widget.dart';
import 'package:lukatout/presentation/widgets/caroussel.dart';
import 'package:lukatout/theme.dart';
import 'package:lukatout/theme_provider.dart';

import 'widgets/cardMenu.dart';
import 'widgets/cardNumberCourse.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:custom_qr_generator/qr_painter.dart';


class QrCodeScreenV2 extends StatefulWidget {
  bool backNavigation;
  QrCodeScreenV2({Key? key, required this.backNavigation}) : super(key: key);

  @override
  State<QrCodeScreenV2> createState() => _QrCodeScreenV2State();
}

class _QrCodeScreenV2State extends State<QrCodeScreenV2> {
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

        body: Center(
          child: CustomPaint(
            painter: QrPainter(
                data: codeStudent.toString(),
                options: QrOptions(         
                    shapes: const QrShapes(
                        darkPixel: QrPixelShapeRoundCorners(
                            cornerFraction: .5
                        ),
                        frame: QrFrameShapeRoundCorners(
                            cornerFraction: .25
                        ),
                        ball: QrBallShapeRoundCorners(
                            cornerFraction: .25
                        )
                    ),
              
                    colors: QrColors(
                      background: QrColorSolid(AdaptiveTheme.of(context).mode.name == "dark"? Colors.black: Colors.white) ,
                        dark: const QrColorLinearGradient(
                            colors: [
                            Colors.cyan,
                            Colors.indigo,
                            ],
                            orientation: GradientOrientation.leftDiagonal
                        )
                    )
                )),
            size: const Size(350, 350),
          ),
          
          ),);
  }
}
