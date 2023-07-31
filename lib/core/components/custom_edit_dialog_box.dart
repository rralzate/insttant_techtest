import 'package:flutter/material.dart';
import 'package:insttant_plus_mobile/core/theme/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/fonts.dart';

class CustomEditDialogBox extends StatefulWidget {
  final Widget? icon;
  final String? title;
  final String? descriptions;
  final String? confirmText;
  final String cancelText;
  final VoidCallback? onAccept;
  final VoidCallback onCancel;
  final Widget? widgetDescription;
  final bool? showConfirmButton;

  const CustomEditDialogBox({
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

  const CustomEditDialogBox.widgetContent({
    super.key,
    this.icon,
    this.descriptions,
    required this.widgetDescription,
    this.title,
    required this.confirmText,
    required this.onAccept,
    required this.onCancel,
    required this.cancelText,
    required this.showConfirmButton,
  });

  const CustomEditDialogBox.withoutConfirm({
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
  State<CustomEditDialogBox> createState() => _CustomConfirmDialogBox();
}

class _CustomConfirmDialogBox extends State<CustomEditDialogBox> {
  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  Widget contentBox(context) {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 19, bottom: 10),
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
              mainAxisAlignment: MainAxisAlignment.start,
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
