import 'package:flutter/material.dart';

Widget customErrorWidget(FlutterErrorDetails details) {
  return Container(
    padding: const EdgeInsets.all(20),
    color: Colors.white,
    alignment: Alignment.center,
    child: Text(
      "Erreur\n${details.exception}",
      style: const TextStyle(
        color: Colors.orangeAccent,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
