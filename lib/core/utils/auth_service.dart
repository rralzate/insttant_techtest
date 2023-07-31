import 'package:flutter/material.dart';

import 'package:insttant_plus_mobile/features/auth/presentation/screens/login_screen.dart';

import '../routes/navigators.dart';

/// For managing the authentication logic
class AuthService {
  bool isUserLoggedIn() {
    // Update as per logged in logic
    return true;
  }

  void logoutUser({String? reason}) {
    // Logout the user

    Navigator.pushReplacementNamed(
        globalNavigatorKey.currentState!.context, LoginScreen.routeName);
  }
}
