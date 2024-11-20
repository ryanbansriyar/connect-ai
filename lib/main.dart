import 'package:flutter/material.dart';
import 'package:project1/pages/talk.dart';
import 'package:project1/pages/home.dart';
void main() => runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/talk': (context) => Talk(),
    }

));