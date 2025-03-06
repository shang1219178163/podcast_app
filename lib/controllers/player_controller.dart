import 'package:get/get.dart';

class PlayerController extends GetxController {
  final RxBool isPlaying = false.obs;
  final RxDouble progress = 0.0.obs;
  final Rx<Duration> currentTime = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;

  void togglePlayPause() {
    isPlaying.value = !isPlaying.value;
  }

  void seekTo(double value) {
    progress.value = value;
    currentTime.value = Duration(
      seconds: (duration.value.inSeconds * value).round(),
    );
  }

  void rewind() {
    final newTime = currentTime.value.inSeconds - 10;
    if (newTime >= 0) {
      currentTime.value = Duration(seconds: newTime);
      progress.value = newTime / duration.value.inSeconds;
    }
  }

  void forward() {
    final newTime = currentTime.value.inSeconds + 30;
    if (newTime <= duration.value.inSeconds) {
      currentTime.value = Duration(seconds: newTime);
      progress.value = newTime / duration.value.inSeconds;
    }
  }
}
