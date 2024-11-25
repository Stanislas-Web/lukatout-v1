// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:animate_do/animate_do.dart';
import 'package:lukatout/theme.dart';

class ButtonSpeak extends StatefulWidget {
  final String? text;
  ButtonSpeak({Key? key, this.text}) : super(key: key);
  bool backNavigation = false;

  @override
  _ButtonSpeakState createState() => _ButtonSpeakState();
}

class _ButtonSpeakState extends State<ButtonSpeak> {
  FlutterTts flutterTts = FlutterTts();
  double speechRate = 0.5;
  double pitch = 1.0;
  bool isPlaying = false;
  Set<int> bookmarks = Set<int>();

  @override
  void initState() {
    super.initState();
    flutterTts.setSpeechRate(speechRate);
    flutterTts.setPitch(pitch);
    flutterTts.setLanguage("fr-FR");
    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
    });
  }

  void toggleBookmark(int position) {
    setState(() {
      if (bookmarks.contains(position)) {
        bookmarks.remove(position);
      } else {
        bookmarks.add(position);
      }
    });
  }

  Future<void> speak() async {
    await flutterTts.speak(widget.text.toString());
    setState(() {
      isPlaying = true;
    });
  }

  Future<void> pause() async {
    await flutterTts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if (isPlaying == false) {
          speak();
        } else {
          pause();
        }
      },
      child: Ink(
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: ftRed,
              border: Border.all(width: 2, color: Colors.white)),
          child: Icon(
            isPlaying == false ? Icons.play_circle : Icons.pause_circle,
            color: Colors.white,
            size: 45,
          ),
        ),
      ),
    );
  }
}
