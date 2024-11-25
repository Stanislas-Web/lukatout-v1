// // // ignore_for_file: use_build_context_synchronously

// import 'dart:convert';
// import 'dart:io';

// import 'package:adaptive_theme/adaptive_theme.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:toast/toast.dart';
// import 'package:lukatout/business_logic/cubit/abonnement/cubit/abonnement_cubit.dart';
// import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
// import 'package:lukatout/presentation/screens/signup/signup.dart';
// import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
// import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogError.dart';
// import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogLoginPayment.dart';
// import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogSuccess.dart';
// import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
// import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
// import 'package:lukatout/sizeconfig.dart';
// import 'package:lukatout/theme.dart';
// import 'package:lukatout/presentation/widgets/inputs/passwordTextField.dart';
// import 'package:lukatout/presentation/widgets/inputs/simplePhoneNumberField.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String? nameError;
//   String? passwordError;
//   String? submitError;
//   String stateInfoUrl = 'https://api.trans-academia.cd/';
//   var androidState;
//   var iosState;
//   var dataAbonnement = [], prixCDF, prixUSD;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     BlocProvider.of<AbonnementCubit>(context).initFormPayment();
//     print(AdaptiveTheme.of(context).mode.name);
//     BlocProvider.of<SignupCubit>(context)
//         .updateField(context, field: "password", data: "");
//     checkVersion();
//     getDataListAbonnement();
//   }

//   void getDataListAbonnement() async {
//     await http.post(Uri.parse("${stateInfoUrl}Trans_Liste_Abonement.php"),
//         body: {'App_name': "app", 'token': "2022"}).then((response) {
//       var data = json.decode(response.body);

// //      print(data);

//       dataAbonnement =
//           data['donnees'].where((e) => e['Type'] == 'Prelevement').toList();
//       prixUSD = dataAbonnement[0]['prix_USD'];

//       BlocProvider.of<SignupCubit>(context).updateField(context,
//           field: "prixCDF", data: dataAbonnement[0]['prix_CDF']);
//       BlocProvider.of<SignupCubit>(context).updateField(context,
//           field: "prixUSD", data: dataAbonnement[0]['prix_USD']);
//       BlocProvider.of<SignupCubit>(context).updateField(context,
//           field: "abonnement", data: dataAbonnement[0]['id']);
//     });
//   }

//   checkVersion() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     PackageInfo packageInfo = await PackageInfo.fromPlatform();

//     String appName = packageInfo.appName;
//     String packageName = packageInfo.packageName;
//     String version = packageInfo.version;
//     String buildNumber = packageInfo.buildNumber;

//     print('build' + buildNumber);

//     final response = await http
//         .get(Uri.parse('https://api-bantou-store.vercel.app/api/v1/versions'));

//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);

//       print(data["android"]);

//       androidState = data["android"];
//       iosState = data["ios"];
//       List<String> descriptionList = data["description"].split(",");

//       BlocProvider.of<SignupCubit>(context).updateField(context,
//               field: "descriptionVersion", data: data["description"]);

//       if (Platform.isIOS == true) {
//         if (int.parse(buildNumber) < int.parse(iosState)) {
//           BlocProvider.of<SignupCubit>(context).updateField(context,
//               field: "iconVersion", data: "assets/images/update.json");
//           BlocProvider.of<SignupCubit>(context).updateField(context,
//               field: "titreVersion",
//               data: "Découvrez les nouveautés");
//           Navigator.of(context).pushNamedAndRemoveUntil(
//               '/version', (Route<dynamic> route) => false,
//               arguments: descriptionList
//               );
//         } else {
//           print('ok');
//           return;
//         }
//       }

//       if (Platform.isIOS == false) {
//         if (int.parse(buildNumber) < int.parse(androidState)) {
//           BlocProvider.of<SignupCubit>(context).updateField(context,
//               field: "iconVersion", data: "assets/images/update.json");
//           BlocProvider.of<SignupCubit>(context).updateField(context,
//               field: "titreVersion",
//               data: "Découvrez les nouveautés");
//           Navigator.of(context).pushNamedAndRemoveUntil(
//               '/version', (Route<dynamic> route) => false,
//               arguments: descriptionList );
//           // return;
//         } else {
//           print('ok');
//         }
//       }
//     } else {
//       print('error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     ToastContext().init(context);
//     return Scaffold(
//       bottomSheet: SizedBox(
//         height: 30.0,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Text("G.O.D | by Teams Developper"),
//             ]),
//       ),
//       // backgroundColor: Colors.grey.withOpacity(0.1),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           // height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: Platform.isIOS == true ? 70 : 70,
//               ),
//               Container(
//                 height: 80,
//                 // width: 300,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/qrlogo-trans.png"))),
//               ),

//               const SizedBox(
//                 height: 80.0,
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Row(
//                   // ignore: prefer_const_literals_to_create_immutables
//                   children: [
//                     const Text(
//                       "Bienvenue!",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
//                 return Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     margin: const EdgeInsets.only(bottom: 15, top: 20),
//                     child: SizedBox(
//                       height: 50.0,
//                       child: TransAcademiaPhoneNumber(
//                         number: 20,
//                         controller: phoneController,
//                         hintText: "Numéro de téléphone",
//                         field: "phone",
//                         fieldValue: state.field!["phone"],
//                       ),
//                     ));
//               }),

//               const SizedBox(
//                 height: 5.0,
//               ),

//               BlocBuilder<SignupCubit, SignupState>(
//                 builder: (context, state) {
//                   return Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       margin: const EdgeInsets.only(bottom: 15),
//                       child: SizedBox(
//                         height: 50.0,
//                         child: TransAcademiaPasswordField(
//                           controller: passwordController,
//                           label: "Mot de passe",
//                           hintText: "Mot de passe",
//                           field: "password",
//                           fieldValue: state.field!["password"],
//                         ),
//                       ));
//                 },
//               ),

//               SizedBox(
//                 height: getProportionateScreenHeight(10),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       onTap: (() => showToast("Bientôt disponible",
//                           duration: 3, gravity: Toast.bottom)),
//                       child: Text(
//                         "Mot de passe oublié ? ",
//                         style: TextStyle(color: primaryColor, fontSize: 12),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: getProportionateScreenHeight(15),
//               ),

//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     BlocBuilder<SignupCubit, SignupState>(
//                         builder: (context, state) {
//                       return GestureDetector(
//                         // onTap: (){
//                         // Navigator.of(context).pushNamedAndRemoveUntil(
//                         //               '/routestack',
//                         //               (Route<dynamic> route) => false);
//                         // } ,

//                         onTap: () async {
//                           if (state.field!["phone"] == "") {
//                             ValidationDialog.show(context,
//                                 "Veuillez saisir le numéro de téléphone", () {
//                               if (kDebugMode) {
//                                 print("modal");
//                               }
//                             });
//                             return;
//                           }

//                           if (state.field!["phone"].substring(0, 1) == "0" ||
//                               state.field!["phone"].substring(0, 1) == "+") {
//                             ValidationDialog.show(context,
//                                 "Veuillez saisir le numéro avec le format valide, par exemple: (826016607).",
//                                 () {
//                               print("modal");
//                             });
//                             return;
//                           }
//                           if (state.field!["password"] == "") {
//                             ValidationDialog.show(context,
//                                 "le mot de passe ne doit pas être vide", () {
//                               if (kDebugMode) {
//                                 print("modal");
//                               }
//                             });
//                             return;
//                           }
//                           if (state.field!["phone"].length < 8) {
//                             ValidationDialog.show(context,
//                                 "Le numéro ne doit pas avoir moins de 9 caractères, par exemple: (826016607).",
//                                 () {
//                               print("modal");
//                             });
//                             return;
//                           }

//                           // check connexion
//                           try {
//                             final response =
//                                 await InternetAddress.lookup('www.google.com');
//                             if (response.isNotEmpty) {
//                               print("connected");
//                             }
//                           } on SocketException catch (err) {
//                             ValidationDialog.show(
//                                 context, "Pas de connexion internet !", () {
//                               if (kDebugMode) {
//                                 print("modal");
//                               }
//                             });
//                             return;
//                           }

//                           //send data in api

//                           TransAcademiaLoadingDialog.show(context);

//                           int status;
//                           try {
//                             await http.post(Uri.parse(
//                                 // "https://tag.trans-academia.cd/Trans_login.php"
//                                 "https://tag.trans-academia.cd/API_login_crypte.php"), body: {
//                               'App_name': "app",
//                               'token': "2022",
//                               // ignore: prefer_interpolation_to_compose_strings
//                               'login': "0" + state.field!["phone"],
//                               // 'login': "243827244106",
//                               'pass': state.field!["password"],
//                               // 'token': '2022',
//                               // 'App_name': 'app',
//                               // 'pass': 'mboso',
//                               // 'login': '0820000106'
//                             }).then((response) {
//                               var data = json.decode(response.body);

//                               status = data['status'];
//                               if (status == 201) {
//                                 // if (status == 200) {
//                                 if (data['données'][0]["statut"] == "pending") {
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "phonePayment",
//                                           data: state.field!["phone"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "id",
//                                           data: data['données'][0]["id"]);
//                                   TransAcademiaDialogLoginPayment.show(
//                                       context, "Finaliser le Prélèvement", () {
//                                     if (kDebugMode) {
//                                       print("modal");
//                                     }
//                                   });
//                                 } else {
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "id",
//                                           data: data['données'][0]["id"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "phone",
//                                           data: data['données'][0]["Login"]
//                                               .substring(1, 10));
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "password",
//                                           data: data['données'][0]["password"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "nom",
//                                           data: data['données'][0]["Nom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "postnom",
//                                           data: data['données'][0]["Postnom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "prenom",
//                                           data: data['données'][0]["Prenom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "codeEtudiant",
//                                           data: data['données'][0]
//                                               ["Code Etudiant"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "photo",
//                                           data: data['données'][0]["Photo"] ??
//                                               '');

//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "refresh",
//                                           data: data['données'][0]["Refresh"] ??
//                                               '');

//                                   TransAcademiaLoadingDialog.stop(context);
//                                   TransAcademiaDialogSuccess.show(context,
//                                       "Authentification réussie", "login");
//                                   Future.delayed(
//                                       const Duration(milliseconds: 4000),
//                                       () async {
//                                     SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.setString(
//                                         'id', data['données'][0]["id"]);
//                                     prefs.setString(
//                                         'phone',
//                                         data['données'][0]["Login"]
//                                             .substring(1, 10));
//                                     prefs.setString(
//                                         'nom', data['données'][0]["Nom"]);
//                                     prefs.setString('postnom',
//                                         data['données'][0]["Postnom"]);
//                                     prefs.setString(
//                                         'prenom', data['données'][0]["Prenom"]);
//                                     prefs.setString('code',
//                                         data['données'][0]["Code Etudiant"]);
//                                     prefs.setString('photo',
//                                         data['données'][0]["Photo"] ?? '');
//                                     prefs.setString('refresh',
//                                         data['données'][0]["Refresh"] ?? '');

//                                     // ignore: use_build_context_synchronously
//                                     Navigator.of(context)
//                                         .pushNamedAndRemoveUntil('/routestack',
//                                             (Route<dynamic> route) => false);
//                                   });
//                                 }
//                               } else if (status == 200) {
//                                 if (data['données'][0]["statut"] == "pending") {
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "phonePayment",
//                                           data: state.field!["phone"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "id",
//                                           data: data['données'][0]["id"]);
//                                   TransAcademiaDialogLoginPayment.show(
//                                       context, "Finaliser le Prélèvement", () {
//                                     if (kDebugMode) {
//                                       print("modal");
//                                     }
//                                   });
//                                 } else {
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "id",
//                                           data: data['données'][0]["id"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "phone",
//                                           data: data['données'][0]["Login"]
//                                               .substring(1, 10));
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "password",
//                                           data: data['données'][0]["password"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "nom",
//                                           data: data['données'][0]["Nom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "postnom",
//                                           data: data['données'][0]["Postnom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "prenom",
//                                           data: data['données'][0]["Prenom"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "codeEtudiant",
//                                           data: data['données'][0]
//                                               ["Code Etudiant"]);
//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(context,
//                                           field: "photo",
//                                           data: data['données'][0]["Photo"] ??
//                                               '');

//                                   BlocProvider.of<SignupCubit>(context)
//                                       .updateField(
//                                           context,
//                                           field: "refresh",
//                                           data: data['données'][0]["Refresh"] ??
//                                               '');

//                                   TransAcademiaLoadingDialog.stop(context);
//                                   TransAcademiaDialogSuccess.show(context,
//                                       "Authentification réussie", "login");
//                                   Future.delayed(
//                                       const Duration(milliseconds: 4000),
//                                       () async {
//                                     SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.setString(
//                                         'id', data['données'][0]["id"]);
//                                     prefs.setString(
//                                         'phone',
//                                         data['données'][0]["Login"]
//                                             .substring(1, 10));
//                                     prefs.setString(
//                                         'nom', data['données'][0]["Nom"]);
//                                     prefs.setString('postnom',
//                                         data['données'][0]["Postnom"]);
//                                     prefs.setString(
//                                         'prenom', data['données'][0]["Prenom"]);
//                                     prefs.setString('code',
//                                         data['données'][0]["Code Etudiant"]);
//                                     prefs.setString('photo',
//                                         data['données'][0]["Photo"] ?? '');
//                                     prefs.setString('refresh',
//                                         data['données'][0]["Refresh"] ?? '');

//                                     // ignore: use_build_context_synchronously
//                                     Navigator.of(context)
//                                         .pushNamedAndRemoveUntil('/routestack',
//                                             (Route<dynamic> route) => false);
//                                   });
//                                 }
//                               } else {
//                                 TransAcademiaLoadingDialog.stop(context);
//                                 TransAcademiaDialogError.show(
//                                     context,
//                                     "Numéro de télépone ou mot de passe incorrect",
//                                     "login");
//                               }
//                             });
//                           } catch (e) {
//                             print(e);
//                           }
//                         },

//                         child: const ButtonTransAcademia(title: "Se connecter"),
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: getProportionateScreenHeight(15),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 0.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Vous n'avez pas un compte ? ",
//                           style: TextStyle(fontSize: 11),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => Signup(
//                                         backNavigation: true,
//                                       )),
//                             );
//                           },
//                           child: Text(
//                             "Creez un compte ? ",
//                             style: TextStyle(color: primaryColor, fontSize: 11),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.20,
//               ),
//               //
//               // Text("A propos",style:GoogleFonts.montserrat(color: Colors.white, fontSize: 12)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showToast(String msg, {int? duration, int? gravity}) {
//     Toast.show(msg, duration: duration, gravity: gravity);
//   }
// }

// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/signup/signup-step1.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/TransAcademiaDialogError.dart';
import 'package:lukatout/presentation/widgets/dialog/ValidationDialog.dart';
import 'package:lukatout/presentation/widgets/dialog/loading.dialog.dart';
import 'package:lukatout/presentation/widgets/inputs/postNomField.dart';
import 'package:lukatout/sizeconfig.dart';
import 'package:lukatout/theme.dart';
import 'package:lukatout/presentation/widgets/inputs/passwordTextField.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_code_picker/country_code_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
    print(AdaptiveTheme.of(context).mode.name);
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "password", data: "");
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "nom", data: "");
    checkVersion();
    getDataListAbonnement();
    setState(() {
      codePays = "+243";
    });
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

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    // String? version = packageInfo.version;
    String? buildNumber = packageInfo.buildNumber.toString();

    print('build' + buildNumber);

    final response = await http
        .get(Uri.parse('https://api-mobpay.vercel.app/api/v1/versions'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      if (data["android"] != null && data["ios"] != null) {
        print(data["android"]);

        String androidState = data["android"].toString();
        String iosState = data["ios"].toString();

        if (Platform.isIOS == true) {
          if (buildNumber != null &&
              int.parse(buildNumber) < int.parse(iosState)) {
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
          if (buildNumber != null &&
              int.parse(buildNumber) < int.parse(androidState)) {
            BlocProvider.of<SignupCubit>(context).updateField(context,
                field: "iconVersion", data: "assets/images/playstore.json");
            BlocProvider.of<SignupCubit>(context).updateField(context,
                field: "titreVersion",
                data: "Mettez à jour l'application sur Playstore");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/version', (Route<dynamic> route) => false);
          } else {
            print('ok');
          }
        }
      } else {
        print('Les valeurs Android ou iOS sont nulles.');
      }
    } else {
      print('Erreur de requête HTTP : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ToastContext().init(context);
    return Scaffold(
      // bottomSheet: SizedBox(
      //   height: 30.0,
      //   width: MediaQuery.of(context).size.width,
      //   child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: const [
      //         Text("G.O.D | by Teams Developper"),
      //       ]),
      // ),
      // backgroundColor: Colors.grey.withOpacity(0.1),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/troupes.png"),
            fit: BoxFit.cover,
          )
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //     Color.fromRGBO(0, 188, 212, 1),
              //     Color(0xFF204f97),
              //     // Color(0xff0E0A70)
              //   ],
              // ),
              ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 100,),

              // const SizedBox(height: 20,),
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
                      height: Platform.isIOS == true ? 30 : 30,
                    ),

                    // const SizedBox(
                    //   height: 80.0,
                    // ),
                    // Container(
                    //   height: 80,
                    //   // width: 300,
                    //   decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage(
                    //               AdaptiveTheme.of(context).mode.name != "dark"
                    //                   ? "assets/images/qrlogo-trans.png"
                    //                   : "assets/images/qrlogo-trans-dark.png"))),
                    // ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            height: 70,
                          ),
                          const Text(
                            "Connexion!",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BlocBuilder<SignupCubit, SignupState>(
                    //     builder: (context, state) {
                    //   return Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //       margin: const EdgeInsets.only(bottom: 15, top: 20),
                    //       child: SizedBox(
                    //         height: 50.0,
                    //         child: TransAcademiaPhoneNumber(
                    //           number: 20,
                    //           controller: phoneController,
                    //           hintText: "Numéro de téléphone",
                    //           field: "phone",
                    //           fieldValue: state.field!["phone"],
                    //         ),
                    //       ));
                    // }),

                    // BlocBuilder<SignupCubit, SignupState>(
                    //     builder: (context, state) {
                    //   return Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //       margin: const EdgeInsets.only(bottom: 15, top: 20),
                    //       child: SizedBox(
                    //         height: 50.0,
                    //         child: TransAcademiaPhoneNumber(
                    //           number: 20,
                    //           controller: phoneController,
                    //           hintText: "Numéro de téléphone",
                    //           field: "phone",
                    //           fieldValue: state.field!["phone"],
                    //         ),
                    //       ));
                    // }),

                    // BlocBuilder<SignupCubit, SignupState>(
                    //     builder: (context, state) {
                    //   return Container(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //       margin: const EdgeInsets.only(bottom: 15, top: 20),
                    //       child: SizedBox(
                    //         height: 50.0,
                    //         child: TransAcademiaNameInput(
                    //           number: 20,
                    //           controller: nameController,
                    //           hintText: "Nom d'utilisateur",
                    //           label: "Nom d'utilisateur",
                    //           field: "nom",
                    //           fieldValue: state.field!["nom"],
                    //         ),
                    //       ));
                    // }),

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
                      height: 25.0,
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
                                label: "votre PIN",
                                hintText: "Votre PIN",
                                field: "password",
                                fieldValue: state.field!["password"],
                              ),
                            ));
                      },
                    ),

                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
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

                                print("moi");
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                prefs.setBool("introduction", false);

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

                                if (state.field!["password"] == "") {
                                  ValidationDialog.show(context,
                                      "Veuillez saisir le mot de passe", () {
                                    if (kDebugMode) {
                                      print("modal");
                                    }
                                  });
                                  return;
                                }

                                // check connexion
                                try {
                                  final response = await InternetAddress.lookup(
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
                                        data: codePays! + phoneController.text);
                                print(state.field!["phonePayment"]);
                                //send data in api
                                TransAcademiaLoadingDialog.show(context);
                                Map<String, dynamic> result =
                                    await SignUpRepository.login(
                                        codePays! + phoneController.text,
                                        state.field!["password"]);
                                

                                String? token = result['token'];
                                int statusCode = result['status'];

                                if (statusCode == 200) {
                                  prefs.setString('token', token.toString());
                                  prefs.setInt("count", 0);
                                  prefs.setString("currency", "usd");
                                  BlocProvider.of<SignupCubit>(context)
                                      .updateField(context,
                                          field: "token", data: token);

                                  if (codePays == "+243") {
                                    prefs.setString(
                                        "phone", phoneController.text);

                                    prefs.setString('currency', "usd");
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/routestack',
                                            (Route<dynamic> route) => false);
                                  } else {
                                    prefs.setString("phone", "");
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/routestack',
                                            (Route<dynamic> route) => false);
                                  }
                                } else {
                                  TransAcademiaLoadingDialog.stop(context);
                                  TransAcademiaDialogError.show(
                                      context,
                                      "Nom d'utilisateur ou mot de passe incorrect",
                                      "login");
                                }
                              },
                              child: const ButtonTransAcademia(
                                  title: "Se connecter"),
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
                                "Vous n'avez pas un compte ? ",
                                style: TextStyle(fontSize: 10),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupStep1()));
                                },
                                child: Text(
                                  "Creez un compte ? ",
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 14),
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
