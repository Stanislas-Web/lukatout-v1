import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/config/router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lukatout/presentation/widgets/CustomError.dart';
import 'firebase_options.dart';
// import 'firebase_options.dart';

class MyErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  MyErrorWidget({required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    // Personnalisez l'affichage de l'erreur ici, par exemple, affichez un message d'erreur.
    return Center(
      child: Text('Une erreur s\'est produite. Veuillez réessayer plus tard.'),
    );
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path.toString());
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    assert(() {
      inDebug = true;
      return true;
    }());
    if (inDebug) {
      return ErrorWidget(details.exception);
    }
    return customErrorWidget(details);
  };

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 runApp(const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignupCubit>(
          create: (BuildContext context) => SignupCubit(),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          backgroundColor: Colors.black54,
          bottomAppBarColor: Color(0xFFF5F5F5),
        ),
        dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            accentColor: Colors.black54,
            backgroundColor: Colors.white,
            bottomAppBarColor: Colors.black26),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate],
          supportedLocales: const [Locale('en'), Locale('fr')],
          title: 'Lukatout',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          getPages: getPages(),
          initialRoute: '/',
        ),
      ),
    );
  }
}
