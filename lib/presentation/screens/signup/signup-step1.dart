// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
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
import 'package:lukatout/presentation/widgets/inputs/nameField.dart';
import 'package:lukatout/presentation/widgets/inputs/postNomField.dart';
import 'package:lukatout/sizeconfig.dart';
import 'package:lukatout/theme.dart';
import 'package:lukatout/presentation/widgets/inputs/passwordTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';

class SignupStep1 extends StatefulWidget {
  const SignupStep1({Key? key}) : super(key: key);

  @override
  _SignupStep1State createState() => _SignupStep1State();
}

class _SignupStep1State extends State<SignupStep1> {
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
    print(AdaptiveTheme.of(context).mode.name);
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "password", data: "");
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "nom", data: "");

    setState(() {
      codePays = "+243";
    });
  }

  load() async {
    await SignUpRepository.loginApi();
  }

  void getDataListAbonnement() async {
    await http.post(Uri.parse("${stateInfoUrl}Trans_Liste_Abonement.php"),
        body: {'App_name': "app", 'token': "2022"}).then((response) {
      var data = json.decode(response.body);

//      print(data);

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/troupes.png"),
            fit: BoxFit.cover,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            "Créez un compte",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CameraPage(
                                          type: "inscription",
                                          id: state.field!['id'],
                                        )));
                          },
                          child: BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                              return Container(
                                  padding: const EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      border: state.field!['filePath'] != ''
                                          ? null
                                          : Border.all(color: ftOrange),
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: state.field!['filePath'] != ''
                                      ? Stack(
                                          children: [
                                            Container(
                                              width: 90.0,
                                              height: 90.0,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          state.field![
                                                              'filePath'])),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              50.0)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: ftOrange)),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color: ftOrange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0)),
                                                  child: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          ],
                                        )
                                      : SvgPicture.asset(
                                          "assets/images/Avatar.svg",
                                          width: 60,
                                        ));
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.only(bottom: 15),
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
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 1),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CountryCodePicker(
                              onChanged: (CountryCode value) {
                                setState(() {
                                  pays = value.name;
                                  codePays = value.dialCode;
                                  print(pays);
                                  print(codePays);
                                  BlocProvider.of<SignupCubit>(context)
                                      .updateField(context,
                                          field: "pays",
                                          data: value.name.toString());
                                  BlocProvider.of<SignupCubit>(context)
                                      .updateField(context,
                                          field: "codePays",
                                          data: value.dialCode.toString());
                                });
                              },
                              initialSelection: 'CD',
                              favorite: const ['+243', 'CD'],
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: AkilimaliSimplePhoneNumberField(
                                  number: codePays == "+243" ? 9 : 15,
                                  controller: phoneController,
                                  hintText: "xxx xxx xxx",
                                  color: Colors.white,
                                )),
                            Ink(
                              width: 40,
                              height: 40,
                              child: InkWell(
                                onTap: () {
                                  phoneController.text = "";
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Icon(
                                  Icons.highlight_remove,
                                  size: 24,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Text("Créez un code PIN à 4 chiffres",
                              style: TextStyle(
                                  color: Colors.black45, fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),

                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            margin: const EdgeInsets.only(bottom: 15),
                            child: SizedBox(
                              height: 50.0,
                              child: TransAcademiaPasswordField(
                                controller: passwordController,
                                label: "Créez un code PIN",
                                hintText: "Créez un code PIN",
                                field: "password",
                                fieldValue: state.field!["password"],
                              ),
                            ));
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Row(
                        children: [
                          RoundCheckBox(
                            onTap: (selected) async {
                              BlocProvider.of<SignupCubit>(context).updateField(
                                  context,
                                  field: "condition",
                                  data: "true");
                            },
                            size: 25,
                            checkedColor: ftBlue,
                            // isChecked:
                            //     state.field!["currency"] ==
                            //             "USD"
                            //         ? true
                            //         : false,
                            animationDuration: const Duration(
                              milliseconds: 50,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "J'ai lu et accepté",
                                style: TextStyle(fontSize: 11),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WebViewApp(
                                                  url:
                                                      "https://aads-rdc.org/cgu/",
                                                  backNavigation: true,
                                                  title:
                                                      "Termes et conditions d’utilisation",
                                                )));
                                  },
                                  child: Text(
                                    " les conditions d'utilisation.",
                                    style:
                                        TextStyle(fontSize: 11, color: ftBlue),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),

                    // const TransAcademiaDropdownSexe(
                    //   value: "sexe",
                    //   label: "Choisir le sexe",
                    //   hintText: "choisir Province",
                    // ),

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
                                if (phoneController.text == "") {
                                  ValidationDialog.show(context,
                                      "veuillez saisir le numéro de téléphone",
                                      () {
                                    if (kDebugMode) {
                                      print("modal");
                                    }
                                  });
                                  return;
                                }
                                if ((phoneController.text.substring(0, 1) ==
                                            "0" ||
                                        phoneController.text.substring(0, 1) ==
                                            "+") &&
                                    codePays == "+243") {
                                  ValidationDialog.show(context,
                                      "Veuillez saisir le numéro avec le format valide, exemple: (826016607).",
                                      () {
                                    print("modal");
                                  });
                                  return;
                                }
                                if (phoneController.text.length < 8 &&
                                    codePays == "+243") {
                                  ValidationDialog.show(context,
                                      "Le numéro ne doit pas avoir moins de 9 caractères, exemple: (826016607).",
                                      () {
                                    print("modal");
                                  });
                                  return;
                                }
                                if (state.field!['filePath'] != '') {
                                  if (state.field!["nom"] == "") {
                                    ValidationDialog.show(context,
                                        "Veuillez compléter votre nom complet. Ce champ ne peut être laissé vide.",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (phoneController.text == "") {
                                    ValidationDialog.show(context,
                                        "Veuillez indiquer un numéro de téléphone. Ce champ ne peut être laissé vide.",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (state.field!["password"] == "") {
                                    ValidationDialog.show(context,
                                        "Veuillez fournir un code PIN de 4 chiffres. Ce champ ne peut être laissé vide.",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (state.field!["condition"] == "" ||
                                      state.field!["condition"] != "true") {
                                    ValidationDialog.show(context,
                                        "Veuillez accepter les termes et conditions. ",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  // check connexion
                                  try {
                                    final response =
                                        await InternetAddress.lookup(
                                            'www.google.com');
                                    if (response.isNotEmpty) {
                                      print("connected");
                                    }
                                  } on SocketException catch (err) {
                                    ValidationDialog.show(
                                        context, "Pas de connexion internet !",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  BlocProvider.of<SignupCubit>(context)
                                      .updateField(context,
                                          field: "phonePayment",
                                          data:
                                              codePays! + phoneController.text);

                                  //send data in api
                                  TransAcademiaLoadingDialog.show(context);
                                  Map<String, dynamic> result =
                                      await SignUpRepository.signup(
                                    state.field!["nom"],
                                    codePays! + phoneController.text,
                                    state.field!["password"],
                                  );
                                  int statusCode = result['status'];
                                  String? msg = result['msg'];

                                  if (statusCode == 201) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    Map<String, dynamic> result =
                                        await SignUpRepository.login(
                                            codePays! + phoneController.text,
                                            state.field!["password"]);
                                    String? token = result['token'];

                                    prefs.setString('token', token.toString());
                                    prefs.setInt("count", 0);
                                    prefs.setString("currency", "usd");
                                    prefs.setBool("introduction", true);
                                    BlocProvider.of<SignupCubit>(context)
                                        .updateField(context,
                                            field: "token", data: token);

                                    Map<String, dynamic> decodedToken =
                                        JwtDecoder.decode(token!);
                                    var response =
                                        await SignUpRepository.postPhoto(
                                            decodedToken["id"].toString(),
                                            state.field!['filePath']);
                                    int statusCodePhoto = response['status'];

                                    if (statusCodePhoto == 201) {
                                      if (codePays == "+243") {
                                        prefs.setString(
                                            "phone", phoneController.text);

                                        prefs.setString('currency', "usd");
                                        prefs.setBool("introduction", true);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/routestack',
                                                (Route<dynamic> route) =>
                                                    false);
                                      } else {
                                        prefs.setString("phone", "");
                                        prefs.setString('currency', "usd");
                                        prefs.setBool("introduction", true);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/routestack',
                                                (Route<dynamic> route) =>
                                                    false);
                                      }
                                    } else {
                                      TransAcademiaLoadingDialog.stop(context);
                                      TransAcademiaDialogError.show(context,
                                          "Erreur d'enregistrement", "login");
                                    }
                                  } else {
                                    TransAcademiaLoadingDialog.stop(context);
                                    TransAcademiaDialogError.show(
                                        context, msg, "login");
                                  }
                                } else {
                                  // sans photo la photo

                                  if (state.field!["nom"] == "") {
                                    ValidationDialog.show(context,
                                        "Veuillez saisir le nom ne doit pas être vide",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (phoneController.text == "") {
                                    ValidationDialog.show(context,
                                        "veuillez saisir le numéro de téléphone",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (state.field!["password"] == "") {
                                    ValidationDialog.show(
                                        context, "veuillez saisir le PIN", () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  if (state.field!["condition"] == "" ||
                                      state.field!["condition"] != "true") {
                                    ValidationDialog.show(context,
                                        "Veuillez accepter les termes et conditions. ",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  // check connexion
                                  try {
                                    final response =
                                        await InternetAddress.lookup(
                                            'www.google.com');
                                    if (response.isNotEmpty) {
                                      print("connected");
                                    }
                                  } on SocketException catch (err) {
                                    ValidationDialog.show(
                                        context, "Pas de connexion internet !",
                                        () {
                                      if (kDebugMode) {
                                        print("modal");
                                      }
                                    });
                                    return;
                                  }

                                  BlocProvider.of<SignupCubit>(context)
                                      .updateField(context,
                                          field: "phonePayment",
                                          data:
                                              codePays! + phoneController.text);

                                  //send data in api
                                  TransAcademiaLoadingDialog.show(context);
                                  Map<String, dynamic> result =
                                      await SignUpRepository.signup(
                                    state.field!["nom"],
                                    codePays! + phoneController.text,
                                    state.field!["password"],
                                  );
                                  int statusCode = result['status'];
                                  String? msg = result['msg'];

                                  if (statusCode == 201) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();

                                    Map<String, dynamic> result =
                                        await SignUpRepository.login(
                                            codePays! + phoneController.text,
                                            state.field!["password"]);
                                    String? token = result['token'];

                                    prefs.setString('token', token.toString());
                                    print(token);
                                    Map<String, dynamic> decodedToken =
                                        JwtDecoder.decode(token!);
                                    prefs.setString(
                                        'id', decodedToken["id"].toString());
                                    prefs.setInt("count", 0);
                                    BlocProvider.of<SignupCubit>(context)
                                        .updateField(context,
                                            field: "token", data: token);

                                    if (codePays == "+243") {
                                      prefs.setString(
                                          "phone", phoneController.text);

                                      prefs.setString('currency', "usd");
                                      prefs.setBool("introduction", true);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/routestack',
                                              (Route<dynamic> route) => false);
                                    } else {
                                      prefs.setString("phone", "");
                                      prefs.setString('currency', "usd");
                                      prefs.setBool("introduction", true);
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/routestack',
                                              (Route<dynamic> route) => false);
                                    }
                                  } else {
                                    TransAcademiaLoadingDialog.stop(context);
                                    TransAcademiaDialogError.show(
                                        context, msg, "login");
                                  }
                                }
                              },
                              child: const ButtonTransAcademia(
                                  title: "S'inscrire"),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vous avez déjà un compte ? ",
                                style: TextStyle(fontSize: 11),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()));
                                },
                                child: Text(
                                  "Connectez vous? ",
                                  style: TextStyle(color: ftBlue, fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     InkWell(
                          //       onTap: (() => showToast("Bientôt disponible",
                          //           duration: 3, gravity: Toast.bottom)),
                          //       child: Text(
                          //         "Aide? ",
                          //         style: TextStyle(
                          //             color: primaryColor, fontSize: 11),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.20,
                    // ),
                    //
                    // Text("A propos",style:GoogleFonts.montserrat(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String msg, {int? duration, int? gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
