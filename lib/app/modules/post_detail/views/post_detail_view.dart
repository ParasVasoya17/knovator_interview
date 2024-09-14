import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:knovator_api_demo/app/utils/all_imports.dart';

import '../../../utils/app_colors.dart';
import '../controllers/post_detail_controller.dart';

class PostDetailView extends GetView<PostDetailController> {
  const PostDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostDetailController>(
      assignId: true,
      init: PostDetailController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.postDetails),
            centerTitle: true,
            backgroundColor: AppColors.blue,
          ),
          body: FutureBuilder(
            future: controller.fetchPostDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(snapshot.data!.body),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
