import 'dart:async';

import '../../../utils/all_imports.dart';

class SplashController extends GetxController {
  @override
  Future<void> onInit() async {
    initialize();
    super.onInit();
  }

  initialize() async {
    Timer(const Duration(seconds: 3), () async {
      Get.offAllNamed(Routes.HOME);
    });
  }
}
