import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/fonts.dart';

class HeaderContactScreen extends StatelessWidget {
  final String title;
  final VoidCallback? back;
  final VoidCallback? backEdit;

  const HeaderContactScreen({
    Key? key,
    required this.title,
    this.back,
    this.backEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.h,
      child: Row(
        children: [
          back != null
              ? IconButton(
                  onPressed: back,
                  icon: const Icon(Icons.arrow_back_ios),
                )
              : const SizedBox(),
          Expanded(
            child: Text(
              title,
              style: textBlackStyleSubTitle,
            ),
          ),
          back != null
              ? IconButton(
                  onPressed: backEdit,
                  icon: const Icon(
                    Icons.edit_rounded,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
