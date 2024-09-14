import 'package:knovator_api_demo/app/modules/home/controllers/home_controller.dart';

import '../../../utils/all_imports.dart';

import 'package:visibility_detector/visibility_detector.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.postList),
        centerTitle: true,
        backgroundColor: AppColors.blue,
      ),
      backgroundColor: AppColors.grey,
      body: Obx(
        () {
          return ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              return VisibilityDetector(
                key: Key('post_$index'),
                onVisibilityChanged: (visibilityInfo) {
                  final visiblePercentage = visibilityInfo.visibleFraction * 100;
                  controller.updateVisibility(index, visiblePercentage > 50);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 18.h),
                  child: ListTile(
                    title: Text(controller.posts[index].title),
                    tileColor: controller.readStatus[index] ?? false ? AppColors.white : AppColors.lightYellow,
                    onTap: () {
                      controller.updateReadStatus(index, true);
                      Get.toNamed(Routes.POST_DETAIL, arguments: [controller.posts[index].id])!.
                          // Navigator.pushNamed(
                          //   context,
                          //   '/post_detail',
                          //   arguments: controller.posts[index].id,
                          // ).
                          then((value) {
                        controller.check();
                        controller.update();
                      });
                    },
                    trailing: controller.timerWidget(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
