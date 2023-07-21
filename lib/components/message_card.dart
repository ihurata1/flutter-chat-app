// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:root/api/api.dart';
import 'package:root/helpers/app_time_formatter.dart';
import 'package:root/helpers/device_info.dart';
import 'package:root/model/message.dart';

class AppMessageCard extends StatefulWidget {
  MessageM message;
  AppMessageCard({super.key, required this.message});

  @override
  State<AppMessageCard> createState() => _AppMessageCardState();
}

class _AppMessageCardState extends State<AppMessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _messageFromMe()
        : _messageFromOther();
  }

  Widget _messageFromOther() {
    if (widget.message.read!.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('message read update');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(DeviceInfo.width(3)),
            margin: EdgeInsets.symmetric(
                horizontal: DeviceInfo.width(2),
                vertical: DeviceInfo.height(0.6)),
            decoration: BoxDecoration(
                color: Colors.green.shade50,
                border: Border.all(width: 1, color: Colors.green),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg!,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: DeviceInfo.width(3)),
          child: Center(
              child: Text(
                  AppTimeFormat.getFormattedTime(
                      context: context, time: widget.message.sent!),
                  style: TextStyle(fontSize: 12))),
        )
      ],
    );
  }

  Widget _messageFromMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: DeviceInfo.width(3)),
            if (widget.message.read!.isNotEmpty)
              Icon(Icons.done_all, color: Colors.blue, size: 20),
            SizedBox(width: 2),
            Center(
              child: Text(
                AppTimeFormat.getFormattedTime(
                    context: context, time: widget.message.sent!),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(DeviceInfo.width(3)),
            margin: EdgeInsets.symmetric(
                horizontal: DeviceInfo.width(4),
                vertical: DeviceInfo.height(1.6)),
            decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                border: Border.all(width: 1, color: Colors.lightBlue),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            child: Text(
              widget.message.msg!,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
