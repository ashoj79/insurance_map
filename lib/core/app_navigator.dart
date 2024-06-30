import 'package:flutter/material.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/screens/bank_cards/bank_cards_screen.dart';
import 'package:insurance_map/screens/main/main_screen.dart';
import 'package:insurance_map/screens/signup/signup_screen.dart';
import 'package:insurance_map/screens/vehicles_screen/vehicles_screen.dart';

class AppNavigator {
  static ValueNotifier<List<MaterialPage>> pages =
      ValueNotifier<List<MaterialPage>>(
          [const MaterialPage(child: MainScreen())]);

  static final Map<String, MaterialPage> _currentPages = {
    Routes.mainRoute: const MaterialPage(child: MainScreen())
  };

  static push(String route, {String popTo = '', Object? args}) {
    var screen = _getRouteScreen(route);
    if (screen == null) return;

    _popTo(popTo);

    _currentPages[route] = MaterialPage(child: screen, arguments: args);
    pages.value = _currentPages.values.toList();
  }

  static pop() {
    var lastRoute = _currentPages.keys.last;
    _currentPages.remove(lastRoute);
    pages.value = _currentPages.values.toList();
  }

  static popUntil(String route, [bool go = false]) {
    if (!_currentPages.keys.contains(route)) return;

    var allRoutes = _currentPages.keys.toList().reversed.toList();
    if (!go) allRoutes.removeAt(0);

    for (var element in allRoutes) {
      if (element == route) {
        if (go) pages.value = _currentPages.values.toList();
        return;
      }

      _currentPages.remove(element);
    }
  }

  static bool hasRoute() => _currentPages.length > 1;

  static String getCurrentRoute() => _currentPages.keys.last;

  static _popTo(String popRoute) {
    if (popRoute == '') return;

    var allRoutes = _currentPages.keys.toList().reversed;
    for (var element in allRoutes) {
      _currentPages.remove(element);

      if (element == popRoute) return;
    }
  }

  static Widget? _getRouteScreen(String route) {
    switch (route) {
      case Routes.mainRoute:
        return const MainScreen();
      case Routes.signupRoute:
        return const SignupScreen();
      case Routes.vehiclesRoute:
        return const VehiclesScreen();
      case Routes.bankCardsRoute:
        return const BankCardsScreen();
    }
    return null;
  }
}
