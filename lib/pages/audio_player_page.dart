import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_player_controller.dart';

class AudioPlayerPage extends GetView<AudioPlayerController> {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音频播放'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 封面图片
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://picsum.photos/300/300',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 标题
            const Text(
              '示例音频',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // 作者
            const Text(
              '作者名称',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // 进度条
            Obx(() => Column(
                  children: [
                    Slider(
                      value: controller.progress.value,
                      onChanged: (value) {
                        final position = Duration(
                          milliseconds: (value * controller.duration.value.inMilliseconds).round(),
                        );
                        controller.seek(position);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(controller.position.value),
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            _formatDuration(controller.duration.value),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            // 测试按钮
            ElevatedButton(
              onPressed: () {
                controller.play('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
              },
              child: const Text('播放测试音频'),
            ),
            const SizedBox(height: 32),
            // 控制按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.repeat),
                  onPressed: () {
                    controller.setLoopMode(!controller.isLooping.value);
                  },
                  color: controller.isLooping.value ? Theme.of(context).primaryColor : null,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () {
                    // TODO: 实现上一首
                  },
                ),
                Obx(() => IconButton(
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        size: 48,
                      ),
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.pause();
                        } else {
                          controller.resume();
                        }
                      },
                    )),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: () {
                    // TODO: 实现下一首
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    // TODO: 实现音量控制
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
