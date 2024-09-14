import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:knovator_api_demo/app/models/post_model.dart';

import '../../../utils/all_imports.dart';

import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final GetStorage storage = GetStorage();

  RxList<Post> posts = <Post>[].obs;
  RxMap<int, RxInt> timerValues = <int, RxInt>{}.obs;
  RxMap<int, Timer?> timers = <int, Timer?>{}.obs;
  RxMap<int, bool> readStatus = <int, bool>{}.obs;
  RxMap<int, bool> isVisible = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndFetchData();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    return (jsonDecode(response.body) as List).map((json) => Post.fromJson(json)).toList();
  }

  int getRandomTimerDuration() {
    Random random = Random();
    return random.nextInt(100); // Generates a random duration between 0 and 99 seconds
  }

  void startTimers() {
    for (int i = 0; i < posts.length; i++) {
      timerValues[i] = RxInt(getRandomTimerDuration());
      startTimer(i, timerValues[i]!.value);
    }
  }

  void startTimer(int index, int duration) {
    if (timers[index] != null) {
      timers[index]!.cancel();
    }

    if (isVisible[index] ?? false) {
      timers[index] = Timer.periodic(Duration(seconds: 1), (timer) {
        if (duration > 0) {
          duration--;
          timerValues[index]?.value = duration;
        } else {
          timer.cancel();
        }
      });
    }
  }

  void cancelTimers() {
    timers.forEach((index, timer) {
      timer?.cancel();
    });
  }

  @override
  void onClose() {
    cancelTimers();
    super.onClose();
  }

  Widget timerWidget(int index) {
    return Obx(() {
      int seconds = timerValues[index]?.value ?? 0;
      int minutes = seconds ~/ 60;
      seconds = seconds % 60;
      return Text(
        '$minutes:${seconds.toString().padLeft(2, '0')}',
        style: TextStyle(fontSize: 16),
      );
    });
  }

  void checkAndFetchData() async {
    try {
      final storedPosts = storage.read<String>('posts');
      if (storedPosts != null) {
        final posts = (jsonDecode(storedPosts) as List).map((json) => Post.fromJson(json)).toList();
        this.posts.value = posts;
        for (int i = 0; i < posts.length; i++) {
          final readStatus = storage.read<bool>('post_${i}_read') ?? false;
          this.readStatus[i] = readStatus;
        }
        startTimers();
      } else {
        for (int i = 0; i < posts.length; i++) {
          // assuming 10 posts initially
          readStatus[i] = false;
        }
        fetchPostDataInBackground();
      }
    } catch (e) {
      print("error $e");
    }
  }

  void check() async {
    try {
      final storedPosts = storage.read<String>('posts');
      if (storedPosts != null) {
        final posts = (jsonDecode(storedPosts) as List).map((json) => Post.fromJson(json)).toList();
        this.posts.value = posts;
        for (int i = 0; i < posts.length; i++) {
          final readStatus = storage.read<bool>('post_${i}_read') ?? false;
          this.readStatus[i] = readStatus;
        }
      } else {
        for (int i = 0; i < posts.length; i++) {
          // assuming 10 posts initially
          readStatus[i] = false;
        }
        fetchPostDataInBackground();
      }
    } catch (e) {
      print("error $e");
    }
  }
  // void _checkAndFetchData() async {
  //   try {
  //     final storedPosts = storage.read<String>('posts');
  //     if (storedPosts != null) {
  //       final posts = (jsonDecode(storedPosts) as List).map((json) => Post.fromJson(json)).toList();
  //       this.posts.value = posts;
  //       for (int i = 0; i < posts.length; i++) {
  //         final readStatus = storage.read<bool>('post_${i}_read') ?? false;
  //         this.readStatus[i] = readStatus;
  //       }
  //       startTimers();
  //     } else {
  //       fetchPostDataInBackground();
  //     }
  //   } catch (e) {
  //     print("error $e");
  //   }
  // }

  void fetchPostDataInBackground() async {
    final posts = await fetchPosts();
    this.posts.value = posts;
    storage.write('posts', jsonEncode(posts.map((post) => post.toJson()).toList()));
    for (int i = 0; i < posts.length; i++) {
      storage.write('post_${i}_read', false);
    }
    startTimers();
  }

  void updateReadStatus(int index, bool status) {
    readStatus[index] = status;
    storage.write('post_${index}_read', status);
  }

  void updateVisibility(int index, bool isVisible) {
    this.isVisible[index] = isVisible;
    if (isVisible) {
      startTimer(index, timerValues[index]?.value ?? getRandomTimerDuration());
    } else {
      timers[index]?.cancel();
    }
  }
}
