import 'package:flutter/material.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/screens/bank_cards/bank_cards_screen.dart';
import 'package:insurance_map/screens/cards_and_vehicles/cards_and_vehicles.dart';
import 'package:insurance_map/screens/categories/categories_screen.dart';
import 'package:insurance_map/screens/companies/companies_screen.dart';
import 'package:insurance_map/screens/content_view/content_view.dart';
import 'package:insurance_map/screens/insurance_request/insurance_request_screen.dart';
import 'package:insurance_map/screens/invite/invite_screen.dart';
import 'package:insurance_map/screens/main/main_screen.dart';
import 'package:insurance_map/screens/map_screen/map_screen.dart';
import 'package:insurance_map/screens/signup/signup_screen.dart';
import 'package:insurance_map/screens/social_responsibilities/social_responsibilities_screen.dart';
import 'package:insurance_map/screens/ticket/ticket.dart';
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
      case Routes.categoriesRoute:
        return const CategoriesScreen();
      case Routes.companiesRoute:
        return const CompaniesScreen();
      case Routes.mapRoute:
        return const MapScreen();
      case Routes.contentViewRoute:
        return const ContentViewScreen();
      case Routes.ticketRoute:
        return const TicketScreen();
      case Routes.inviteRoute:
        return const InviteScreen();
      case Routes.cardsAndVehiclesRoute:
        return const CardsAndVehiclesScreen();
      case Routes.insuranceRequestRoute:
        return const InsuranceRequestScreen();
      case Routes.SRRoute:
        return const SocialResponsibilitiesScreen();
    }
    return null;
  }
}
