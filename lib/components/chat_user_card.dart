// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:line_icons/line_icon.dart';
import 'package:root/api/api.dart';
import 'package:root/constants/colors.dart';
import 'package:root/constants/navigator/page_route_effect.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/helpers/navigator/navigator.dart';
import 'package:root/model/message.dart';
import 'package:root/screens/chat.dart';

import '../model/user.dart';

class ChatUserCard extends StatefulWidget {
  final UserM? user;
  const ChatUserCard({super.key, this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  MessageM? _message;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: DeviceInfo.width(4)),
        width: DeviceInfo.width(100),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: GestureDetector(
            onTap: () {
              AppNavigator.push(
                  screen: ChatScreen(user: widget.user),
                  effect: AppRouteEffect.rightToLeft);
            },
            child: StreamBuilder(
                stream: APIs.getLastMessage(widget.user!),
                builder: (context, snapshot) {
                  final data = snapshot.data?.docs;
                  final list =
                      data?.map((e) => MessageM.fromJson(e.data())).toList() ??
                          [];
                  if (list.isNotEmpty) {
                    _message = list.first;
                  }
                  return ListTile(
                    leading: Container(
                      width: DeviceInfo.width(13),
                      height: DeviceInfo.width(13),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: widget.user!.image == ""
                          ? CircleAvatar(child: Icon(Icons.person))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                widget.user!.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    title: Text(widget.user!.name!),
                    subtitle: Text(
                      _message != null ? _message!.msg! : widget.user!.about!,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: _message != null &&
                                (_message!.read!.isEmpty &&
                                    _message!.fromId != APIs.user.uid)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: _message == null
                        ? null
                        : Container(
                            width: DeviceInfo.width(3),
                            height: DeviceInfo.width(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: _message!.read!.isEmpty &&
                                      _message!.fromId != APIs.user.uid
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
