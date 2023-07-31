import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/fonts.dart';

class HeaderBaseScreen extends StatelessWidget {
  final String title;
  final VoidCallback? back;

  const HeaderBaseScreen({
    Key? key,
    required this.title,
    this.back,
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
          Text(
            title,
            style: textBlackStyleTitle,
          )
        ],
      ),
    );
  }
}
