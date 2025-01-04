import 'package:flutter/material.dart';
import 'package:project1/pages/objectivepage.dart';
import 'package:project1/pages/talk.dart';
import 'package:project1/pages/home.dart';
import 'package:project1/pages/login.dart';
void main() => runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/home': (context) => Home(),
      '/talk': (context) => Talk(),
      '/login': (context) => LoginScreen(),
    }

));