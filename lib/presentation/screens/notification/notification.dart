import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/notification/widgets/cardNotification.dart';
import 'package:lukatout/presentation/screens/transaction/widgets/loadTransaction.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
// import 'widgets/cardTransaction.dart';
import 'package:http/http.dart' as http;
import 'package:lukatout/theme.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key, required this.backNavigation})
      : super(key: key);
  bool backNavigation = false;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  dynamic notifications = [
    {
      "title": "BIENVENU A Lukatout",
      "content":
          "Désormais vous faites partie de ceux qui soutiennent la réélection du Président Félix - Antoine TSHISEKEDI TSHILOMBO."
    },
    {
      "title": "FATSHI QUIZ",
      "content":
          "Pensez-vous connaitre le Président Félix - Antoine TSHISEKEDI TSHILOMBO et ses réalisations pour la RDC ?\n\n Soyez parmi les 1 000 meilleurs Joueurs du jeu et gagnez des cadeaux (bourses d'étude, fonds de commerces, forfait internet, ...)",
    },
    {
      "title": "ACTUALITES",
      "content":
          "Suivez l'actualité et la campagne électorale du Président Félix-Antoine TSHISEKEDI TSHILOMBO.",
    },
    {
      "title": "UNION SACREE",
      "content":
          "Toutes les personnalités politiques et opérateurs économiques qui soutiennent la candidature du Président Félix-Antoine TSHISEKEDI TSHILOMBO.",
    },
  ];

  bool isLoading = false;
  int? lengthTransaction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNotification();
    // getTransaction();
  }

  loadNotification () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sign = prefs.getString("currency") == "usd" ? "\$" : "Fc";
    prefs.setString("setNotification", "false");
    BlocProvider.of<SignupCubit>(context)
          .updateField(context, field: "setNotification", data: prefs.getString("setNotification"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade50,
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
                    color: Colors.white,
                  )),
          title: Text(
            "Notifications",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: ftPrimary,
        ),
        body: SafeArea(
          child: Container(
            // color: Colors.grey.withOpacity(0.1),
            padding: EdgeInsets.only(top: 5.0),
            height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.only(top: 10.0),
            // width: MediaQuery.of(context).size.width,

            child: Container(
              height: 700,
              child: ListView.builder(
                itemCount: notifications.length ?? [],
                itemBuilder: (BuildContext context, int index) {
                  return CardNotification(notifications: notifications[index]);
                },
              ),
            ),
          ),
        ));
  }
}
