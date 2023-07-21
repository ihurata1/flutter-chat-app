import 'package:flutter/material.dart';
import 'package:root/constants/navigator/page_route_effect.dart';

class PageRouteTransitionBuilder extends PageRouteBuilder {
  PageRouteTransitionBuilder({
    required Widget page,
    AppRouteEffect effect = AppRouteEffect.fade,
    Curve curve = Curves.ease,
    Duration duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  })  : this.page = page,
        this.effect = effect,
        this.curve = curve,
        this.duration = duration,
        super(
        pageBuilder: (_, __, ___) => page,
        settings: settings,
        transitionDuration: effect == AppRouteEffect.none ? Duration.zero : duration,
        reverseTransitionDuration: effect == AppRouteEffect.none ? Duration.zero : duration,
      );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    switch (effect) {
      case AppRouteEffect.none:
      case AppRouteEffect.theme:
        return Theme.of(context).pageTransitionsTheme.buildTransitions(this, context, animation, secondaryAnimation, child);
      case AppRouteEffect.fade:
        return FadeTransition(opacity: animation, child: child);
      case AppRouteEffect.scale:
        return ScaleTransition(scale: animation, child: child);
      default:
        var tween = Tween(begin: effect.value, end: Offset.zero).chain(CurveTween(curve: curve));
        return SlideTransition(
          transformHitTests: false,
          position: animation.drive(tween),
          child: child,
        );
    }
  }

  /// Transition type
  ///
  /// Default to [AppRouteEffect.FADE]
  final AppRouteEffect effect;

  /// The widget below this widget in the tree
  final Widget page;

  /// The duration the transition going reverse and forwards
  final Duration duration;

  /// An parametric animation easing curve, i.e. a mapping of the unit interval to the unit interval.
  ///
  /// Default to [Curves.ease]
  final Curve curve;
}