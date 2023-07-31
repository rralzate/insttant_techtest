import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:insttant_plus_mobile/features/user/domain/entities/contact_entity.dart';
import 'package:insttant_plus_mobile/features/user/presentation/bloc/user_bloc.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/components/custom_confirm_dialog_box.dart';

import '../../../../core/components/custom_input.dart';

import '../../../../core/components/notifications_service.dart';
import '../../../../core/injection/injection_container.dart';

import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/fonts.dart';

class NewContactUserData extends StatefulWidget {
  final BuildContext ctx;
  final int contactId;
  final VoidCallback onConfirmData;
  final VoidCallback onCancel;
  final int? phone;
  final String? name;

  const NewContactUserData({
    required this.ctx,
    required this.onConfirmData,
    required this.onCancel,
    required this.contactId,
    this.phone,
    this.name,
    super.key,
  });

  @override
  State<NewContactUserData> createState() => _NewContactUserDataState();
}

class _NewContactUserDataState extends State<NewContactUserData> {
  final userBloc = getIt<UserBloc>();
  final FocusNode _nodeTextField1 = FocusNode();
  final FocusNode _nodeTextField2 = FocusNode();
  TextEditingController nameControllerText = TextEditingController();
  TextEditingController phoneControllerText = TextEditingController();
  List<ContactEntity> listContacts = [];

  List<String> countriesNames = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    sinkValuesOnUserConctacts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: userBloc,
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
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return _principalBody();
        },
      ),
    );
  }

  StreamBuilder<Object> _principalBody() {
    return StreamBuilder<Object>(
      stream: userBloc.validateUserDataModalUpdate,
      builder: (context, snapshot) {
        return CustomConfirmDialogBox.widgetContent(
          title: 'Contacto',
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
            widget.onCancel();
            Navigator.pop(context);
          },
          onAccept: snapshot.hasData
              ? () async {
                  String name = await userBloc.nameStream.first;
                  String phone = await userBloc.phoneStream.first;

                  ContactEntity contactEntity = ContactEntity(
                    name: name,
                    phone: int.parse(phone),
                    id: widget.contactId,
                  );

                  // ignore: use_build_context_synchronously
                  context
                      .read<UserBloc>()
                      .add(InsertContactUserEvent(entity: contactEntity));
                }
              : null,
        );
      },
    );
  }

  Widget _body() {
    return Column(
      children: [
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
          stream: userBloc.nameFieldController.stream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            // userBloc.add(OnHasError(snapshot.hasError));
            // userBloc.add(OnErrorMessage(snapshot.error.toString()));
            return CustomInput(
              focusNode: _nodeTextField1,
              controller: nameControllerText,
              placeholder: 'Nombre',
              keyboardType: TextInputType.text,
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              maxLength: 50,
              onChanged: (text) {
                userBloc.updateName(text);
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
          stream: userBloc.phoneFieldController.stream,
          builder: (_, AsyncSnapshot<String> snapshot) {
            // userBloc.add(OnHasError(snapshot.hasError));
            // userBloc.add(OnErrorMessage(snapshot.error.toString()));
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
                userBloc.updatePhone(text);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _verticalSeparator() => SizedBox(height: 1.h);

  void sinkValuesOnUserConctacts() {
    if (widget.name != null && widget.name!.isNotEmpty) {
      userBloc.updateName(widget.name!);
      nameControllerText.text = widget.name!;
    }
    if (widget.phone != null && widget.phone! > 0) {
      userBloc.updatePhone(widget.phone!.toString());
      phoneControllerText.text = widget.phone!.toString();
    }
  }
}
