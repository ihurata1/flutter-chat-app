import 'dart:math';

import 'package:flutter/material.dart';
import 'package:root/constants/app.dart';

class DeviceInfo {
  static MediaQueryData get mediaQuery => MediaQuery.of(Application.context);

  static get bottomPadding => max(DeviceInfo.mediaQuery.viewPadding.bottom, DeviceInfo.height(1.5));

  static double width(double width) {
    return MediaQuery.of(Application.context).size.width / 100.0 * width;
  }

  static double height(double height) {
    return MediaQuery.of(Application.context).size.height / 100.0 * height;
  }
}
