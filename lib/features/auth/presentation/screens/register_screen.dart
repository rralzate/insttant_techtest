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
import '../../../../core/theme/fonts.dart';

import '../../../../core/widgets/header.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/register_form.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthBloc authBloc = getIt<AuthBloc>();
  bool _isLoading = false;

  List<String> countries = [];
  List<String> genders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: BlocProvider.value(
          value: authBloc,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is LoadingPostRegisterUserState) {
                _isLoading = true;
              }
              if (state is FailedPostRegisterUserState) {
                _errorMessage(state.error);
                _isLoading = false;
              }

              if (state is SuccessPostRegisterUserState) {
                _isLoading = false;

                if (state.responseEntity.success) {
                  _successRegister();
                } else {
                  await _errorMessage(
                    state.responseEntity.messageResponse.description,
                  );
                }
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  _principalBody(),
                  Visibility(
                    visible: _isLoading,
                    child: const CustomLoadingScreen(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _successRegister() {
    NotificationsService.showSnackBar(
      '¡Listo!',
      'Tu cuenta ha sido creada exitosamente.',
      context,
    );

    Navigator.pushNamed(
      context,
      LoginScreen.routeName,
    );
  }

  Widget _titleScreen() {
    return Text(
      'Datos personales',
      style: textBlackStyleSubTitle,
    );
  }

  Widget _principalBody() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      children: [
        HeaderBaseScreen(
          title: 'Registrarse',
          back: () =>
              Navigator.pushReplacementNamed(context, LoginScreen.routeName),
        ),
        SizedBox(height: 2.h),
        _titleScreen(),
        SizedBox(height: 2.h),
        RegisterForm(
          authBloc: authBloc,
          countries: countries,
          genders: genders,
        ),
      ],
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
          title: '',
          descriptions: message,
          confirmText: 'Lo sentimos',
          onAccept: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
