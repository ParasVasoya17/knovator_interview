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

// // import 'dart:convert';
// //
// // import 'package:knovator_api_demo/app/modules/home/controllers/home_controller.dart';
// //
// // import '../../../models/post_model.dart';
// // import '../../../utils/all_imports.dart';
// //
// // class HomeView extends GetView<HomeController> {
// //   const HomeView({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<HomeController>(
// //       assignId: true,
// //       init: HomeController(),
// //       builder: (controller) {
// //         return FutureBuilder(
// //           future: controller.fetchPosts(),
// //           builder: (context, snapshot) {
// //             if (snapshot.hasData) {
// //               var _posts = snapshot.data;
// //               return ListView.builder(
// //                 itemCount: _posts?.length,
// //                 itemBuilder: (context, index) {
// //                   return ListTile(
// //                     title: Text(_posts![index].title),
// //                     tileColor: _posts[index].isRead ? AppColors.white : AppColors.lightYellow,
// //                     onTap: () {
// //                       _posts[index].isRead = true;
// //
// //                       Get.toNamed(Routes.POST_DETAIL, arguments: [_posts[index].id])!.then(
// //                         (value) {
// //                           controller.update();
// //                         },
// //                       );
// //                     },
// //                     trailing: TimerWidget(
// //                       index: index,
// //                     ),
// //
// //                     // TimerWidget(duration: controller.getRandomTimerDuration()),
// //                   );
// //                 },
// //               );
// //             } else {
// //               return const Center(child: CircularProgressIndicator());
// //             }
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // class LocalStorage {
// //   final GetStorage _storage = GetStorage();
// //
// //   Future<void> savePosts(List<Post> posts) async {
// //     await _storage.write('posts', jsonEncode(posts));
// //   }
// //
// //   Future<List<Post>> getPosts() async {
// //     final json = await _storage.read('posts');
// //     return (jsonDecode(json) as List).map((json) => Post.fromJson(json)).toList();
// //   }
// // }
//
// import '../../../utils/all_imports.dart';
// import '../controllers/home_controller.dart';
//
// class HomeView extends GetView<HomeController> {
//   final GlobalKey _listKey = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeController>(
//       assignId: true,
//       init: HomeController(),
//       builder: (controller) {
//         return FutureBuilder(
//           future: controller.fetchPosts(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               var _posts = snapshot.data;
//               return NotificationListener<ScrollNotification>(
//                 onNotification: (notification) {
//                   if (notification is ScrollUpdateNotification) {
//                     for (int i = 0; i < _posts!.length; i++) {
//                       final renderBox = _listKey.currentContext?.findRenderObject() as RenderBox?;
//                       final postRect = renderBox?.paintBounds;
//                       final rect = Rect.fromPoints(
//                         Offset(renderBox?.localToGlobal(Offset.zero)?.dx ?? 0, renderBox?.localToGlobal(Offset.zero)?.dy ?? 0),
//                         Offset(renderBox?.localToGlobal(Offset.zero)?.dx ?? 0, renderBox?.localToGlobal(Offset.zero)?.dy ?? 0) +
//                             Offset(0, renderBox?.size.height ?? 0),
//                       );
//                       if (rect?.overlaps(postRect!) ?? false) {
//                         controller.updateVisibility(i, true);
//                       } else {
//                         controller.updateVisibility(i, false);
//                       }
//                     }
//                   }
//                   return true;
//                 },
//                 child: ListView.builder(
//                   key: _listKey,
//                   itemCount: _posts?.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(_posts![index].title),
//                       tileColor: controller.readStatus[index] ?? false ? AppColors.white : AppColors.lightYellow,
//                       onTap: () {
//                         controller.updateReadStatus(index, true);
//
//                         Navigator.pushNamed(
//                           context,
//                           Routes.POST_DETAIL,
//                           arguments: [_posts[index].id],
//                         ).then((value) {
//                           controller.update();
//                         });
//                       },
//                       trailing: TimerWidget(
//                         index: index,
//                       ),
//                     );
//                   },
//                 ),
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           },
//         );
//       },
//     );
//   }
// }
