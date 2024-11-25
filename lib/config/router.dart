// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:lukatout/presentation/screens/home/home_screen.dart';
import 'package:lukatout/presentation/screens/login/login_screen.dart';
import 'package:lukatout/presentation/screens/signup/signup-step1.dart';
import 'package:lukatout/presentation/screens/signup/signup.dart';
import 'package:lukatout/refreshCheck.dart';
import 'package:lukatout/routestack.dart';
import 'package:lukatout/slide.dart';
import 'package:lukatout/splashscreen.dart';
import 'package:lukatout/version.dart';

List<GetPage<dynamic>> getPages() {
  return [
    GetPage(
        name: '/',
        page: () => const SplashScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: '/slide',
        page: () => SlideScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: '/routestack',
        page: () => const RouteStack(),
        transition: Transition.cupertino),
    GetPage(
        name: '/login',
        page: () => const LoginScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: '/signupStep1',
        page: () => const SignupStep1(),
        transition: Transition.cupertino),
    GetPage(
        name: '/version',
        page: () => const VersionScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: '/refresh',
        page: () => const RefreshCheck(),
        transition: Transition.cupertino),
    GetPage(
        name: '/signup',
        page: () => Signup(backNavigation: true,),
        transition: Transition.cupertino),
    GetPage(
        name: '/home',
        page: () => const HomeScreen(),
        transition: Transition.cupertino),
  ];
}
