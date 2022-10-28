import 'package:flutter/material.dart';
import 'package:project/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp( MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
primaryColor: Colors.white,
  ),
home: Home(),
),);



