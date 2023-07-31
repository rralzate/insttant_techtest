import 'package:flutter/material.dart';
import 'package:insttant_plus_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:insttant_plus_mobile/features/user/domain/entities/params_contact_edit.dart';

import 'package:insttant_plus_mobile/features/user/presentation/screens/contacts_screen.dart';
import 'package:insttant_plus_mobile/features/user/presentation/screens/user_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:insttant_plus_mobile/features/auth/presentation/screens/splash_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/menu/presentation/screens/menu_struct_screen.dart';

import '../../features/user/presentation/screens/new_contact_screen.dart';

/// It is a class that allows you to manipulate screen navigation without losing instances and references of elements
/// in the navigation tree in order to persist the navigation structure and user experience.

class PageClassGenerator {
  /// This method is for global  generics screens navigation routes
  static Route<dynamic> getNamedScreen(RouteSettings routeSettings) {
    Widget Function(BuildContext) builder;

    switch (routeSettings.name) {
      case SplashScreen.routeName:
        builder = (context) => const SplashScreen();
        break;
      case LoginScreen.routeName:
        builder = (context) => const LoginScreen();
        break;
      case RegisterScreen.routeName:
        builder = (context) => const RegisterScreen();
        break;
      case MenuStructScreen.routeName:
        builder = (context) => const MenuStructScreen();
        break;
      default:
        builder = (context) => const Material(
              child: Center(child: Text("Todavia no se ha aplicado")),
            );
    }
    return _commonPageWrappper(
      routeSettings: routeSettings,
      builder: builder,
    );
  }

  Route<dynamic> buildHomeTabPage(RouteSettings routeSettings) {
    Widget Function(BuildContext) builder;
    switch (routeSettings.name) {
      case UserSreen.routeName:
        builder = (context) => const UserSreen();
        break;

      default:
        builder = (context) => const Material(
              child: Center(child: Text("Todavia no se ha aplicado")),
            );
    }
    return _commonPageWrappper(
      routeSettings: routeSettings,
      builder: builder,
    );
  }

  Route<dynamic> buildContactsTabPage(RouteSettings routeSettings) {
    Widget Function(BuildContext) builder;
    switch (routeSettings.name) {
      case ContactsScreen.routeName:
        builder = (context) => const ContactsScreen();
        break;
      case NewContactScreen.routeName:
        builder = (context) => NewContactScreen(
              paramsContactEditScreen:
                  routeSettings.arguments as ParamsContactEditScreen,
            );
        break;

      default:
        builder = (context) => const Material(
              child: Center(child: Text("Todavia no se ha aplicado")),
            );
    }
    return _commonPageWrappper(
      routeSettings: routeSettings,
      builder: builder,
    );
  }

  /// Configuration method to create our own navigation
  static Route<dynamic> _commonPageWrappper({
    required RouteSettings routeSettings,
    required Widget Function(BuildContext) builder,
  }) {
    return MaterialWithModalsPageRoute(
        settings: routeSettings,
        builder: (context) => Container(
              color: Colors.black.withOpacity(0.4),
              child: SafeArea(
                top: false,
                bottom: false,
                child: builder(context),
              ),
            ));
  }
}
