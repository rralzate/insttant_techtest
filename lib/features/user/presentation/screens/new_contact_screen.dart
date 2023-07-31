import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insttant_plus_mobile/core/theme/colors.dart';
import 'package:insttant_plus_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:insttant_plus_mobile/features/user/presentation/screens/contacts_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_confirm_dialog_box.dart';
import '../../../../core/components/custom_edit_dialog_box.dart';
import '../../../../core/components/custom_input.dart';
import '../../../../core/components/custom_loading.dart';
import '../../../../core/components/notifications_service.dart';
import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/fonts.dart';
import '../../../../core/widgets/header.dart';
import '../../domain/entities/contact_entity.dart';
import '../../domain/entities/params_contact_edit.dart';

class NewContactScreen extends StatefulWidget {
  const NewContactScreen({
    super.key,
    required this.paramsContactEditScreen,
  });
  static const routeName = '/new-contact-screen';
  final ParamsContactEditScreen paramsContactEditScreen;

  @override
  State<NewContactScreen> createState() => _NewContactScreenState();
}

class _NewContactScreenState extends State<NewContactScreen> {
  final FocusNode _nodeTextField1 = FocusNode();
  final FocusNode _nodeTextField2 = FocusNode();
  TextEditingController nameControllerText = TextEditingController();
  TextEditingController phoneControllerText = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    sinkValuesOnUserConctacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      body: SafeArea(
        child: BlocProvider.value(
          value: widget.paramsContactEditScreen.userBloc,
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) async {
              // ------// ------// ------// ------// ------// ------// ------
              if (state is LoadingInsertUpdateContactState) {
                setState(() {
                  _isLoading = true;
                });
              }
              if (state is FailedInsertUpdateContactState) {
                setState(() {
                  _isLoading = false;
                });
              }
              if (state is SuccessInsertUpdateContactState) {
                setState(() {
                  _isLoading = false;
                });
                NotificationsService.showSnackBar(
                  '¡Listo!',
                  'Contacto creado exitosamente.',
                  context,
                );
                _success();
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

  Widget _principalBody() {
    return StreamBuilder<Object>(
      stream:
          widget.paramsContactEditScreen.userBloc.validateUserDataModalUpdate,
      builder: (context, snapshot) {
        return CustomEditDialogBox.widgetContent(
          widgetDescription: _isLoading
              ? Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset(loadingGIF),
                  ),
                )
              : _body(),
          confirmText: 'Aceptar',
          cancelText: 'Cancelar',
          showConfirmButton: true,
          onCancel: () {
            //widget.onCancel();
            Navigator.pop(context);
          },
          onAccept: snapshot.hasData
              ? () async {
                  await _showDialogForDeleteAccount(
                    onAccept: () async {
                      await editInsertContact(context);
                    },
                  );
                }
              : null,
        );
      },
    );
  }

  Future<void> editInsertContact(BuildContext context) async {
    String name =
        await widget.paramsContactEditScreen.userBloc.nameStream.first;
    String phone =
        await widget.paramsContactEditScreen.userBloc.phoneStream.first;

    ContactEntity contactEntity = ContactEntity(
      name: name,
      phone: int.parse(phone),
      id: widget.paramsContactEditScreen.contactEntity.id,
    );

    if (widget.paramsContactEditScreen.contactEntity.id == 0) {
      // Insert new contact
      final newContact = Contact()
        ..displayName = name
        ..phones = [Phone(phone)];
      await newContact.insert();
    }
    // ignore: use_build_context_synchronously
    context.read<UserBloc>().add(InsertContactUserEvent(entity: contactEntity));
  }

  Widget _body() {
    return Column(
      children: [
        HeaderBaseScreen(
          title: 'Nuevo Contacto',
          back: () => Navigator.pop(context),
        ),
        _nameField(),
        _verticalSeparator(),
        _phoneField(),
      ],
    );
  }

  Widget _nameField() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            textAlign: TextAlign.start,
            'Nombre',
            style: textBlackStyleSubTitleBold,
          ),
        ),
        _verticalSeparator(),
        StreamBuilder(
          stream: widget
              .paramsContactEditScreen.userBloc.nameFieldController.stream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            // widget.userBloc.add(OnHasError(snapshot.hasError));
            // widget.userBloc.add(OnErrorMessage(snapshot.error.toString()));
            return CustomInput(
              focusNode: _nodeTextField1,
              controller: nameControllerText,
              placeholder: 'Nombre',
              keyboardType: TextInputType.text,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              maxLength: 50,
              onChanged: (text) {
                widget.paramsContactEditScreen.userBloc.updateName(text);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _phoneField() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            textAlign: TextAlign.start,
            'Teléfono',
            style: textBlackStyleSubTitleBold,
          ),
        ),
        _verticalSeparator(),
        StreamBuilder(
          stream: widget
              .paramsContactEditScreen.userBloc.phoneFieldController.stream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            // widget.userBloc.add(OnHasError(snapshot.hasError));
            // widget.userBloc.add(OnErrorMessage(snapshot.error.toString()));
            return CustomInput(
              focusNode: _nodeTextField2,
              controller: phoneControllerText,
              placeholder: 'Teléfono',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              obscureText: false,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              maxLines: 1,
              maxLength: 10,
              onChanged: (text) {
                widget.paramsContactEditScreen.userBloc.updatePhone(text);
              },
            );
          },
        ),
      ],
    );
  }

  void _success() {
    Navigator.pushReplacementNamed(
      context,
      ContactsScreen.routeName,
    );
  }

  Widget _verticalSeparator() => SizedBox(height: 1.h);

  void sinkValuesOnUserConctacts() {
    if (widget.paramsContactEditScreen.contactEntity.name.isNotEmpty) {
      widget.paramsContactEditScreen.userBloc
          .updateName(widget.paramsContactEditScreen.contactEntity.name);
      nameControllerText.text =
          widget.paramsContactEditScreen.contactEntity.name;
    }
    if (widget.paramsContactEditScreen.contactEntity.phone > 0) {
      widget.paramsContactEditScreen.userBloc.updatePhone(
          widget.paramsContactEditScreen.contactEntity.phone.toString());
      phoneControllerText.text =
          widget.paramsContactEditScreen.contactEntity.phone.toString();
    }
  }

  Future<void> _showDialogForDeleteAccount({
    required VoidCallback onAccept,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctex) {
        return CustomConfirmDialogBox(
          icon: SvgPicture.asset(
            warningModalSVG,
            color: highlightRed,
          ),
          title: '¿Estás seguro que deseas agregar el contacto?',
          confirmText: 'Aceptar',
          cancelText: 'Cancelar',
          descriptions:
              'Si agregas el contacto, se adicionará en los contactos del dispositivo.',
          onAccept: () async {
            Navigator.pop(ctex, false);
            onAccept();
          },
          onCancel: () async {
            Navigator.pop(ctex, false);
          },
        );
      },
    );
  }
}
