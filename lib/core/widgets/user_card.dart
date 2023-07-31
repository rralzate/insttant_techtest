import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../routes/resource_icons.dart';
import '../theme/colors.dart';

import '../theme/sizes.dart';

class UserCard extends StatelessWidget {
  final String profileImage;
  final bool isCardStyle;
  final Function()? onTap;
  final bool? isChangeImage;
  final Function()? onChangeImage;
  final File? localImage;

  const UserCard({
    required this.profileImage,
    required this.isCardStyle,
    this.localImage,
    this.onTap,
    this.isChangeImage,
    this.onChangeImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isChangeImage ?? false ? onChangeImage : onTap,
      child: SizedBox(
        height: 19.h,
        child: Stack(
          children: [
            Center(
              child: Container(
                decoration: isCardStyle
                    ? BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: mainGrey,
                            blurRadius: 4,
                            offset: Offset(4, 5), // Shadow position
                          ),
                        ],
                        color: colorWhite,
                        borderRadius: BorderRadius.all(Radius.circular(3.w)),
                      )
                    : const BoxDecoration(),
                height: Device.screenType == ScreenType.mobile
                    ? SizerResponsive().constSizeRadiusEventItem * 1.4
                    : SizerResponsive().constSizeRadiusEventItem,
                padding: Device.screenType == ScreenType.mobile
                    ? EdgeInsets.only(left: 37.w)
                    : EdgeInsets.only(left: 32.w),
                //width: double.infinity,
                child: Row(
                  children: [
                    isCardStyle
                        ? SvgPicture.asset(
                            chevronRightScheduleSVG,
                            color: highlightRed,
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
            Positioned(child: _circleImage(profileImage)),
          ],
        ),
      ),
    );
  }

  Widget _circleImage(String urlImage) {
    return SizedBox(
      height: SizerResponsive().constSizeRadiusEventItem * 1.7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.w),
        child: Stack(
          children: [
            localImage == null
                ? Image.network(
                    urlImage,
                    fit: BoxFit.cover,
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        height: getResponsiveImageDimensions(),
                        width: getResponsiveImageDimensions(),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.w),
                          child: Center(
                            child: Image.asset(loadingGIF, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        height: getResponsiveImageDimensions(),
                        width: getResponsiveImageDimensions(),
                        logo,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.file(
                    File(localImage!.path),
                    fit: BoxFit.cover,
                    height: getResponsiveImageDimensions(),
                    width: getResponsiveImageDimensions(),
                  ),
            isChangeImage ?? false
                ? SizedBox(
                    height: getResponsiveImageDimensions(),
                    width: getResponsiveImageDimensions(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.w),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: SvgPicture.asset(cameraSVG, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  double getResponsiveImageDimensions() {
    if (Device.screenType == ScreenType.mobile) {
      return SizerResponsive().constSizeRadiusEventItem * 1.7;
    } else {
      return SizerResponsive().constSizeRadiusEventItem * 1.5;
    }
  }
}
