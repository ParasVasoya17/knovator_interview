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
    _checkAndFetchData();
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

  void _checkAndFetchData() async {
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
        fetchPostDataInBackground();
      }
    } catch (e) {
      print("error $e");
    }
  }

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

// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'package:knovator_api_demo/app/models/post_model.dart';
//
// import '../../../utils/all_imports.dart';
//
// class HomeController extends GetxController {
//   final GetStorage _storage = GetStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkAndFetchData();
//   }
//
//   Future<List<Post>> fetchPosts() async {
//     final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
//     return (jsonDecode(response.body) as List).map((json) => Post.fromJson(json)).toList();
//   }
//
//   int getRandomTimerDuration() {
//     Random random = Random();
//     int randomNumber = random.nextInt(100);
//     return randomNumber;
//   }
//
//   final RxList<Post> _posts = <Post>[].obs;
//   final RxMap<int, int> _timerValues = <int, int>{}.obs;
//   final RxMap<int, bool> readStatus = <int, bool>{}.obs;
//   final RxMap<int, bool> _isVisible = <int, bool>{}.obs;
//
//   List<Post> get posts => _posts.value;
//
//   void startTimers() {
//     for (int i = 0; i < _posts.value.length; i++) {
//       _timerValues[i] = getRandomTimerDuration();
//       startTimer(i, _timerValues[i] ?? 0);
//     }
//   }
//
//   void startTimer(int index, int duration) {
//     if (_isVisible[index] ?? false) {
//       if (duration > 0) {
//         Future.delayed(Duration(seconds: 1), () {
//           _timerValues[index] = duration - 1;
//           startTimer(index, _timerValues[index] ?? 0);
//         });
//       } else {
//         // Save post data to GetStorage
//         _storage.write('post_$index', jsonEncode(_posts.value[index].toJson()));
//       }
//     }
//   }
//
//   void _checkAndFetchData() async {
//     final storedPosts = await _storage.read('posts');
//     if (storedPosts != null) {
//       final posts = (jsonDecode(storedPosts) as List).map((json) => Post.fromJson(json)).toList();
//       _posts.value = posts;
//       for (int i = 0; i < posts.length; i++) {
//         final readStatuses = await _storage.read('post_${i}_read');
//         if (readStatuses != null) {
//           readStatus[i] = readStatuses;
//         }
//       }
//       startTimers();
//     } else {
//       fetchPostDataInBackground();
//     }
//   }
//
//   void fetchPostDataInBackground() async {
//     // Fetch post data in background
//     final posts = await fetchPosts();
//     _posts.value = posts;
//     _storage.write('posts', jsonEncode(posts.map((post) => post.toJson()).toList()));
//     for (int i = 0; i < posts.length; i++) {
//       _storage.write('post_${i}_read', false);
//     }
//     startTimers();
//   }
//
//   void updateReadStatus(int index, bool status) {
//     readStatus[index] = status;
//     _storage.write('post_${index}_read', status);
//   }
//
//   void updateVisibility(int index, bool isVisible) {
//     _isVisible[index] = isVisible;
//   }
// }
//
// class TimerWidget extends StatelessWidget {
//   final int index;
//
//   TimerWidget({required this.index});
//
//   @override
//   Widget build(BuildContext context) {
//     final HomeController _controller = Get.find<HomeController>();
//
//     return Obx(() {
//       int minutes = (_controller._timerValues[index] ?? 0) ~/ 60;
//       int seconds = (_controller._timerValues[index] ?? 0) % 60;
//       return Text(
//         '$minutes:${seconds.toString().padLeft(2, '0')}',
//         style: TextStyle(fontSize: 16),
//       );
//     });
//   }
// }
