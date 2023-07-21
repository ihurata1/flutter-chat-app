import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHelper {
  static late SharedPreferences prefs;
  static initialize() async {
    //#region initializer
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    prefs = await SharedPreferences.getInstance();
  }
}
