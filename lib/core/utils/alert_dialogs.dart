import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:insttant_plus_mobile/features/user/presentation/widgets/new_contact_user_data.dart';

import '../components/custom_dialog_box.dart';

import '../routes/resource_icons.dart';
import '../theme/colors.dart';

Future<void> showErrorDialog({
  required String message,
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return CustomDialogBox(
        icon: SvgPicture.asset(
          warningModalSVG,
          color: highlightRed,
        ),
        title: 'Lo sentimos',
        descriptions: message,
        confirmText: 'Aceptar',
        onAccept: () {
          Navigator.pop(ctx);
        },
      );
    },
  );
}

Future<bool> confirmUserDataDialog({
  required BuildContext context,
  required int contactId,
  String? name,
  int? phone,
}) async {
  Completer<bool> completer = Completer<bool>();
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return NewContactUserData(
        ctx: context,
        contactId: contactId,
        name: name,
        phone: phone,
        onConfirmData: () {
          completer.complete(true);
        },
        onCancel: () {
          completer.complete(false);
        },
      );
    },
  );

  return completer.future;
}
