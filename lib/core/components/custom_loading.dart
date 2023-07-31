import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../routes/resource_icons.dart';
import '../theme/colors.dart';

class CustomLoadingScreen extends StatelessWidget {
  const CustomLoadingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: darkGrey.withOpacity(0.2),
      child: SizedBox(
        child: Image(
          image: const AssetImage(loadingGIF),
          fit: BoxFit.cover,
          height: 5.h,
        ),
      ),
    );
  }
}
