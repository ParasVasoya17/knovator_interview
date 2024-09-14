import 'package:flutter/foundation.dart';

import '../utils/all_imports.dart';

Helper helper = Helper();

class Helper {
  /// <<< To create dark status bar --------- >>>
  static void darkStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  /// <<< To create light status bar --------- >>>
  static void lightStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }

  /// <<< To choose screens portrait --------- >>>
  static void screenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
