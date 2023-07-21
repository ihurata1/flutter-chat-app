import 'dart:io';
import 'package:flutter/material.dart';

class Application {
  static GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static int versionCode = 0; //Updated from env.json file.
  static String versionName = ""; //Updated from env.json file.
  static String name = "Root"; //Updated from env.json file.
  static String apiBaseUrl = "";

  ///Updated from env.json file.

  static get context => navigatorKey.currentContext;

  
}
