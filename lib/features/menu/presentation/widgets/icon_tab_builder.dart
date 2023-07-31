import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/theme/colors.dart';

class IconTabView extends StatefulWidget {
  final IconData imageIcon;
  final int index;
  final bool isActiveColor;

  const IconTabView({
    super.key,
    required this.index,
    required this.imageIcon,
    this.isActiveColor = false,
  });

  @override
  State<IconTabView> createState() => _IconTabViewState();
}

class _IconTabViewState extends State<IconTabView> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: widget.isActiveColor
          ? Theme.of(context).colorScheme.secondary
          : colorWhite,
      child: Icon(
        widget.imageIcon,
        color: widget.isActiveColor
            ? colorWhite
            : Theme.of(context).colorScheme.secondary,
        size: 3.h,
      ),
      // child: SvgPicture.asset(
      //   widget.imageIcon,
      //   height: 2.h,
      //   color: widget.isActiveColor ? mainWhite : secondColor,
      // ),
    );
  }
}
