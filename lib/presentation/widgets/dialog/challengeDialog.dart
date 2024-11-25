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

class ChallengeDialog {
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
                                const SizedBox(
                                  height: 20.0,
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
                                  "Fatshi challenge",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  "Vous êtes un leader d'opinion et vous souhaitez la réélection du Président Félix-Antoine TSHISEKEDI. Enregistrez et partagez votre vidéo",
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<SignupCubit, SignupState>(
                                  builder: (context, state) {
                                    return  state.field!["authorizedVideo"]== false ?Text("Souscrivez à un"): Container();
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                BlocBuilder<SignupCubit, SignupState>(
                                  builder: (context, state) {
                                    return InkWell(
                                        onTap: () async {
                                          if (state.field!["authorizedVideo"] ==
                                              false) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            BlocProvider.of<SignupCubit>(
                                                    context)
                                                .updateField(context,
                                                    field: "phone",
                                                    data: prefs
                                                        .getString("phone"));
                                            BlocProvider.of<SignupCubit>(
                                                    context)
                                                .updateField(context,
                                                    field: "phonePayment",
                                                    data: prefs
                                                        .getString("phone"));

                                            BlocProvider.of<SignupCubit>(
                                                    context)
                                                .updateField(context,
                                                    field: "nombreCarte",
                                                    data: "100");

                                            showBarModalBottomSheet(
                                              context: context,
                                              builder: (context) =>
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setState) {
                                                return Container(
                                                  height: (550.0),
                                                  decoration: BoxDecoration(
                                                    // color: Colors.blue.shade50,
                                                    borderRadius:
                                                        BorderRadius.only(
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
                                                        "Compte Premium",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Souscription avec un minimum de 100\$",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                        child:
                                                            ContainedTabBarView(
                                                          tabs: [
                                                            Text(
                                                              'Mobile Money',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            Text(
                                                              'Carte Bancaire',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ],
                                                          tabBarProperties:
                                                              TabBarProperties(
                                                            background:
                                                                Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8.0)),
                                                              ),
                                                            ),
                                                            indicatorColor:
                                                                ftBlue,
                                                            labelColor:
                                                                Colors.white,
                                                            unselectedLabelColor:
                                                                Colors
                                                                    .grey[400],
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
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                20.0),
                                                                        margin: const EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            top:
                                                                                20),
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
                                                                                state.field!["phone"],
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
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20.0),
                                                                    child:
                                                                        SpinBox(
                                                                      min: 1,
                                                                      max:
                                                                          10000,
                                                                      value:
                                                                          100,
                                                                      onChanged:
                                                                          (value) =>
                                                                              {
                                                                        BlocProvider.of<SignupCubit>(context).updateField(
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
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            RoundCheckBox(
                                                                              onTap: (selected) {
                                                                                BlocProvider.of<SignupCubit>(context).updateField(context, field: "currency", data: "USD");
                                                                              },
                                                                              size: 25,
                                                                              checkedColor: primaryColor,
                                                                              isChecked: state.field!["currency"] == "USD" ? true : false,
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
                                                                        Row(
                                                                          children: [
                                                                            RoundCheckBox(
                                                                              onTap: (selected) {
                                                                                BlocProvider.of<SignupCubit>(context).updateField(context, field: "currency", data: "CDF");
                                                                              },
                                                                              size: 25,
                                                                              checkedColor: primaryColor,
                                                                              isChecked: state.field!["currency"] == "CDF" ? true : false,
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
                                                                    );
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                BlocBuilder<
                                                                    SignupCubit,
                                                                    SignupState>(
                                                                  builder:
                                                                      (context,
                                                                          state) {
                                                                    return InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        if (state.field!["phonePayment"] ==
                                                                            "") {
                                                                          ValidationDialog.show(
                                                                              context,
                                                                              "Le numéro de paiement ne doit pas être vide",
                                                                              () {
                                                                            print("modal");
                                                                          });
                                                                          return;
                                                                        }

                                                                        if (state.field!["phonePayment"].length <
                                                                            9) {
                                                                          ValidationDialog.show(
                                                                              context,
                                                                              "Le numéro de paiement ne doit pas avoir moins de 9 chiffres",
                                                                              () {
                                                                            if (kDebugMode) {
                                                                              print("modal");
                                                                            }
                                                                          });
                                                                          return;
                                                                        }

                                                                        if (state.field!["currency"] ==
                                                                            "") {
                                                                          ValidationDialog.show(
                                                                              context,
                                                                              "Veuillez choisir la devise",
                                                                              () {
                                                                            print("modal");
                                                                          });
                                                                          return;
                                                                        }

                                                                        if (state.field!["phonePayment"].substring(0, 1) ==
                                                                                "0" ||
                                                                            state.field!["phonePayment"].substring(0, 1) ==
                                                                                "+") {
                                                                          ValidationDialog.show(
                                                                              context,
                                                                              "Veuillez saisir le numéro avec le format valide, par exemple: (826016607).",
                                                                              () {
                                                                            print("modal");
                                                                            return;
                                                                          });
                                                                        }

                                                                        // check connexion
                                                                        try {
                                                                          final response =
                                                                              await InternetAddress.lookup('www.google.com');
                                                                          if (response
                                                                              .isNotEmpty) {
                                                                            print("connected");
                                                                          }
                                                                        } on SocketException catch (err) {
                                                                          ValidationDialog.show(
                                                                              context,
                                                                              "Pas de connexion internet !",
                                                                              () {
                                                                            if (kDebugMode) {
                                                                              print("modal");
                                                                            }
                                                                          });
                                                                          return;
                                                                        }

                                                                        TransAcademiaLoadingDialog.show(
                                                                            context);

                                                                        var response = await SignUpRepository.sendPayment(
                                                                            state.field!['phonePayment'],
                                                                            state.field!['nombreCarte'],
                                                                            state.field!['currency']);

                                                                        if (response["status"] ==
                                                                            200) {
                                                                          TransAcademiaLoadingDialog.stop(
                                                                              context);
                                                                          TransAcademiaDialogSuccessAbonnement.show(
                                                                              context,
                                                                              response["msg"],
                                                                              "paiement");
                                                                          BlocProvider.of<SignupCubit>(context).updateField(
                                                                              context,
                                                                              field: "phonePayment",
                                                                              data: "");
                                                                          Future.delayed(
                                                                              const Duration(milliseconds: 5000),
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                        } else {
                                                                          TransAcademiaLoadingDialog.stop(
                                                                              context);
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }
                                                                      },
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 20.0),
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
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20.0),
                                                                    child:
                                                                        SpinBox(
                                                                      min: 1,
                                                                      max:
                                                                          10000,
                                                                      value:
                                                                          100,
                                                                      onChanged:
                                                                          (value) =>
                                                                              {
                                                                        BlocProvider.of<SignupCubit>(context).updateField(
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
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          20.0),
                                                                  child: BlocBuilder<
                                                                      SignupCubit,
                                                                      SignupState>(
                                                                    builder:
                                                                        (context,
                                                                            state) {
                                                                      return InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          TransAcademiaLoadingDialog.show(
                                                                              context);

                                                                          var response =
                                                                              await SignUpRepository.cardPayment(state.field!["nombreCarte"]);

                                                                          String?
                                                                              url =
                                                                              response["url"];
                                                                          int?
                                                                              status =
                                                                              response["status"];

                                                                          if (status ==
                                                                              200) {
                                                                            TransAcademiaLoadingDialog.stop(context);
                                                                            Navigator.of(context).pop();
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
                                          } else {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            var token =
                                                prefs.getString('token');

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WebViewApp(
                                                          url:
                                                              "https://fatshi.dillhub.com?token=$token ",
                                                          backNavigation: true,
                                                          title:
                                                              "Fatshi Challenge",
                                                        )));
                                          }
                                        },
                                        child: Ink(
                                            child: ButtonTransAcademia(
                                                title:state.field!["authorizedVideo"] == false ? "Compte Premium":"Ajouter une vidéo")));
                                  },
                                ),
                                // const SizedBox(
                                //   height: 30.0,
                                // ),
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
