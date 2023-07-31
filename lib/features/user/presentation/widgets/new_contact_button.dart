import 'package:flutter/material.dart';
import 'package:insttant_plus_mobile/core/theme/colors.dart';

import '../../../../core/utils/alert_dialogs.dart';

class NewContactButton extends StatefulWidget {
  const NewContactButton({
    Key? key,
    required this.onAccept,
  }) : super(key: key);

  final VoidCallback? onAccept;

  @override
  State<NewContactButton> createState() => _NewContactButtonState();
}

class _NewContactButtonState extends State<NewContactButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5,
      backgroundColor: mainGrey,
      onPressed: () async {
        await confirmUserDataDialog(
          context: context,
          contactId: 0,
        );
      },
      child: const Icon(
        Icons.add_rounded,
        color: highlightRed,
      ),
    );
  }
}
