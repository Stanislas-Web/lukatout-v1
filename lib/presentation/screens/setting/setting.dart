// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/data/repository/signUp_repository.dart';
import 'package:lukatout/presentation/screens/setting/profilmenu.widget.dart';
import 'package:lukatout/presentation/screens/signup/camera.dart';
import 'package:lukatout/presentation/screens/signup/updateform.dart';
import 'package:lukatout/presentation/widgets/buttons/buttonTransAcademia.dart';
import 'package:lukatout/presentation/widgets/dialog/yesNoDialog.dart';
import 'package:lukatout/presentation/widgets/imageview.dart';
import 'package:lukatout/theme.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key, required this.backNavigation}) : super(key: key);
  bool backNavigation = false;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
    decodeToken();
    loadPhoto();
  }

    checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    if (username == "SID-000001") {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print("top");
    }
  }

  decodeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    prefs.setString('id', decodedToken["id"].toString());
    prefs.setString('nom', decodedToken["name"].toString());
    prefs.setString('username', decodedToken["username"].toString());
    prefs.setBool("first", false);

    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "id", data: decodedToken["id"].toString());

    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "nom", data: prefs.getString("nom"));
    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "username", data: prefs.getString("username"));
    BlocProvider.of<SignupCubit>(context)
        .updateField(context, field: "phone", data: prefs.getString("phone"));
    BlocProvider.of<SignupCubit>(context).updateField(context,
        field: "phonePayment", data: prefs.getString("phone"));
  }

  loadPhoto() async {
    var response = await SignUpRepository.getPhoto();

    print(response['avatar']);

    if (response["status"] == 200) {
      BlocProvider.of<SignupCubit>(context).updateField(context,
          field: "photo",
          data: "https://kampeni.injolab.com${response["avatar"]}");
    } else {
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
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
            "Profil",
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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              /// -- IMAGE
              BlocBuilder<SignupCubit, SignupState>(
                builder: (context, state) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraPage(
                                    type: "update",
                                    id: state.field!['id'],
                                  )));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: BlocBuilder<SignupCubit, SignupState>(
                            builder: (context, state) {
                              return ImageViewerWidget(
                                url: state.field!["photo"],
                                border: Border.all(
                                    width: 2, color: Color(0xFFffa020)),
                                height: 50,
                                width: 50,
                                borderRadius: BorderRadius.circular(100),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xFFffa020)),
                            child: const Icon(
                              LineAwesomeIcons.alternate_pencil,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<SignupCubit, SignupState>(
                builder: (context, state) {
                  return Text(state.field!["nom"] ?? "".toUpperCase(),
                      style: Theme.of(context).textTheme.headline5);
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<SignupCubit, SignupState>(
                builder: (context, state) {
                  return Text(
                    state.field!["username"],
                    style: Theme.of(context).textTheme.bodyText2,
                  );
                },
              ),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateForm(
                                    backNavigation: true,
                                  )));
                    },
                    child: Ink(
                        child:
                            ButtonTransAcademia(title: "Modifier le profil"))),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                  title: "Paramètre",
                  icon: LineAwesomeIcons.cog,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Mes cotisations",
                  icon: LineAwesomeIcons.wallet,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Mon Forfait internet",
                  icon: LineAwesomeIcons.wifi,
                  onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),

              ProfileMenuWidget(
                  title: "Se déconnecter",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  // textColor: Colors.red,
                  endIcon: false,
                  onPress: () async {
                    BlocProvider.of<SignupCubit>(context)
                        .updateField(context, field: "phone", data: "");
                    BlocProvider.of<SignupCubit>(context)
                        .updateField(context, field: "motdepasse", data: "");
                    BlocProvider.of<SignupCubit>(context)
                        .updateField(context, field: "nom", data: "");

                    BlocProvider.of<SignupCubit>(context)
                        .updateField(context, field: "postnom", data: "");
                    BlocProvider.of<SignupCubit>(context)
                        .updateField(context, field: "prenom", data: "");
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.getBool('first');

                    prefs.remove('id');
                    prefs.remove('nom');
                    prefs.remove('postnom');
                    prefs.remove('prenom');
                    prefs.setBool("first", false);
                    prefs.setBool("introduction", false);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login', (Route<dynamic> route) => false);
                  }),

              Platform.isIOS
                  ? ProfileMenuWidget(
                      title: "Supprimer votre compte",
                      endIcon: false,
                      isRemoved: true,
                      icon: LineAwesomeIcons.remove_user,
                      onPress: () async {
                        YesNoDialog.show(context, "Pas de connexion internet !",
                            () {
                          if (kDebugMode) {
                            print("modal");
                          }
                        });
                      })
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
