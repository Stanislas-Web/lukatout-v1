import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/webView/webviewHome.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogSuccessAbonnement.dart';
import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
import 'package:lukatout/presentation/widgets/inputs/simplePhoneNumberField.dart';
import 'package:lukatout/theme.dart';

class YesNoDialog {
  static show(BuildContext context, String? text, Function? onClose) {
    showDialog<void>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          final TextEditingController phoneController = TextEditingController();

          return Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: InkWell(
                  // onTap: () => Navigator.of(context).pop(),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width:
                                MediaQuery.of(context).size.width * 3 / 4 + 50,
                            // height: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 7.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color:
                                  AdaptiveTheme.of(context).mode.name == "dark"
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(),
                                    InkWell(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black45,
                                            )))
                                  ],
                                ),
                         
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/icons/ft.png")),
                                    borderRadius: BorderRadius.circular(50.0),
                                    // border: Border.all(
                                    //     width: 2, color: Color(0xFFffa020))
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                        
                                Text(
                                  textAlign: TextAlign.center,
                                  "Êtes-vous sûr(e) de vouloir supprimer votre compte ?",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                             BlocBuilder<SignupCubit, SignupState>(
                                  builder: (context, state) {
                                    return InkWell(
                                        onTap: () async {
                                          BlocProvider.of<SignupCubit>(context)
                                              .updateField(context,
                                                  field: "phone", data: "");
                                          BlocProvider.of<SignupCubit>(context)
                                              .updateField(context,
                                                  field: "motdepasse",
                                                  data: "");
                                          BlocProvider.of<SignupCubit>(context)
                                              .updateField(context,
                                                  field: "nom", data: "");

                                          BlocProvider.of<SignupCubit>(context)
                                              .updateField(context,
                                                  field: "postnom", data: "");
                                          BlocProvider.of<SignupCubit>(context)
                                              .updateField(context,
                                                  field: "prenom", data: "");
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.getBool('first');

                                          prefs.remove('id');
                                          prefs.remove('nom');
                                          prefs.remove('postnom');
                                          prefs.remove('prenom');
                                          prefs.setBool("first", false);
                                          prefs.setBool("introduction", false);
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/login',
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: Ink(
                                            child: ButtonTransAcademia(
                                                title: "Oui", width: MediaQuery.of(context).size.width/3, colorWidget: Colors.redAccent,)));
                                  },
                                ),
                                SizedBox(width: 10,),
                                InkWell(

                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Ink(child: ButtonTransAcademia(title: "Non", width: MediaQuery.of(context).size.width/3)))
                         

                                ],),
                     
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
