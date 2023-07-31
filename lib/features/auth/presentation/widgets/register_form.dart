import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/svg.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_input.dart';
import '../../../../core/components/primary_button.dart';
import '../../../../core/routes/resource_icons.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/fonts.dart';

import '../../domain/entities/new_user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/utils/encrypt.dart';

class RegisterForm extends StatefulWidget {
  final AuthBloc authBloc;
  final List<String> countries;
  final List<String> genders;

  const RegisterForm({
    required this.authBloc,
    required this.countries,
    required this.genders,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TapGestureRecognizer tapGestureRecognizer;
  TextEditingController dateInputController = TextEditingController();
  bool isGuatemala = true;
  final FocusNode _nodeTextField1 = FocusNode();
  final FocusNode _nodeTextField2 = FocusNode();
  final FocusNode _nodeTextField3 = FocusNode();
  final FocusNode _nodeTextField4 = FocusNode();

  final sDateFormate = 'dd/MM/yyyy';

  bool hasPasswordValue = false;

  @override
  void initState() {
    tapGestureRecognizer = TapGestureRecognizer();
    dateInputController.text = '';

    super.initState();
  }

  @override
  void dispose() {
    tapGestureRecognizer.dispose();
    dateInputController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginBloc = widget.authBloc;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          children: [
            _middleView(loginBloc, context, state),
            _bottomButton(authBloc: loginBloc, context: context, state: state)
          ],
        );
      },
    );
  }

  Widget _middleView(AuthBloc authBloc, BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: authBloc.nameStream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            return CustomInput(
              focusNode: _nodeTextField1,
              placeholder: 'Nombre de usuario*',
              keyboardType: TextInputType.name,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              maxLength: 50,
              onChanged: (text) {
                authBloc.updateName(
                  text,
                );
              },
            );
          },
        ),
        SizedBox(height: 2.h),
        StreamBuilder(
          stream: authBloc.emailStream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            return CustomInput(
              maxLength: 50,
              focusNode: _nodeTextField2,
              placeholder: 'Correo electrónico*',
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                child: SvgPicture.asset(emailInvisibleSVG),
              ),
              keyboardType: TextInputType.emailAddress,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              onChanged: (text) {
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
                      eyeVisibleSVG,
                      color: highlightRed,
                    )
                  : SvgPicture.asset(
                      eyeInvisibleSVG,
                      color: highlightRed,
                    ),
            );
            return CustomInput(
              focusNode: _nodeTextField3,
              placeholder: 'Contraseña*',
              maxLength: 60,
              keyboardType: TextInputType.emailAddress,
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 12.0),
                child: iconVisibility,
              ),
              obscureText: !visibility,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              onChanged: (text) {
                authBloc.updatePassword(text);
                setState(() {
                  hasPasswordValue = text.isNotEmpty;
                });
              },
            );
          },
        ),
        SizedBox(height: 2.h),
        Visibility(
          visible: hasPasswordValue,
          child: StreamBuilder(
            stream: authBloc.passwordConfirmtream,
            builder: (_, AsyncSnapshot<String> snapshot) {
              final visibility = state.showPasswordConfirm;
              final iconVisibility = GestureDetector(
                onTap: () {
                  authBloc.add(
                      ShowPasswordConfirmEvent(!state.showPasswordConfirm));
                },
                child: visibility
                    ? SvgPicture.asset(eyeVisibleSVG)
                    : SvgPicture.asset(eyeInvisibleSVG),
              );
              return CustomInput(
                focusNode: _nodeTextField4,
                placeholder: 'Confirmar Contraseña*',
                maxLength: 60,
                keyboardType: TextInputType.emailAddress,
                suffixIcon: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12.0),
                  child: iconVisibility,
                ),
                obscureText: !visibility,
                errorText: snapshot.hasError ? snapshot.error.toString() : null,
                onChanged: (text) {
                  authBloc.updatePasswordConfirm(text);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Bottom Button for login in netvoz
  Container _bottomButton({
    required AuthBloc authBloc,
    required BuildContext context,
    required AuthState state,
  }) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.fromLTRB(1.w, 5.h, 1.h, 5.h),
      child: StreamBuilder(
        stream: authBloc.validateRegisterForm,
        builder: (context, snapshot) {
          return PrimaryButton(
            onPressed: snapshot.hasData
                ? () async {
                    FocusScope.of(context).unfocus();

                    NewUserEntity infoUserRegisterEntity = NewUserEntity(
                      name: await authBloc.nameStream.first,
                      email: encryptText(await authBloc.emailStream.first),
                      password:
                          encryptText(await authBloc.passwordStream.first),
                    );
                    authBloc.add(
                      PostRegisterUserEvent(
                        infoUserRegisterEntity: infoUserRegisterEntity,
                      ),
                    );
                  }
                : null,
            height: 7.h,
            child: Text(
              'Confirmar',
              style: snapshot.hasData
                  ? textWhiteStyleButton
                  : textBlackStyleButton,
            ),
          );
        },
      ),
    );
  }
}
