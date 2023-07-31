import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../theme/colors.dart';
import '../theme/fonts.dart';

class CustomDialogBox extends StatefulWidget {
  final Widget? icon;
  final String title;
  final String descriptions;
  final String confirmText;
  final VoidCallback onAccept;
  final String? subDescriptions;

  const CustomDialogBox({
    Key? key,
    this.icon,
    required this.title,
    required this.descriptions,
    required this.confirmText,
    required this.onAccept,
    this.subDescriptions,
  }) : super(key: key);

  @override
  State<CustomDialogBox> createState() => _CustomDialogBox();
}

class _CustomDialogBox extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 20, top: 5.h, right: 20, bottom: 20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.icon != null
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 1.h),
                        child: widget.icon,
                      )
                    : const SizedBox(),
                Text(widget.title, style: textBlackStyleTitle),
                SizedBox(height: 1.5.h),
                Text(
                  widget.descriptions,
                  style: textBlackStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.subDescriptions ?? '',
                  style: textBlackStyleSubTitle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.2.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.onAccept,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: highlightRed,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 1.5.h,
                      ),
                      child: Text(widget.confirmText, style: textWhiteStyle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
