import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/routes/resource_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../menu/presentation/bloc/menu_bloc.dart';

class HeaderUserBaseScreen extends StatelessWidget {
  final String title;

  const HeaderUserBaseScreen({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.jost(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: mainBlack,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () =>
                  BlocProvider.of<MenuBloc>(context).add(CloseSessionEvent()),
              icon: SvgPicture.asset(
                logoutSVG,
                width: 6.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
