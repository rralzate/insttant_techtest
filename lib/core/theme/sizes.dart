import 'package:responsive_sizer/responsive_sizer.dart';

class SizerResponsive {
  bool validateScreenTable() {
    return Device.screenType != ScreenType.tablet;
  }

  double get constBellSizer => !validateScreenTable() ? 5.3.w : 8.3.w;

  double get constSizeEventHighlight => !validateScreenTable() ? 22.h : 18.h;
  double get constSizeIconFair => !validateScreenTable() ? 5.w : 8.w;
  double get constSizeForumSchedule => 10.h;
  double get constSizeRadiusEventItem => !validateScreenTable() ? 13.h : 9.5.h;
}
