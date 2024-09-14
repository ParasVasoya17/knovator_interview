import 'package:get/get.dart';
import 'package:knovator_api_demo/app/modules/splash/bindings/splash_binding.dart';
import 'package:knovator_api_demo/app/modules/splash/views/splash_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/post_detail/bindings/post_detail_binding.dart';
import '../modules/post_detail/views/post_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.POST_DETAIL,
      page: () => const PostDetailView(),
      binding: PostDetailBinding(),
    ),
  ];
}
