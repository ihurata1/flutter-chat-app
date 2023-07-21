// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_element

import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:root/api/api.dart';
import 'package:root/components/app_container.dart';
import 'package:root/constants/navigator/page_route_effect.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleBtnClick() {
    signInWithGoogle().then((user) async {
      log("\nUser ${user.user}");
      log("\nUser Info ${user.additionalUserInfo}");
      if (await APIs.userExist()) {
        AppNavigator.push(
            screen: HomeScreen(), effect: AppRouteEffect.rightToLeft);
      } else {
        APIs.createUser().then((value) => AppNavigator.push(
            screen: HomeScreen(), effect: AppRouteEffect.rightToLeft));
      }
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Widget _loginOption(name, color, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          width: DeviceInfo.width(70),
          height: DeviceInfo.height(5),
          decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${name} ile giriş yap"),
            ],
          ),
        ),
      ),
    );
  }

  Widget get _body {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _loginOption("Google", Colors.red, () => _handleGoogleBtnClick())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: _body,
    );
  }
}
