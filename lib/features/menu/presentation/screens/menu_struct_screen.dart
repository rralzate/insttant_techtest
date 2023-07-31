import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insttant_plus_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:insttant_plus_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/routes/navigators.dart';

import '../../../../core/routes/navigators_observers.dart';
import '../../../../core/routes/page_generator.dart';
import '../../../../core/theme/colors.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/menu_bloc.dart';
import '../widgets/custom_bottom_tab_bar.dart';
import '../widgets/custom_tab_scaffold.dart';
import '../widgets/icon_tab_builder.dart';

class MenuStructScreen extends StatefulWidget {
  const MenuStructScreen({super.key});

  static const routeName = '/menu';

  @override
  State<MenuStructScreen> createState() => _MenuStructScreenState();
}

class _MenuStructScreenState extends State<MenuStructScreen> {
  int _selectBottomTabIndex = 0;
  AuthBloc authBLoc = getIt<AuthBloc>();
  MenuBloc menuBloc = getIt<MenuBloc>();

  final pageBuilder = {
    0: PageClassGenerator().buildHomeTabPage,
    1: PageClassGenerator().buildContactsTabPage,
  };

  final navigators = {
    0: homeTabNavigator,
    1: contactsTabNavigar,
  };

  final navigatorsObservers = {
    0: homeTabNavigatorObserver,
    1: contactsTabNavigatorObserver,
  };

  Future<void> _restartLogin({
    required String typePage,
    required BuildContext parentContext,
  }) async {
    Navigator.popUntil(
        context, (route) => route.settings.name == MenuStructScreen.routeName);

    if (typePage == 'login') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pushReplacementNamed(parentContext, RegisterScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handlerInternalNavigationInTab,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MenuBloc>(create: (_) {
            return menuBloc;
          }),
          BlocProvider<AuthBloc>(create: (_) {
            return authBLoc;
          }),
        ],
        child: BlocConsumer<MenuBloc, MenuState>(builder: (context, state) {
          return CustomCupertinoTabScaffold(
            tabBuilder: _tab,
            tabBar: _bottomNavBar(),
          );
        }, listener: (context, state) async {
          if (state.closeSession) {
            authBLoc.add(LogOutUserEvent());
            await _restartLogin(
              typePage: 'login',
              parentContext: context,
            );
          }
        }),
      ),
    );
  }

  Future<bool> _handlerInternalNavigationInTab() async {
    final popped =
        await navigators[_selectBottomTabIndex]!.currentState!.maybePop();
    return !popped;
  }

  CustomCupertinoTabBar _bottomNavBar() {
    return CustomCupertinoTabBar(
      currentIndex: _selectBottomTabIndex,
      onTap: _tabIconPressed,
      activeColor: Theme.of(context).colorScheme.primary,
      inactiveColor: Theme.of(context).colorScheme.surface,
      backgroundColor: colorWhite,
      border: Border(
        top: BorderSide(
          color: mainGrey,
          width: 0.1.w,
        ),
      ),
      height: 8.h,
      items: [
        BottomNavigationBarItem(
          icon: IconTabView(
            index: 0,
            imageIcon: Icons.home_rounded,
            isActiveColor: _selectBottomTabIndex == 0,
          ),
        ),
        BottomNavigationBarItem(
          icon: IconTabView(
            index: 1,
            imageIcon: Icons.contact_phone_rounded,
            isActiveColor: _selectBottomTabIndex == 1,
          ),
        ),
      ],
    );
  }

  void _tabIconPressed(int index) {
    if (_selectBottomTabIndex != index) {
      setState(() {
        _selectBottomTabIndex = index;
      });
    } else {
      while (navigators[index]!.currentState!.canPop()) {
        navigators[index]?.currentState?.pop();
      }
    }
  }

  Widget _tab(BuildContext context, int tabIndex) {
    if (pageBuilder.containsKey(tabIndex)) {
      return CupertinoTabView(
        onGenerateRoute: pageBuilder[tabIndex],
        navigatorKey: navigators[tabIndex],
        navigatorObservers: [
          if (navigatorsObservers.containsKey(tabIndex))
            navigatorsObservers[tabIndex] as NavigatorObserver
        ],
      );
    } else {
      return const Material(
        child: Center(
          child: Text("Todavia no se ha aplicado"),
        ),
      );
    }
  }
}
