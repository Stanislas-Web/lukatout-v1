// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkConnect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkConnect() async {
    Future.delayed(const Duration(seconds: 5)).then((val) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/slide', (Route<dynamic> route) => false);
    });

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var first = prefs.getBool('first');
    var id = prefs.getString('id');
    var nom = prefs.getString('nom');
    var postnom = prefs.getString('postnom');
    var prenom = prefs.getString('prenom');

    Future.delayed(const Duration(seconds: 5)).then((val) {
      if (first == null || first == true) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/slide', (Route<dynamic> route) => false);
      } else {
        if (id == null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        } else {
          BlocProvider.of<SignupCubit>(context)
              .updateField(context, field: "id", data: id);
          BlocProvider.of<SignupCubit>(context)
              .updateField(context, field: "nom", data: nom);
          BlocProvider.of<SignupCubit>(context)
              .updateField(context, field: "postnom", data: postnom);
          BlocProvider.of<SignupCubit>(context)
              .updateField(context, field: "prenom", data: prenom);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/routestack', (Route<dynamic> route) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/splashlukatout.png',
              ),
              fit: BoxFit.cover,
              ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image.asset(
            //   ,
            //   // width: 300.0,
            //   height: MediaQuery.of(context).size.height,
            //   fit: BoxFit.cover,
            // ),
            // const SizedBox(
            //   height: 80.0,
            // ),
            // Lottie.asset('assets/images/loader-trans.json', height: 100),
          ],
        ),
      ),
    );
  }
}
