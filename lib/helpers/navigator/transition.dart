import 'package:flutter/material.dart';

import '../../constants/navigator/page_route_effect.dart';
import 'builder.dart';

class AppPageRouteTransition {
  AppPageRouteTransition._();

  static final AppPageRouteTransition _transition = AppPageRouteTransition._();

  factory AppPageRouteTransition() => _transition;

  /// Transition type
  static AppRouteEffect effect = AppRouteEffect.theme;

  /// An parametric animation easing curve, i.e. a mapping of the unit interval to the unit interval.
  static Curve curve = Curves.ease;

  /// Data that might be useful in constructing a [Route].
  static RouteSettings? settings;

  /// The duration the transition going reverse and forwards
  static Duration duration = const Duration(milliseconds: 300);

  static Future push(BuildContext context, Widget page) async {
    return Navigator.push(context, PageRouteTransitionBuilder(page: page, effect: effect, curve: curve, settings: settings, duration: duration));
  }

  static Future pushReplacement(BuildContext context, Widget page) async {
    return Navigator.pushReplacement(context, PageRouteTransitionBuilder(page: page, effect: effect, curve: curve, settings: settings, duration: duration));
  }

  static Future pop<T extends Object?>(BuildContext context, [T? result]) async {
    if (Navigator.canPop(context)) Navigator.pop(context, result);
  }
}