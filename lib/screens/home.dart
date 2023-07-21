// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:root/api/api.dart';
import 'package:root/components/app_container.dart';
import 'package:root/components/chat_user_card.dart';
import 'package:root/constants/navigator/page_route_effect.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/model/user.dart';
import 'package:root/screens/login.dart';

import '../components/app_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserM> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      if (message.toString().contains('resumed')) {
        APIs.updateActiveStatus(true);
      }
      if (message.toString().contains('paused')) {
        APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }
  @override
  

  Widget get _body {
    return Container(
      height: DeviceInfo.height(100),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: DeviceInfo.height(100),
            color: Colors.indigo,
            child: StreamBuilder(
                stream: APIs.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return AppLoading();

                    case ConnectionState.none:
                      return AppLoading();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      list =
                          data?.map((e) => UserM.fromJson(e.data())).toList() ??
                              [];
                      if (list.isNotEmpty) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: list.length,
                          padding: EdgeInsets.only(top: DeviceInfo.height(2)),
                          itemBuilder: ((context, index) {
                            return ChatUserCard(user: list[index]);
                          }),
                        );
                      } else {
                        return Center(
                          child: Text(
                            "No user has found!",
                            style: TextStyle(fontSize: 26),
                          ),
                        );
                      }
                  }
                }),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(4)),
            margin: EdgeInsets.only(bottom: DeviceInfo.height(2)),
            child: FloatingActionButton(
              child: Icon(Icons.exit_to_app),
              backgroundColor: Colors.red,
              onPressed: () async {
                await APIs.authInstance.signOut();
                await GoogleSignIn().signOut();
                AppNavigator.pushAndRemoveUntil(
                    screen: LoginScreen(), effect: AppRouteEffect.leftToRight);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(child: _body);
  }
}
