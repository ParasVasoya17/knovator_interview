import '../../../utils/all_imports.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      assignId: true,
      builder: (controller) {
        return const Scaffold(
          body: Center(
            child: Text(
              AppStrings.thisIsSplash,
            ),
          ),
        );
      },
    );
  }
}
