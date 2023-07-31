// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_dialog_box.dart';
import '../../../../core/components/custom_loading.dart';
import '../../../../core/components/notifications_service.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../menu/presentation/screens/menu_struct_screen.dart';
import '../../domain/entities/new_user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthBloc authBloc = getIt<AuthBloc>();
  NewUserEntity newUserEntity =
      const NewUserEntity(name: '', email: '', password: '');
  bool _isLoading = false;

  @override
  void dispose() {
    authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (_) {
                  return authBloc;
                },
              ),
            ],
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                // ------// ------// ------// ------// ------// ------// ------
                if (state is LoadingPostLoginEmailState) {
                  setState(() {
                    _isLoading = true;
                  });
                }

                if (state is FailedPostLoginEmailState) {
                  NotificationsService.showSnackBar(
                    'Error',
                    'credenciales invalidas',
                    context,
                  );
                  setState(() {
                    _isLoading = false;
                  });
                  _errorMessage(state.error);
                }
                if (state is SuccessPostLoginEmailState) {
                  setState(() {
                    _isLoading = false;
                  });

                  if (state.tokenEntity.success) {
                    await _success();
                  } else {
                    await _errorMessage(
                      state.tokenEntity.messageResponse.description,
                    );
                  }
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    _principalBody(context, authBloc),
                    Visibility(
                      visible: _isLoading,
                      child: const CustomLoadingScreen(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _principalBody(BuildContext context, AuthBloc loginBloc) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        SizedBox(height: 10.h),
        _titleScreen(),
        SizedBox(height: 1.h),
        LoginForm(
          newUserEntity: newUserEntity,
          loginBloc: loginBloc,
          callback: () {
            _isLoading = true;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _titleScreen() {
    return Align(
      alignment: Alignment.center,
      child: Image.asset(
        logo,
      ),
    );
  }

  Future<void> _success() async {
    Navigator.pushNamed(
      context,
      MenuStructScreen.routeName,
    );
  }

  Future<void> _errorMessage(String message) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogBox(
          icon: SvgPicture.asset(
            warningModalSVG,
            color: highlightRed,
          ),
          title: 'Lo sentimos',
          descriptions: message,
          confirmText: "Aceptar",
          onAccept: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
