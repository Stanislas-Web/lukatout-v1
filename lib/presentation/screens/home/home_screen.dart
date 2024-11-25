// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardMenuLuka.dart';
import 'package:lukatout/presentation/screens/home/widgets/cardNumberCourseappbar.dart';
import 'package:lukatout/presentation/screens/livraison/homelivraison.dart';
import 'package:lukatout/presentation/screens/shopping/routestackmarketplace.dart';
import 'package:lukatout/presentation/widgets/appbarLuka.dart';
import 'package:lukatout/sizeconfig.dart';
import 'package:lukatout/theme.dart';
import 'widgets/cardMenu.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String role = "";
  bool getCarte = false;
  bool getFlash = false;
  bool getAcces = false;
  bool getControl = false;
  bool getPhoto = false;
  bool getOffline = false;
  bool getAccesOffline = false;
  bool getPaiementOffline = false;

  var androidState;
  var iosState;

  Future _launchURL(url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVersion();
    getProfilAgent();
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "phone", data: "");
  }

  checkVersion() async {
    WidgetsFlutterBinding.ensureInitialized();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String buildNumber = packageInfo.buildNumber;

    print('build' + buildNumber);

    final response = await http
        .get(Uri.parse('https://api-mobpay.vercel.app/api/v1/versionsagent'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      print(data["android"]);

      androidState = data["android"];
      iosState = data["ios"];
      List<String> descriptionList = data["description"].split(",");

      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "descriptionVersion", data: data["description"]);

      if (Platform.isIOS == true) {
        if (int.parse(buildNumber) < int.parse(iosState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/update.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion", data: "Découvrez les nouveautés");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false,
              arguments: descriptionList);
        } else {
          print('ok');
          return;
        }
      }

      if (Platform.isIOS == false) {
        if (int.parse(buildNumber) < int.parse(androidState)) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "iconVersion", data: "assets/images/update.json");
          BlocProvider.of<SignupCubit>(context).updateField(context,
              field: "titreVersion", data: "Découvrez les nouveautés");
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/version', (Route<dynamic> route) => false,
              arguments: descriptionList);
          // return;
        } else {
          print('ok');
        }
      }
    } else {
      print('error');
    }
  }

  // getRole() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     role = prefs.getString('role')!;
  //     if (role == "Point-Focaux") {
  //       getCarte = true;
  //       getFlash = true;
  //       getAcces = false;
  //       getControl = false;
  //       getPhoto = true;
  //       getOffline = true;
  //       getPaiementOffline = true;
  //       getAccesOffline = false;
  //     } else if (role == "Controleur") {
  //       getCarte = false;
  //       getFlash = false;
  //       getAcces = false;
  //       getControl = true;
  //       getPhoto = true;
  //       getOffline = false;
  //       getPaiementOffline = false;
  //       getAccesOffline = true;
  //     } else if (role == "Regulateur") {
  //       getCarte = true;
  //       getFlash = true;
  //       getAcces = false;
  //       getControl = false;
  //       getPhoto = true;
  //       getOffline = true;
  //       getOffline = true;
  //       getPaiementOffline = true;
  //       getAccesOffline = true;
  //     } else if (role == "Verificateur") {
  //       getCarte = false;
  //       getFlash = false;
  //       getAcces = true;
  //       getControl = true;
  //       getPhoto = false;
  //       getOffline = false;
  //       getPaiementOffline = false;
  //       getAccesOffline = true;
  //     } else {
  //       getCarte = true;
  //       getFlash = true;
  //       getAcces = true;
  //       getControl = true;
  //       getPhoto = true;
  //       getOffline = true;
  //       getPaiementOffline = true;
  //       getAccesOffline = true;
  //     }
  //   });
  // }

  getProfilAgent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "phone", data: prefs.getString('phone'));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "idAgent", data: prefs.getString('id'));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "nom", data: prefs.getString('nom'));
    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "postnom", data: prefs.getString('postnom'));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "prenom", data: prefs.getString('prenom'));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "role", data: prefs.getString('fonction'));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawerMenu(context),
      appBar: AppbarLuka(isHome: true),
      body: SafeArea(
        child: Container(
          color: Colors.white70,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Wrap GridView with Align to center it
                SizedBox(
                  height: 20,
                ),
                Container(
                  // color: Colors.red,
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 40,
                      children: [
//
//
//
//
// Luka Nionso
// Luka Buku
// Luka Musala

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RouteStackMarketplace(),
                              ),
                            );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop20.svg",
                            title: "Luka Shopping",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LivraisonHome(),
                              ),
                            );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukamoto.svg",
                            title: "Luka Livraison",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const ControlleClientScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukataxi.svg",
                            title: "Luka Taxi",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QrCopyScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop10.svg",
                            title: "Luka Marchand",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QrCopyScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop10.svg",
                            title: "Luka ndaku",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QrCopyScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop10.svg",
                            title: "Luka Kisi (Pharma)",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QrCopyScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop10.svg",
                            title: "Luka Musala",
                            active: true,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const QrCopyScreen(),
                            //   ),
                            // );
                          },
                          child: CardMenuLuka(
                            icon: "assets/icons/lukashop10.svg",
                            title: "Luka Buku",
                            active: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Other widgets after GridView
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drawerMenu(context) {
    final Uri _url = Uri.parse('https://trans-academia.cd');

    Future<void> launchUrlSite() async {
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }

    ToastContext().init(context);

    void showToast(String msg, {int? duration, int? gravity}) {
      Toast.show(msg, duration: duration, gravity: gravity);
    }

    return Drawer(
      backgroundColor: Colors.red,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              bottom: getProportionateScreenWidth(15),
            ),
            height: getProportionateScreenWidth(150),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    getProportionateScreenWidth(30),
                  ),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: 10),
                    child: SizedBox(
                      child: Row(
                        children: [
                          BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                              return Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.red,
                                    ),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child:
                                      //  state.field!['photo'] == ''
                                      //     ?
                                      SvgPicture.asset(
                                    "assets/images/Avatar.svg",
                                    width: 40,
                                    // ignore: prefer_interpolation_to_compose_strings
                                  ));
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(10),
                            ),
                          ),
                          BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                              return Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                state.field!["prenom"].toString() +
                                    " " +
                                    state.field!["nom"].toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 5,
                  color: Colors.red,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                              return Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                state.field!["role"].toString() ==
                                        'Point-Focaux'
                                    ? "Point - Focal"
                                    : state.field!["role"].toString(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //Liste title

          Container(
            margin: EdgeInsets.only(
              left: getProportionateScreenWidth(20),
              bottom: getProportionateScreenWidth(20),
            ),
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    getProportionateScreenWidth(30),
                  ),
                )),
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(10),
                        vertical: 30),
                    child: Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () async {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           const ActivityScreen()),
                              // );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.local_activity_outlined,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Mon Activité",
                                    style: TextStyle(
                                        // color: Colors.black87,
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Divider(
                            height: 1,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          InkWell(
                            onTap: () async {
                              launchUrlSite();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.web_rounded,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Site web",
                                    style: TextStyle(
                                        // color: Colors.black87,
                                        // fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Divider(
                            height: 1,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              showToast("Bientôt disponible",
                                  duration: 3, gravity: Toast.bottom);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.help_outline_outlined,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "A propos",
                                    style: TextStyle(
                                        // color: Colors.black87,
                                        // fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Divider(
                            height: 1,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () async {
                              BlocProvider.of<SignupCubit>(context).updateField(
                                  context,
                                  field: "phone",
                                  data: "");
                              BlocProvider.of<SignupCubit>(context).updateField(
                                  context,
                                  field: "motdepasse",
                                  data: "");
                              BlocProvider.of<SignupCubit>(context)
                                  .updateField(context, field: "nom", data: "");

                              BlocProvider.of<SignupCubit>(context).updateField(
                                  context,
                                  field: "postnom",
                                  data: "");
                              BlocProvider.of<SignupCubit>(context).updateField(
                                  context,
                                  field: "prenom",
                                  data: "");
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/', (Route<dynamic> route) => false);
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const LoginScreen()),
                              // );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 100.0,
                                  child: Text(
                                    "Déconnexion",
                                    style: TextStyle(
                                        // color: Colors.black87,
                                        // fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Divider(
                            height: 1,
                          ),
                          const SizedBox(
                            height: 130,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
