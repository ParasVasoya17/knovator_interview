import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../models/post_model.dart';
import '../../../utils/all_imports.dart';

class PostDetailController extends GetxController {
  RxString postId = "".obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      postId.value = Get.arguments[0].toString();
    }
    update();
    super.onInit();
  }

  Future<Post> fetchPostDetail() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId'));
    return Post.fromJson(jsonDecode(response.body));
  }
}
