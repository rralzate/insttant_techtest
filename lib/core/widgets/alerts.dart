import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../theme/colors.dart';
import '../theme/fonts.dart';

class NotificationsService {
  static SnackbarController showSnackBar(
    String title,
    String message,
    BuildContext context, {
    VoidCallback? onTap,
  }) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: colorSnack,
      margin: EdgeInsets.all(5.w),
      snackPosition: SnackPosition.BOTTOM,
      colorText: mainWhite,
      mainButton: onTap != null
          ? TextButton(
              onPressed: onTap,
              child: Text(
                'Aceptar',
                style: textWhiteStyleDay,
              ),
            )
          : null,
    );
  }

  static SnackbarController showSnackBarWhthoutButton(
    String title,
    String message,
    BuildContext context,
  ) {
    return Get.snackbar(
      title,
      message,
      backgroundColor: colorSnack,
      margin: EdgeInsets.all(5.w),
      snackPosition: SnackPosition.BOTTOM,
      colorText: mainWhite,
    );
  }

  static Future showDefaultDialog(String title, BuildContext context) {
    return Get.defaultDialog(
      title: title,
      titleStyle: textWhiteStyle,
      content: const Column(
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: mainWhite,
          )
        ],
      ),
    );
  }
}
