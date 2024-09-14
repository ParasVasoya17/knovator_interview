import 'app/utils/all_imports.dart';
import 'main_controller.dart';

Future<void> main() async {
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends GetView<MainController> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Helper.screenPortrait();
    Helper.darkStatusBar();
    return GetBuilder<MainController>(
      assignId: true,
      init: MainController(),
      builder: (controller) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          splitScreenMode: true,
          minTextAdapt: true,
          builder: (context, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppPages.INITIAL,
              getPages: AppPages.routes,
              builder: EasyLoading.init(
                builder: (context, child) {
                  return MediaQuery.withNoTextScaling(child: child!);
                },
              ),
            );
          },
        );
      },
    );
  }
}
