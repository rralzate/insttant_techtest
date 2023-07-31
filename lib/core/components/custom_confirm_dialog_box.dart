import 'package:flutter/material.dart';
import 'package:insttant_plus_mobile/core/theme/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/fonts.dart';

class CustomConfirmDialogBox extends StatefulWidget {
  final Widget? icon;
  final String? title;
  final String? descriptions;
  final String? confirmText;
  final String cancelText;
  final VoidCallback? onAccept;
  final VoidCallback onCancel;
  final Widget? widgetDescription;
  final bool? showConfirmButton;

  const CustomConfirmDialogBox({
    required this.descriptions,
    required this.confirmText,
    required this.onAccept,
    required this.onCancel,
    required this.cancelText,
    super.key,
    this.icon,
    this.title,
    this.widgetDescription,
  }) : showConfirmButton = true;

  const CustomConfirmDialogBox.widgetContent({
    super.key,
    this.icon,
    this.descriptions,
    required this.widgetDescription,
    required this.title,
    required this.confirmText,
    required this.onAccept,
    required this.onCancel,
    required this.cancelText,
    required this.showConfirmButton,
  });

  const CustomConfirmDialogBox.withoutConfirm({
    super.key,
    this.icon,
    required this.widgetDescription,
    required this.title,
    this.confirmText,
    this.onAccept,
    required this.onCancel,
    required this.cancelText,
    required this.showConfirmButton,
  }) : descriptions = '';

  @override
  State<CustomConfirmDialogBox> createState() => _CustomConfirmDialogBox();
}

class _CustomConfirmDialogBox extends State<CustomConfirmDialogBox> {
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
    return Container(
      padding: EdgeInsets.only(left: 18, top: 5.h, right: 18, bottom: 20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.icon != null
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    child: widget.icon,
                  )
                : const SizedBox(),
            if (widget.title != null)
              Text(
                widget.title!,
                style: textBlackStyleSubTitle,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 1.5.h),
            widget.descriptions != null && widget.widgetDescription != null
                ? Column(
                    children: [
                      Text(
                        widget.descriptions!,
                        style: textBlackStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.h),
                    ],
                  )
                : const SizedBox(),
            widget.widgetDescription ??
                Text(
                  widget.descriptions ?? '',
                  style: textBlackStyle,
                  textAlign: TextAlign.center,
                ),
            SizedBox(height: 2.2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    child: Text(widget.cancelText, style: textBlueStyle),
                  ),
                ),
                Visibility(
                  visible: widget.showConfirmButton ?? false,
                  child: Expanded(
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
                          vertical: 1.5.h,
                        ),
                        child: Text(
                          widget.confirmText ?? '',
                          style: textWhiteStyle,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
