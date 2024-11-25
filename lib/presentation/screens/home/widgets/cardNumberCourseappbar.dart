// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

class CardNumberOfCourseAppbar extends StatefulWidget
    implements PreferredSizeWidget {
  final List actus;
  final int? myNumberOver, myNumberWinner, myNumber;
  const CardNumberOfCourseAppbar(
      {super.key,
      required this.actus,
      this.myNumber,
      this.myNumberOver,
      this.myNumberWinner});

  @override
  State<CardNumberOfCourseAppbar> createState() =>
      _CardNumberOfCourseAppbarState();

  @override
  Size get preferredSize => Size.fromHeight(300);
}

class _CardNumberOfCourseAppbarState extends State<CardNumberOfCourseAppbar> {
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
    loadGoodGamer();
    loadPhoto();
    loadData();
    Future.delayed(const Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var introduction = prefs.getBool('introduction');

      if (introduction == null || introduction == true) {
        _showTutorialCoachmark();
      } else {
        print("Good Job");
      }
    });
  }

  Future<void> openWebsite(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: Platform.isAndroid
            ? LaunchMode.externalNonBrowserApplication
            : LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  loadPhoto() async {
    var response = await SignUpRepository.getPhoto();

    print(response['avatar']);

    if (response["status"] == 200) {
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "photo",
          data: StringFormat.photoUrl(response["avatar"].toString()));
    } else {
      print("error");
    }
  }

  loadGoodGamer() async {
    var response = await SignUpRepository.getGoodGamer();
    List? data = response["data"];
    int? status = response["status"];

    if (status == 200) {
      setState(() {
        dataGamer = response["data"];
      });
    } else {
      print("erreur");
    }
  }

  loadData() async {
    var response = await SignUpRepository.getPayment();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sign = prefs.getString("currency") == "usd" ? "\$" : "Fc";

    if (response["data"].toString() == "[]") {
      BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "cotisation", data: "0.0 ${sign}");
    } else {
      double totalAmount = 0.0;

      for (var payment in response["data"]) {
        totalAmount += double.parse(payment["amount"]);
      }
      print(totalAmount);
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "cotisation", data: "${totalAmount} ${sign}");
    }
  }

  void _showTutorialCoachmark() {
    _initTarget();
    tutorialCoachMark = TutorialCoachMark(
      textSkip: "",
      targets: targets,
      pulseEnable: false,
      colorShadow: ftPrimary,
      onClickTarget: (target) {
        print("${target.identify}");
      },
      // hideSkip: true,
      alignSkip: Alignment.topRight,
      onFinish: () {
        print("Finish");
      },
    )..show(context: context);
  }

  void _initTarget() {
    targets = [
      TargetFocus(
        identify: "profile-key",
        keyTarget: titleKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "BIENVENU A Lukatout",
                text:
                    "Désormais vous faites partie de ceux qui soutiennent la réélection du Président Félix - Antoine TSHISEKEDI TSHILOMBO.",
                onNext: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("introduction", false);
                  prefs.setString("setNotification", "true");
                  BlocProvider.of<SignupCubit>(context).updateField(context,
                      field: "setNotification",
                      data: prefs.getString("setNotification"));
                  controller.next();

                  prefs.setBool("introduction", false);
                },
                // onSkip: () async {
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();
                //   prefs.setBool("introduction", false);
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),
      // profile
      TargetFocus(
        identify: "profile-key",
        keyTarget: gameKey,
        color: Colors.transparent,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "FATSHI QUIZ",
                text:
                    "Pensez-vous connaitre le Président Félix - Antoine TSHISEKEDI TSHILOMBO et ses réalisations pour la RDC ?\n\n Soyez parmi les 1 000 meilleurs Joueurs du jeu et gagnez des cadeaux (bourses d'étude, fonds de commerces, forfait internet, ...)",
                onNext: () {
                  controller.next();
                },
                // onSkip: () {
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),

      TargetFocus(
        identify: "profile-key",
        keyTarget: challengeKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "FATSHI CHALLENGE",
                text:
                    "Enregistrez une vidéo depuis votre téléphone en mode portrait et prononcez la phrase : \"Le 20 décembre, je vote le 20. Fatshi Béton, et toi?.\"",
                onNext: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("introduction", false);
                  prefs.setString("setNotification", "true");
                  BlocProvider.of<SignupCubit>(context).updateField(context,
                      field: "setNotification",
                      data: prefs.getString("setNotification"));
                  controller.next();

                  prefs.setBool("introduction", false);
                },
                // onSkip: () async {
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();
                //   prefs.setBool("introduction", false);
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),

      // profile
      TargetFocus(
        identify: "profile-key",
        keyTarget: capagneKey,
        color: Colors.transparent,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "ACTUALITES",
                text:
                    "Suivez l'actualité et la campagne électorale du Président Félix-Antoine TSHISEKEDI TSHILOMBO.",
                onNext: () {
                  controller.next();
                },
                // onSkip: () {
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),

      // notification
      TargetFocus(
        identify: "notification-key",
        keyTarget: groupeKey,
        color: Colors.transparent,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "UNION SACREE",
                text:
                    "Toutes les personnalités politiques et opérateurs économiques qui soutiennent la candidature du Président Félix-Antoine TSHISEKEDI TSHILOMBO.",
                onNext: () {
                  controller.next();
                },
                // onSkip: () {
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),

      TargetFocus(
        identify: "notification-key",
        keyTarget: cotisationKey,
        color: Colors.transparent,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return CoachmarkDesc(
                title: "MON SOUTIEN",
                text:
                    "Je suis content de pouvoir vous apporter \ntout mon soutien pour ces élections de décembre 2023.\n\nRecevez de tout cœur ma contribution.",
                onNext: () {
                  controller.next();
                },
                // onSkip: () {
                //   controller.skip();
                // },
              );
            },
          )
        ],
      ),

      // search
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      from: 50,
      child: Container(
        padding: EdgeInsets.all((10)),
        height: Platform.isIOS ? 260 : 240,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(
                30.0), // Ajustez le rayon comme vous le souhaitez
            bottomRight: Radius.circular(
                30.0), // Ajustez le rayon comme vous le souhaitez
          ),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              ftPrimary,
              ftPrimary,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: Platform.isIOS ? 50 : 30,
            ),
            FadeInLeftBig(
              from: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Lukatout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: () async {
                                if (state.field!["username"] == "SID-000001") {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/login',
                                      (Route<dynamic> route) => false);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingScreen(
                                                backNavigation: true,
                                              )));
                                }
                              },
                              child: BlocBuilder<SignupCubit, SignupState>(
                                builder: (context, state) {
                                  return ImageViewerWidget(
                                    key: titleKey,
                                    url: state.field!["username"] ==
                                            "SID-000001"
                                        ? "https://kampeni.injolab.com/images/avatar_default.png"
                                        : state.field!["photo"],
                                    border: Border.all(
                                        width: 2, color: Color(0xFFffa020)),
                                    height: 50,
                                    width: 50,
                                    borderRadius: BorderRadius.circular(50),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationScreen(
                                        backNavigation: true,
                                      )),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  "assets/icons/notif-trans.svg",
                                  width: 25,
                                ),
                              ),
                              BlocBuilder<SignupCubit, SignupState>(
                                builder: (context, state) {
                                  return Positioned(
                                      top: 0,
                                      right: 0,
                                      child: state.field!["setNotification"] ==
                                              "true"
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3),
                                              // height: 10,
                                              // width: 10,
                                              decoration: BoxDecoration(
                                                color: ftRed,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                "4",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9),
                                              ),
                                            )
                                          : Container());
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return InkWell(
                        onTap: () {
                          loadGoodGamer();

                          if (state.field!["username"] == "SID-000001") {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          } else {
                            showBarModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 550.0,
                                decoration: BoxDecoration(
                                  // color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        20.0), // Ajustez le rayon comme vous le souhaitez
                                    topRight: Radius.circular(
                                        20.0), // Ajustez le rayon comme vous le souhaitez
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Mes points",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BlocBuilder<SignupCubit, SignupState>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CardStatWidget(
                                                number: state.field![
                                                        "totalSuccess"] ??
                                                    "0",
                                                type: "success",
                                                total: state.field!["count"],
                                                title: "Réussies",
                                              ),
                                              CardStatWidget(
                                                number: state.field![
                                                        "totalFailed"] ??
                                                    "0",
                                                type: "error",
                                                total: state.field!["count"],
                                                title: "Échouées",
                                              ),
                                              CardStatWidget(
                                                number:
                                                    state.field!["totalPlay"] ??
                                                        "0",
                                                type: "total",
                                                total: state.field!["count"],
                                                title: "Total",
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Les 5 meilleurs joueurs.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Pour inverser la tendance, jouez à plusieurs questions par jour.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                        height: 300,
                                        child:
                                            GoodGamer(gamers: dataGamer ?? [])),
                                    Divider(),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mes points",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BlocBuilder<SignupCubit, SignupState>(
                                      builder: (context, state) {
                                        return Text(
                                          (state.field!["username"] ==
                                                  "SID-000001")
                                              ? "0"
                                              : state.field!["totalSuccess"] ??
                                                  "0",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showBarModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 200.0,
                          decoration: BoxDecoration(
                            // color: Colors.blue.shade50,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  20.0), // Ajustez le rayon comme vous le souhaitez
                              topRight: Radius.circular(
                                  20.0), // Ajustez le rayon comme vous le souhaitez
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Changer la devise",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              BlocBuilder<SignupCubit, SignupState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            RoundCheckBox(
                                              onTap: (selected) async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    'currency', "usd");

                                                loadData();

                                                BlocProvider.of<SignupCubit>(
                                                        context)
                                                    .updateField(context,
                                                        field: "currency",
                                                        data: "USD");
                                              },
                                              size: 25,
                                              checkedColor: primaryColor,
                                              isChecked:
                                                  state.field!["currency"] ==
                                                          "USD"
                                                      ? true
                                                      : false,
                                              animationDuration: const Duration(
                                                milliseconds: 50,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            const Text("USD")
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                          height: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            RoundCheckBox(
                                              onTap: (selected) async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString(
                                                    'currency', "cdf");

                                                loadData();

                                                BlocProvider.of<SignupCubit>(
                                                        context)
                                                    .updateField(context,
                                                        field: "currency",
                                                        data: "CDF");
                                              },
                                              size: 25,
                                              checkedColor: primaryColor,
                                              isChecked:
                                                  state.field!["currency"] ==
                                                          "CDF"
                                                      ? true
                                                      : false,
                                              animationDuration: const Duration(
                                                milliseconds: 50,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20.0,
                                            ),
                                            const Text("CDF")
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Mon Soutien",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.field!["cotisation"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: state.field!["cotisation"] ==
                                            "Pas de cotisation"
                                        ? 10
                                        : 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  size: 20,
                                  color: Colors.white,
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: BlocBuilder<SignupCubit, SignupState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              if (state.field!["username"] == "SID-000001") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (Route<dynamic> route) => false);
                              } else {
                              }
                            },
                            child: Container(
                              key: gameKey,
                              padding: EdgeInsets.all((10.0)),
                              height: 50.0,
                              width: 65.0,
                              decoration: BoxDecoration(
                                color: ftRed,
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(10, 20),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/manette.svg",
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              var token = prefs.getString('token');

                              if (state.field!["username"] == "SID-000001") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (Route<dynamic> route) => false);
                              } else {
                                openWebsite(
                                    "https://fatshi.dillhub.com?token=$token");
                                // launchUrl(
                                //   Uri.parse(
                                //       "https://fatshi.dillhub.com?token=$token"),
                                //   mode: LaunchMode.externalNonBrowserApplication,
                                // );
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => WebViewApp(
                                //               url:
                                //                   "https://fatshi.dillhub.com?token=$token ",
                                //               backNavigation: true,
                                //               title: "Fatshi Challenge",
                                //             )));
                              }
                            },
                            child: Container(
                              key: challengeKey,
                              padding: EdgeInsets.all((10.0)),
                              height: 50.0,
                              width: 65.0,
                              decoration: BoxDecoration(
                                color: ftPrimary,
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(10, 20),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/video.svg",
                              ),
                            ),
                          );
                        },
                      ),

                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              if (state.field!["username"] == "SID-000001") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (Route<dynamic> route) => false);
                              } else {

                              }
                            },
                            child: Container(
                              key: capagneKey,
                              padding: EdgeInsets.all((10.0)),
                              height: 50.0,
                              width: 65.0,
                              decoration: BoxDecoration(
                                color: ftGreen,
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(10, 20),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/haut.svg",
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<SignupCubit, SignupState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              if (state.field!["username"] == "SID-000001") {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login', (Route<dynamic> route) => false);
                              } else {
                              }
                            },
                            child: Container(
                              key: groupeKey,
                              padding: EdgeInsets.all((10.0)),
                              height: 50.0,
                              width: 65.0,
                              decoration: BoxDecoration(
                                color: ftBlue,
                                borderRadius: BorderRadius.circular(20.0),
                                border:
                                    Border.all(width: 2, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    offset: Offset(10, 20),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/groupe.svg",
                              ),
                            ),
                          );
                        },
                      ),
                      // Row(
                      //   children: [
                      //     Column(
                      //       children: [
                      //         SvgPicture.asset(
                      //           "",
                      //           width: 30,
                      //         ),
                      //         SizedBox(
                      //           height: 3,
                      //         ),
                      //         Text(
                      //           "Campagne",
                      //           style: TextStyle(fontSize: 8, color: Colors.black45),
                      //         ),
                      //       ],
                      //     ),

                      //     SizedBox(
                      //       width: (40.0),
                      //     ),
                      //     Column(
                      //       children: [
                      //         SvgPicture.asset(
                      //           "assets/icons/user1.svg",
                      //           width: 30,
                      //         ),
                      //         SizedBox(
                      //           height: 3,
                      //         ),
                      //         Text(
                      //           "Union sacrée",
                      //           style: TextStyle(fontSize: 8, color: Colors.black45),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),

                      ((Platform.isIOS &&
                                  state.field!["username"] ==
                                      "+243826016607") ||
                              (Platform.isIOS &&
                                  state.field!["username"] == "SID-000001"))
                          ? Container()
                          : BlocBuilder<SignupCubit, SignupState>(
                              builder: (context, state) {
                                return InkWell(
                                  onTap: () async {
                                    if (state.field!["username"] ==
                                        "SID-000001") {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil('/login',
                                              (Route<dynamic> route) => false);
                                    } else {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      BlocProvider.of<SignupCubit>(context)
                                          .updateField(context,
                                              field: "phone",
                                              data: prefs.getString("phone"));
                                      BlocProvider.of<SignupCubit>(context)
                                          .updateField(context,
                                              field: "phonePayment",
                                              data: prefs.getString("phone"));

                                      BlocProvider.of<SignupCubit>(context)
                                          .updateField(context,
                                              field: "nombreCarte",
                                              data: "100");

                                      showBarModalBottomSheet(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            height: 550.0,
                                            decoration: BoxDecoration(
                                              // color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(
                                                    20.0), // Ajustez le rayon comme vous le souhaitez
                                                topRight: Radius.circular(
                                                    20.0), // Ajustez le rayon comme vous le souhaitez
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Je soutiens Fatshi Béton",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey,
                                                ),

                                                SizedBox(
                                                  height: 400,
                                                  child: ContainedTabBarView(
                                                    tabs: [
                                                      Text(
                                                        'Mobile Money',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        'Carte Bancaire',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                    tabBarProperties:
                                                        TabBarProperties(
                                                      background: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0)),
                                                        ),
                                                      ),
                                                      indicatorColor:
                                                          Colors.blue,
                                                      labelColor: Colors.white,
                                                      unselectedLabelColor:
                                                          Colors.grey[400],
                                                    ),
                                                    views: [
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 40,
                                                          ),
                                                          BlocBuilder<
                                                              SignupCubit,
                                                              SignupState>(
                                                            builder: (context,
                                                                state) {
                                                              return Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20.0),
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          15,
                                                                      top: 20),
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        50.0,
                                                                    child:
                                                                        TransAcademiaPhoneNumber(
                                                                      number:
                                                                          20,
                                                                      controller:
                                                                          phoneController,
                                                                      hintText:
                                                                          "Numéro de téléphone",
                                                                      field:
                                                                          "phonePayment",
                                                                      fieldValue:
                                                                          state.field![
                                                                              "phone"],
                                                                    ),
                                                                  ));
                                                            },
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child: Text(
                                                                    "Montant"),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          BlocBuilder<
                                                                  SignupCubit,
                                                                  SignupState>(
                                                              builder: (context,
                                                                  state) {
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                              child: SpinBox(
                                                                min: 1,
                                                                max: 10000,
                                                                value: 100,
                                                                onChanged:
                                                                    (value) => {
                                                                  BlocProvider.of<
                                                                              SignupCubit>(
                                                                          context)
                                                                      .updateField(
                                                                          context,
                                                                          field:
                                                                              "nombreCarte",
                                                                          data:
                                                                              value.toString()),
                                                                },
                                                              ),
                                                            );
                                                          }),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          BlocBuilder<
                                                              SignupCubit,
                                                              SignupState>(
                                                            builder: (context,
                                                                state) {
                                                              return Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      RoundCheckBox(
                                                                        onTap:
                                                                            (selected) {
                                                                          BlocProvider.of<SignupCubit>(context).updateField(
                                                                              context,
                                                                              field: "currency",
                                                                              data: "USD");
                                                                        },
                                                                        size:
                                                                            25,
                                                                        checkedColor:
                                                                            primaryColor,
                                                                        isChecked: state.field!["currency"] ==
                                                                                "USD"
                                                                            ? true
                                                                            : false,
                                                                        animationDuration:
                                                                            const Duration(
                                                                          milliseconds:
                                                                              50,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            20.0,
                                                                      ),
                                                                      const Text(
                                                                          "USD")
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      RoundCheckBox(
                                                                        onTap:
                                                                            (selected) {
                                                                          BlocProvider.of<SignupCubit>(context).updateField(
                                                                              context,
                                                                              field: "currency",
                                                                              data: "CDF");
                                                                        },
                                                                        size:
                                                                            25,
                                                                        checkedColor:
                                                                            primaryColor,
                                                                        isChecked: state.field!["currency"] ==
                                                                                "CDF"
                                                                            ? true
                                                                            : false,
                                                                        animationDuration:
                                                                            const Duration(
                                                                          milliseconds:
                                                                              50,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            20.0,
                                                                      ),
                                                                      const Text(
                                                                          "CDF")
                                                                    ],
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          BlocBuilder<
                                                              SignupCubit,
                                                              SignupState>(
                                                            builder: (context,
                                                                state) {
                                                              return InkWell(
                                                                onTap:
                                                                    () async {
                                                                  if (state.field![
                                                                          "phonePayment"] ==
                                                                      "") {
                                                                    ValidationDialog.show(
                                                                        context,
                                                                        "Le numéro de paiement ne doit pas être vide",
                                                                        () {
                                                                      print(
                                                                          "modal");
                                                                    });
                                                                    return;
                                                                  }

                                                                  if (state
                                                                          .field![
                                                                              "phonePayment"]
                                                                          .length <
                                                                      9) {
                                                                    ValidationDialog.show(
                                                                        context,
                                                                        "Le numéro de paiement ne doit pas avoir moins de 9 chiffres",
                                                                        () {
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            "modal");
                                                                      }
                                                                    });
                                                                    return;
                                                                  }

                                                                  if (state.field![
                                                                          "currency"] ==
                                                                      "") {
                                                                    ValidationDialog.show(
                                                                        context,
                                                                        "Veuillez choisir la devise",
                                                                        () {
                                                                      print(
                                                                          "modal");
                                                                    });
                                                                    return;
                                                                  }

                                                                  if (state.field!["phonePayment"].substring(
                                                                              0,
                                                                              1) ==
                                                                          "0" ||
                                                                      state.field!["phonePayment"].substring(
                                                                              0,
                                                                              1) ==
                                                                          "+") {
                                                                    ValidationDialog.show(
                                                                        context,
                                                                        "Veuillez saisir le numéro avec le format valide, par exemple: (826016607).",
                                                                        () {
                                                                      print(
                                                                          "modal");
                                                                      return;
                                                                    });
                                                                  }

                                                                  // check connexion
                                                                  try {
                                                                    final response =
                                                                        await InternetAddress.lookup(
                                                                            'www.google.com');
                                                                    if (response
                                                                        .isNotEmpty) {
                                                                      print(
                                                                          "connected");
                                                                    }
                                                                  } on SocketException catch (err) {
                                                                    ValidationDialog.show(
                                                                        context,
                                                                        "Pas de connexion internet !",
                                                                        () {
                                                                      if (kDebugMode) {
                                                                        print(
                                                                            "modal");
                                                                      }
                                                                    });
                                                                    return;
                                                                  }

                                                                  TransAcademiaLoadingDialog
                                                                      .show(
                                                                          context);

                                                                  var response = await SignUpRepository.sendPayment(
                                                                      state.field![
                                                                          'phonePayment'],
                                                                      state.field![
                                                                          'nombreCarte'],
                                                                      state.field![
                                                                          'currency']);

                                                                  if (response[
                                                                          "status"] ==
                                                                      200) {
                                                                    TransAcademiaLoadingDialog
                                                                        .stop(
                                                                            context);
                                                                    TransAcademiaDialogSuccessAbonnement.show(
                                                                        context,
                                                                        response[
                                                                            "msg"],
                                                                        "paiement");
                                                                    BlocProvider.of<SignupCubit>(context).updateField(
                                                                        context,
                                                                        field:
                                                                            "phonePayment",
                                                                        data:
                                                                            "");
                                                                    Future.delayed(
                                                                        const Duration(
                                                                            milliseconds:
                                                                                5000),
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                                  } else {
                                                                    TransAcademiaLoadingDialog
                                                                        .stop(
                                                                            context);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20.0),
                                                                  child: ButtonTransAcademia(
                                                                      title:
                                                                          "Cotiser"),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),

                                                      // interface Carte
                                                      Column(
                                                        children: [
                                                          // CreditCardForm(
                                                          //   formKey: formKey,
                                                          //   obscureCvv: true,
                                                          //   obscureNumber: true,
                                                          //   cardNumber: cardNumber,
                                                          //   cvvCode: cvvCode,
                                                          //   isHolderNameVisible: true,
                                                          //   isCardNumberVisible: true,
                                                          //   isExpiryDateVisible: true,
                                                          //   cardHolderName: cardHolderName,
                                                          //   expiryDate: expiryDate,
                                                          //   themeColor: ftBlue,
                                                          //   cardNumberDecoration: InputDecoration(
                                                          //     labelText: 'Numéro de la carte',
                                                          //     hintText: 'XXXX XXXX XXXX XXXX',
                                                          //     border: OutlineInputBorder(
                                                          //       borderRadius: BorderRadius.circular(
                                                          //           20.0), // Ajustez le rayon selon vos préférences
                                                          //     ),
                                                          //   ),
                                                          //   expiryDateDecoration: InputDecoration(
                                                          //     labelText: 'Date Expiration',
                                                          //     hintText: 'XX/XX',
                                                          //     border: OutlineInputBorder(
                                                          //       borderRadius: BorderRadius.circular(
                                                          //           20.0), // Ajustez le rayon selon vos préférences
                                                          //     ),
                                                          //   ),
                                                          //   cvvCodeDecoration: InputDecoration(
                                                          //     labelText: 'CVV',
                                                          //     hintText: 'XXX',
                                                          //     border: OutlineInputBorder(
                                                          //       borderRadius: BorderRadius.circular(
                                                          //           20.0), // Ajustez le rayon selon vos préférences
                                                          //     ),
                                                          //   ),
                                                          //   cardHolderDecoration: InputDecoration(
                                                          //     labelText: 'Nom de la Carte',
                                                          //     border: OutlineInputBorder(
                                                          //       borderRadius: BorderRadius.circular(
                                                          //           20.0), // Ajustez le rayon selon vos préférences
                                                          //     ),
                                                          //   ),
                                                          //   onCreditCardModelChange:
                                                          //       onCreditCardModelChange,
                                                          // ),
                                                          SizedBox(
                                                            height: 40,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                                child: Text(
                                                                    "Montant"),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          BlocBuilder<
                                                                  SignupCubit,
                                                                  SignupState>(
                                                              builder: (context,
                                                                  state) {
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20.0),
                                                              child: SpinBox(
                                                                min: 1,
                                                                max: 10000,
                                                                value: 100,
                                                                onChanged:
                                                                    (value) => {
                                                                  BlocProvider.of<
                                                                              SignupCubit>(
                                                                          context)
                                                                      .updateField(
                                                                          context,
                                                                          field:
                                                                              "nombreCarte",
                                                                          data:
                                                                              value.toString()),
                                                                },
                                                              ),
                                                            );
                                                          }),

                                                          SizedBox(
                                                            height: 40,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20.0),
                                                            child: BlocBuilder<
                                                                SignupCubit,
                                                                SignupState>(
                                                              builder: (context,
                                                                  state) {
                                                                return InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    TransAcademiaLoadingDialog
                                                                        .show(
                                                                            context);

                                                                    var response =
                                                                        await SignUpRepository.cardPayment(
                                                                            state.field!["nombreCarte"]);

                                                                    String?
                                                                        url =
                                                                        response[
                                                                            "url"];
                                                                    int?
                                                                        status =
                                                                        response[
                                                                            "status"];

                                                                    if (status ==
                                                                        200) {
                                                                      TransAcademiaLoadingDialog
                                                                          .stop(
                                                                              context);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => WebViewApp(
                                                                                    url: url.toString(),
                                                                                    backNavigation: true,
                                                                                    title: "Paiement",
                                                                                  )));
                                                                    } else {}
                                                                  },
                                                                  child: ButtonTransAcademia(
                                                                      title:
                                                                          "Cotiser"),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    onChange: (index) =>
                                                        print(index),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: 20,
                                                // ),
                                              ],
                                            ),
                                          );
                                        }),
                                      );
                                    }
                                  },
                                  child: Container(
                                    key: cotisationKey,
                                    padding: EdgeInsets.all((10.0)),
                                    height: 50.0,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      color: ftOrange,
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white12,
                                          offset: Offset(10, 20),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/icons/don.svg",
                                    ),
                                  ),
                                );
                              },
                            )
                    ],
                  );
                },
              ),
              // child: const Text("data"),
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
