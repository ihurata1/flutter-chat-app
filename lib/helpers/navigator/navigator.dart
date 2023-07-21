import 'package:flutter/cupertino.dart';

import '../../constants/app.dart';
import '../../constants/navigator/page_route_effect.dart';
import '../../screens/home.dart';
import 'builder.dart';

class AppNavigator {
  static push({required Widget screen, required AppRouteEffect effect, Function(dynamic? value)? callback}) {
    PageRouteTransitionBuilder builder = PageRouteTransitionBuilder(
      page: screen,
      effect: effect,
      settings: RouteSettings(name: screen.runtimeType.toString()),
    );
    print(screen.runtimeType.toString());
    Navigator.of(Application.context).push(builder).then((value) {
      if (callback != null) callback(value);
    });
  }

  static pushScreenWithoutEffect({required Widget screen, Function(dynamic? value)? callback, String? routeName}) {
    PageRouteTransitionBuilder builder = PageRouteTransitionBuilder(
      page: screen,
      settings: RouteSettings(name: screen.runtimeType.toString()),
    );
    Navigator.of(Application.context).push(builder).then((value) {
      if (callback != null) callback(value);
    });
  }

  static pushAndRemoveUntil({required Widget screen, required AppRouteEffect effect, Function(dynamic? value)? callback}) {
    PageRouteTransitionBuilder builder = PageRouteTransitionBuilder(
      page: screen,
      effect: effect,
      settings: RouteSettings(name: screen.runtimeType.toString()),
    );

    Navigator.of(Application.context).pushAndRemoveUntil(builder, (_) => false).then((value) {
      if (callback != null) callback(value);
    });
  }

  static pop({dynamic? value}) {
    if (Navigator.of(Application.context).canPop()) {
      Navigator.of(Application.context).pop(value);
    } else {
      AppNavigator.pushAndRemoveUntil(screen: HomeScreen(), effect: AppRouteEffect.leftToRight);
    }
  }
}
