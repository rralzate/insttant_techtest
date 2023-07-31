import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insttant_plus_mobile/core/components/custom_loading.dart';
import 'package:insttant_plus_mobile/core/widgets/user_card.dart';
import 'package:insttant_plus_mobile/features/auth/domain/entities/new_user_entity.dart';
import 'package:insttant_plus_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_confirm_dialog_box.dart';
import '../../../../core/components/primary_button.dart';
import '../../../../core/injection/injection_container.dart';
import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/fonts.dart';
import '../../../menu/presentation/bloc/menu_bloc.dart';

class UserSreen extends StatefulWidget {
  const UserSreen({super.key});

  static const String routeName = '/';

  @override
  State<UserSreen> createState() => _UserSreenState();
}

class _UserSreenState extends State<UserSreen> {
  final MenuBloc menuBloc = getIt<MenuBloc>();
  final UserBloc userBloc = getIt<UserBloc>();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _isEditing = false;

  File? _currentImage;

  NewUserEntity newUserEntity =
      const NewUserEntity(name: '', email: '', password: '');

  @override
  void initState() {
    userBloc.add(GetUserEvent());
    userBloc.add(GetImageUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserBloc>(create: (_) => userBloc),
            BlocProvider<MenuBloc>(create: (_) => menuBloc),
          ],
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is LoadingGetUserState) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is FailedGetUserState) {
                setState(() {
                  _isLoading = false;
                });
              }
              if (state is SuccessGetUserState) {
                setState(() {
                  newUserEntity = state.responseEntity;
                  _isLoading = false;
                });
              }
              if (state is SuccessGetImageUserState) {
                setState(() {
                  if (state.imagePath.isNotEmpty) {
                    _currentImage = File(state.imagePath);
                  }

                  _isLoading = false;
                });
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

  Widget _verticalSeparator() => SizedBox(height: 2.h);

  Widget _principalBody() {
    return Container(
      padding: EdgeInsets.all(5.w),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    newUserEntity.name,
                    style: GoogleFonts.jost(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: mainBlack,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => BlocProvider.of<MenuBloc>(context)
                        .add(CloseSessionEvent()),
                    icon: SvgPicture.asset(
                      logoutSVG,
                      width: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _header(),
          _verticalSeparator(),
        ],
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          UserCard(
            localImage: _currentImage,
            isChangeImage: _isEditing,
            profileImage:
                'https://grupofecuritydiag930.blob.core.windows.net/1imagenes/medium-image-user_default.png',
            isCardStyle: false,
            onChangeImage: _isEditing
                ? () async {
                    await _changeImageDialog();
                  }
                : null,
          ),
          TextButton(
            onPressed: () async {
              if (!_isEditing) {
                _isEditing = true;
                _initEditFields();
              } else {
                FocusScope.of(context).unfocus();
                _isEditing = false;
                setState(() {});
              }
            },
            child: Text(
              textAlign: TextAlign.start,
              _isEditing ? 'Guardar' : 'Editar',
              style: textBlueStyle,
            ),
          )
        ],
      ),
    );
  }

  void _initEditFields() {
    setState(() {
      _currentImage = null;
    });
  }

  Future<void> _changeImageDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomConfirmDialogBox.withoutConfirm(
          showConfirmButton: false,
          title: 'Cambiar imagen',
          confirmText: 'Confirmar',
          cancelText: 'Cancelar',
          widgetDescription: Column(
            children: [
              PrimaryButton(
                child: Text(
                  'Cámara',
                  style: textWhiteStyleButton,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _changeImage(ImageSource.camera);
                },
              ),
              SizedBox(height: 2.h),
              PrimaryButton(
                child: Text(
                  'Galería',
                  style: textWhiteStyleButton,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await _changeImage(ImageSource.gallery);
                },
              )
            ],
          ),
          onCancel: () {
            Navigator.pop(context, false);
          },
        );
      },
    );
  }

  Future<void> _changeImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _currentImage = File(image.path);
        userBloc.add(SaveImageUserEvent(imagePath: image.path));
      });
    }
  }
}
