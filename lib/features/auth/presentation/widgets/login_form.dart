import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages

// ignore: depend_on_referenced_packages
import 'package:local_auth_ios/local_auth_ios.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_input.dart';
import '../../../../core/components/primary_button.dart';
import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/fonts.dart';

import '../../../../core/widgets/alerts.dart';
import '../../../menu/presentation/screens/menu_struct_screen.dart';
import '../../domain/entities/new_user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/utils/encrypt.dart';
import '../screens/register_screen.dart';

class LoginForm extends StatefulWidget {
  final AuthBloc loginBloc;
  final NewUserEntity newUserEntity;
  final VoidCallback callback;

  const LoginForm({
    super.key,
    required this.loginBloc,
    required this.newUserEntity,
    required this.callback,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LocalAuthentication localAuth;
  late TapGestureRecognizer tapGestureRecognizer;
  final FocusNode _nodeTextField1 = FocusNode();
  final FocusNode _nodeTextField2 = FocusNode();
  NewUserEntity newUserEntity =
      const NewUserEntity(name: '', email: '', password: '');
  bool isLoading = false;
  bool autentication = false;
  bool supportState = false;
  bool _isUserLogin = false;

  @override
  void initState() {
    widget.loginBloc.add(GetRegisterUserEvent());
    processScreen();
    tapGestureRecognizer = TapGestureRecognizer();
    localAuth = LocalAuthentication();
    localAuth.isDeviceSupported().then((bool isSupported) => setState(() {
          supportState = isSupported;
        }));
    super.initState();

    checkBiometrics();
  }

  Future<void> processScreen() async {
    bool isUserLogin = await widget.loginBloc.isUserLogin();
    if (isUserLogin) {
      _authenticate();
      setState(() {
        _isUserLogin = true;
      });
    }
  }

  @override
  void dispose() {
    tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = widget.loginBloc;
    return BlocProvider.value(
      value: authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoadingGetRegisterUserState) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is FailedGetRegisterUserState) {
            setState(() {
              isLoading = false;
            });
          }
          if (state is SuccessGetRegisterUserState) {
            setState(() {
              newUserEntity = state.responseEntity;
              isLoading = false;
            });
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _middleView(authBloc, context, state),
              SizedBox(
                height: 6.h,
              ),
              _bottomButton(authBloc: authBloc, context: context, state: state),
              SizedBox(
                height: 6.h,
              ),
              _iconButtonfaceId(),
              SizedBox(
                height: 1.h,
              ),
              _textButtonRegister(context),
            ],
          );
        },
      ),
    );
  }

  Widget _iconButtonfaceId() {
    return autentication && Platform.isIOS
        ? IconButton(
            onPressed: () {
              _authenticate();
            },
            iconSize: 15.w,
            icon: SvgPicture.asset(
              faceIdSVG,
              width: 15.w,
            ))
        : autentication && Platform.isAndroid
            ? IconButton(
                onPressed: () {
                  _authenticate();
                },
                iconSize: 15.w,
                icon: Image.asset(
                  huellaPNG,
                  width: 15.w,
                ))
            : const SizedBox();
  }

  Row _textButtonRegister(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.pushNamed(context, RegisterScreen.routeName);
        },
        child: Text(
          'Registrarse',
          style: textStyleNormal(mainBlue),
        ),
      ),
    ]);
  }

  /// Middle View to login form
  Column _middleView(AuthBloc authBloc, BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: authBloc.emailStream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            return CustomInput(
              maxLength: 80,
              focusNode: _nodeTextField1,
              placeholder: 'Usuario',
              keyboardType: TextInputType.emailAddress,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              onChanged: (text) {
                //Update email to validate
                authBloc.updateEmail(text);
              },
            );
          },
        ),
        SizedBox(height: 2.h),
        StreamBuilder(
          stream: authBloc.passwordStream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            final visibility = state.showPassword;
            final iconVisibility = GestureDetector(
              onTap: () {
                authBloc.add(ShowPasswordEvent(!state.showPassword));
              },
              child: visibility
                  ? SvgPicture.asset(
                      eyeVisibleBlueBackgroudSVG,
                      color: highlightRed,
                    )
                  : SvgPicture.asset(
                      eyeInvisibleSVG,
                      color: highlightRed,
                    ),
            );

            return CustomInput(
              focusNode: _nodeTextField2,
              placeholder: 'Contraseña',
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12.0),
                child: iconVisibility,
              ),
              obscureText: !visibility,
              onChanged: (text) {
                //Update password to validate
                authBloc.updatePassword(text);
              },
            );
          },
        ),
      ],
    );
  }

  /// Bottom Button for login in netvoz
  StreamBuilder _bottomButton({
    required AuthBloc authBloc,
    required BuildContext context,
    required AuthState state,
  }) {
    return StreamBuilder(
      stream: authBloc.validateLoginForm,
      builder: (context, snapshot) {
        return PrimaryButton(
          onPressed: snapshot.hasData
              ? () async {
                  Future<String> emailFuture = authBloc.emailStream.first;
                  String email = await emailFuture;
                  Future<String> passwordFuture = authBloc.passwordStream.first;
                  String password = await passwordFuture;
                  if (newUserEntity.email.isNotEmpty &&
                      newUserEntity.password.isNotEmpty) {
                    String desEncrypt = decryptText(newUserEntity.password);
                    if (desEncrypt == password) {
                      authBloc.add(PostLoginUserEvent(
                          userName: email, password: password));
                    } else {
                      // ignore: use_build_context_synchronously
                      NotificationsService.showSnackBar(
                        'Error',
                        'credenciales invalidas',
                        context,
                      );
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    NotificationsService.showSnackBar(
                      'ERROR',
                      'no tienes cuantas creadas',
                      context,
                    );
                  }
                }
              : null,
          height: 6.h,
          child: Text(
            'Iniciar sesión',
            style:
                snapshot.hasData ? textWhiteStyleButton : textBlackStyleButton,
          ),
        );
      },
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await localAuth.authenticate(
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            signInTitle: 'Authentication required!',
            biometricHint: '',
          ),
          const IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ],
        localizedReason:
            'Toca tu dedo en el sensor de huella digital \n ¡Tu huella es tu llave personal!',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
      if (authenticated && _isUserLogin) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamedAndRemoveUntil(
          context,
          MenuStructScreen.routeName,
          (value) => false,
        );
      } else {
        // ignore: use_build_context_synchronously
        NotificationsService.showSnackBar(
          'Alert',
          'inténtalo de nuevo o utiliza otro método de autenticación.',
          context,
        );
      }
    } catch (e) {
      NotificationsService.showSnackBar(
        'Alert',
        'Lo sentimos, no hemos podido reconocer tu biometría.\n Por favor, inténtalo de nuevo o utiliza otro método de autenticación.',
        context,
      );
    }
  }

  Future<void> checkBiometrics() async {
    final localAuthentica = LocalAuthentication();
    try {
      bool canCheckBiometrics = await localAuthentica.canCheckBiometrics;

      if (canCheckBiometrics) {
        setState(() {
          autentication = true;
        });
      } else {
        // ignore: use_build_context_synchronously
        NotificationsService.showSnackBar(
          'Alerta',
          'El dispositivo no tiene capacidad de autenticación biométrica.',
          context,
        );
      }
    } catch (e) {
      NotificationsService.showSnackBar(
        'Error',
        'Error al verificar la autenticación biométrica: $e',
        context,
      );

      setState(() {
        autentication = false;
      });
    }
  }
}
