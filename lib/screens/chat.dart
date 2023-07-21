// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:root/components/app_loading.dart';
import 'package:root/components/message_card.dart';
import 'package:root/constants/colors.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/model/message.dart';

import '../api/api.dart';
import '../model/user.dart';

class ChatScreen extends StatefulWidget {
  final UserM? user;

  const ChatScreen({super.key, this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageM> list = [];

  final _textController = TextEditingController();

  Widget _chatTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: DeviceInfo.width(2)),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Mesajınızı girin..",
                        hintStyle: TextStyle(color: AppColor.columbiaBlue),
                        border: InputBorder.none,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: MaterialButton(
              onPressed: () {
                log(_textController.text);
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(widget.user!, _textController.text);
                  _textController.clear();
                }
              },
              child: Icon(Icons.send, color: Colors.white),
              shape: CircleBorder(),
              color: Colors.indigo,
            ),
          )
        ],
      ),
    );
  }

  Widget get _appBar {
    return StreamBuilder(
        stream: APIs.getUserInfo(widget.user!),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => UserM.fromJson(e.data())).toList() ?? [];

          return ListTile(
            contentPadding: EdgeInsets.zero,
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
            title: Text(
              widget.user!.name!,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              list.isNotEmpty && list[0].isOnline!
                  ? 'Çevrim içi'
                  : 'Çevrim Dışı',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 12,
                  color: list.isNotEmpty && list[0].isOnline!
                      ? Colors.green
                      : Colors.grey),
            ),
          );
        });
  }

  Widget get _chatField {
    return Expanded(
      child: StreamBuilder(
          stream: APIs.getAllMessages(widget.user!),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return AppLoading();

              case ConnectionState.none:

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data?.map((e) => MessageM.fromJson(e.data())).toList() ??
                    [];
                /*list.add(MessageM(
                    toId: "x",
                    msg: "hi",
                    read: '12:00 AM',
                    type: 'Text',
                    fromId: APIs.user.uid,
                    sent: ''));
                list.add(MessageM(
                    toId: APIs.user.uid,
                    msg: "helloooo",
                    read: '',
                    type: 'Text',
                    fromId: 'x',
                    sent: '12:00 AM'));*/
                if (list.isNotEmpty) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: DeviceInfo.height(2)),
                    itemBuilder: ((context, index) {
                      return AppMessageCard(message: list[index]);
                    }),
                  );
                } else {
                  return Center(
                    child: Text(
                      "Say Hi! 👋",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  );
                }
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.indigo,
        title: Container(
          child: _appBar,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            _chatField,
            _chatTextField(),
          ],
        ),
      ),
    );
  }
}
