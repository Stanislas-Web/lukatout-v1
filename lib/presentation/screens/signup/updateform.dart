// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/login/login_screen.dart';
import 'package:lukatout/presentation/screens/signup/camera.dart';
import 'package:lukatout/presentation/screens/webView/webviewHome.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogError.dart';
import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
import 'package:lukatout/presentation/widgets/inputs/biographieField.dart';
import 'package:lukatout/presentation/widgets/inputs/dateField.dart';
import 'package:lukatout/presentation/widgets/inputs/dropdownSexe.dart';
import 'package:lukatout/presentation/widgets/inputs/nameField.dart';
import 'package:lukatout/presentation/widgets/inputs/postNomField.dart';
import 'package:lukatout/sizeconfig.dart';
import 'package:lukatout/theme.dart';
import 'package:lukatout/presentation/widgets/inputs/passwordTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';

class UpdateForm extends StatefulWidget {
  bool backNavigation = false;
  UpdateForm({Key? key, required this.backNavigation}) : super(key: key);

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? nameError;
  String? passwordError;
  String? submitError;
  String stateInfoUrl = 'https://api.trans-academia.cd/';
  var androidState;
  var iosState;
  var dataAbonnement = [], prixCDF, prixUSD;
  String? pays;
  String? codePays = "+243";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();

    setState(() {
      codePays = "+243";
    });
  }

  load() async {
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "sexe", data: "");

    await SignUpRepository.loginApi();
  }

  void getDataListAbonnement() async {
    await http.post(Uri.parse("${stateInfoUrl}Trans_Liste_Abonement.php"),
        body: {'App_name': "app", 'token': "2022"}).then((response) {
      var data = json.decode(response.body);

//    print(data);

      dataAbonnement =
          data['donnees'].where((e) => e['Type'] == 'Prelevement').toList();
      prixUSD = dataAbonnement[0]['prix_USD'];

      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "prixCDF", data: dataAbonnement[0]['prix_CDF']);
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "prixUSD", data: dataAbonnement[0]['prix_USD']);
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "abonnement", data: dataAbonnement[0]['id']);
    });
  }

  Future<void> checkConnection(BuildContext context) async {
    // check connexion
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        print("connected");
      }
    } on SocketException catch (err) {
      ValidationDialog.show(context, "Pas de connexion internet !", () {
        if (kDebugMode) {
          print("modal");
        }
      });
      return;
    }
  }

  checkVersion() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print('build' + buildNumber);

    final response = await http
        .get(Uri.parse('https://api-bantou-store.vercel.app/api/v1/versions'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      print(data["android"]);

      androidState = data["android"];
      iosState = data["ios"];

      if (Platform.isIOS == true) {
        if (int.parse(buildNumber) < int.parse(iosState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/appstore.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion",
              data: "Mettez à jour l'application sur Appstore");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false);
        } else {
          print('ok');
          return;
        }
      }

      if (Platform.isIOS == false) {
        if (int.parse(buildNumber) < int.parse(androidState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/playstore.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion",
              data: "Mettez à jour l'application sur playstore");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false);
          // return;
        } else {
          print('ok');
        }
      }
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ftPrimary,
        automaticallyImplyLeading: false,
        // brightness: Brightness.light,
        leading: widget.backNavigation == false
            ? null
            : FadeInDown(
                from: 30,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
              ),
        title: FadeInDown(
          from: 30,
          child: Text(
            "Modifier le profil",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        // backgroundColor: Theme.of(context).bottomAppBarColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/troupes.png"),
          fit: BoxFit.cover,
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AdaptiveTheme.of(context).mode.name != "dark"
                    ? Colors.white
                    : Colors.black,
                borderRadius: BorderRadius.circular(20.0),
              ),
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          // margin: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: 50.0,
                            child: TransAcademiaNameInput(
                              controller: emailController,
                              hintText: "Votre nom complet",
                              color: Colors.white,
                              label: "Votre nom complet",
                              field: "nom",
                              fieldValue: state.field!["nom"],
                            ),
                          ));
                    },
                  ),
                  const TransAcademiaDropdownSexe(
                    value: "sexe",
                    label: "Choisir le sexe",
                    hintText: "choisir le sexe",
                  ),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TransAcademiaDatePicker(
                          hintText: "Date de naissance",
                          label: "Date de naissance",
                          field: "dateNaissance",
                          fieldValue: state.field!["dateNaissance"],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          // margin: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            height: 100.0,
                            child: TransAcademiaBiographieInput(
                              controller: emailController,
                              hintText: "Parlez-nous de votre biographie",
                              color: Colors.white,
                              label: "Parlez-nous de votre biographie",
                              field: "biographie",
                              fieldValue: state.field!["biographie"],
                            ),
                          ));
                    },
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(5),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                          return GestureDetector(
                            onTap: () async {
                              if (state.field!["sexe"] == "") {
                                ValidationDialog.show(
                                    context, "Veuillez choisir le genre.", () {
                                  if (kDebugMode) {
                                    print("modal");
                                  }
                                });
                                return;
                              }

                              if (state.field!["dateNaissance"] == "") {
                                ValidationDialog.show(context,
                                    "Veuillez choisir la date de naissance.",
                                    () {
                                  if (kDebugMode) {
                                    print("modal");
                                  }
                                });
                                return;
                              }

                              if (state.field!["biographie"] == "") {
                                ValidationDialog.show(context,
                                    "Veuillez compléter votre biographie.", () {
                                  if (kDebugMode) {
                                    print("modal");
                                  }
                                });
                                return;
                              }

                              TransAcademiaLoadingDialog.show(context);

                              Map? response =
                                  await SignUpRepository.updateProfile(
                                      state.field!["sexe"],
                                      state.field!["nom"],
                                      state.field!["dateNaissance"],
                                      state.field!["biographie"]);

                              if (response["status"] == 201) {
                                TransAcademiaLoadingDialog.stop(context);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/routestack',
                                    (Route<dynamic> route) => false);
                              } else {
                                TransAcademiaLoadingDialog.stop(context);
                                TransAcademiaDialogError.show(
                                    context,
                                    "Une erreur est survenue. Merci de réessayer plus tard.",
                                    "login");
                              }
                            },
                            child: const ButtonTransAcademia(title: "Modifier"),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
