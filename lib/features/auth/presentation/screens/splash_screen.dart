import 'package:insttant_plus_mobile/core/theme/colors.dart';

import 'package:flutter/material.dart';

import 'package:insttant_plus_mobile/core/routes/resource_icons.dart';

import '../../../menu/presentation/screens/menu_struct_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  ///Nombre de pantallla y ruta de navegacion
  static const routeName = "/";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    processScreen();
    super.initState();
  }

  Future<void> processScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, MenuStructScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSplashScreen,
      body: SafeArea(
        child: _mainScreen(),
      ),
    );
  }

  Widget _mainScreen() {
    return Stack(
      children: [
        _backgroundSplash(),
      ],
    );
  }

  Widget _backgroundSplash() {
    return SizedBox.expand(
      child: Image.asset(backgroundSplash),
    );
  }
}
