// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/home/widgets/CardStat.dart';
import 'package:lukatout/presentation/screens/home/widgets/gamerwidget.dart';
import 'package:lukatout/presentation/screens/notification/notification.dart';
import 'package:lukatout/presentation/screens/setting/setting.dart';
import 'package:lukatout/presentation/screens/webView/webviewHome.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogSuccessAbonnement.dart';
import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/presentation/widgets/inputs/simplePhoneNumberField.dart';
import 'package:lukatout/theme.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:lukatout/utils/string.util.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

class AppbarLuka extends StatefulWidget implements PreferredSizeWidget {
  final bool? isHome;
  const AppbarLuka({super.key, this.isHome});

  @override
  State<AppbarLuka> createState() => _AppbarLukaState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _AppbarLukaState extends State<AppbarLuka> {
  final TextEditingController phoneController = TextEditingController();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;

  TutorialCoachMark? tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey titleKey = GlobalKey();
  GlobalKey gameKey = GlobalKey();
  GlobalKey capagneKey = GlobalKey();
  GlobalKey groupeKey = GlobalKey();
  GlobalKey cotisationKey = GlobalKey();
  GlobalKey notificationKey = GlobalKey();
  GlobalKey challengeKey = GlobalKey();
  List? dataGamer;

  // get onCreditCardModelChange => null;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (creditCardModel != null) {
      setState(() {
        cardNumber = creditCardModel.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 50,
      child: Container(
        child: Column(
          children: [
            Container(
              color: LukaPrimary,
              height: 35,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    LukaPrimary,
                    LukaSecondary,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Row(
                            children: [

                              widget.isHome == false?
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(Icons.arrow_back_ios, size: 30, color: Colors.white,)):Container(),
                              
                              Container(
                                height: 40,
                                width: 90,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/logoluka1w.png"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 29,
                              ),
                              SizedBox(width: 10),
                              Icon(Ionicons.cart_outline, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CoachmarkDesc extends StatefulWidget {
  const CoachmarkDesc({
    super.key,
    required this.text,
    this.skip = "Sauter",
    this.next = "Suivant",
    this.onSkip,
    this.onNext,
    this.title,
  });

  final String text;
  final String skip;
  final String next;
  final String? title;
  final void Function()? onSkip;
  final void Function()? onNext;

  @override
  State<CoachmarkDesc> createState() => _CoachmarkDescState();
}

class _CoachmarkDescState extends State<CoachmarkDesc>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 20,
      duration: const Duration(milliseconds: 800),
    )..repeat(min: 0, max: 20, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animationController.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/icons/ft.png")),
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(width: 2, color: Color(0xFFffa020))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.title.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: Text(widget.skip),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: widget.onNext,
                  child: ButtonTransAcademia(
                    title: widget.next,
                    width: 90,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
