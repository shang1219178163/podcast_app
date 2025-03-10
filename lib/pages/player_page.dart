import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/audio_player_controller.dart';
import '../widgets/audio_visualizer.dart';

class PlayerPage extends GetView<AudioPlayerController> {
  const PlayerPage({super.key});

  void _showPlaylistBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '播放列表',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => Text(
                      '${controller.currentIndex.value + 1}/${controller.playlistUrls.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                thickness: 4,
                radius: const Radius.circular(2),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.tracks.length,
                  itemBuilder: (context, index) {
                    final track = controller.tracks[index];
                    return GetX<AudioPlayerController>(
                      builder: (controller) {
                        final isCurrentTrack = index == controller.currentIndex.value;
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              track['cover']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.music_note),
                                );
                              },
                            ),
                          ),
                          title: Text(
                            track['title']!,
                            style: TextStyle(
                              fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                              color: isCurrentTrack ? Theme.of(context).colorScheme.primary : null,
                            ),
                          ),
                          subtitle: Text(
                            track['author']!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          trailing: isCurrentTrack
                              ? GetX<AudioPlayerController>(
                                  builder: (controller) => Icon(
                                    controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              : null,
                          onTap: () {
                            controller.switchTrack(index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVolumeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '音量控制',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GetX<AudioPlayerController>(
                  builder: (controller) => Text(
                    '${(controller.volume.value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GetX<AudioPlayerController>(
              builder: (controller) => Row(
                children: [
                  Icon(
                    controller.volume.value == 0
                        ? Icons.volume_off
                        : controller.volume.value < 0.5
                            ? Icons.volume_down
                            : Icons.volume_up,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Expanded(
                    child: Slider(
                      value: controller.volume.value,
                      onChanged: controller.setVolume,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEqualizerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const EqualizerBottomSheet(),
    );
  }

  void _showSleepTimerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              '睡眠定时器',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // 快速选择按钮
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildTimerButton('15分钟', context),
                _buildTimerButton('30分钟', context),
                _buildTimerButton('45分钟', context),
                _buildTimerButton('60分钟', context),
                _buildTimerButton('90分钟', context),
                _buildTimerButton('关闭', context),
              ],
            ),
            const SizedBox(height: 20),
            // 自定义时间选择器
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('自定义时间：'),
                const SizedBox(width: 10),
                GetX<AudioPlayerController>(
                  builder: (controller) => DropdownButton<int>(
                    value: controller.sleepTimerMinutes.value > 0 ? controller.sleepTimerMinutes.value : 30,
                    items: List.generate(12, (index) {
                      final minutes = (index + 1) * 15;
                      return DropdownMenuItem(
                        value: minutes,
                        child: Text('$minutes分钟'),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        controller.setSleepTimer(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerButton(String label, BuildContext context) {
    return GetX<AudioPlayerController>(
      builder: (controller) => ElevatedButton(
        onPressed: () {
          if (label == '关闭') {
            controller.cancelSleepTimer();
          } else {
            final minutes = int.parse(label.replaceAll('分钟', ''));
            controller.setSleepTimer(minutes);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.sleepTimerMinutes.value > 0 ? Theme.of(context).colorScheme.primary : Colors.grey[300],
          foregroundColor: controller.sleepTimerMinutes.value > 0 ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('正在播放'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: 实现更多选项菜单
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 封面图片和音频可视化
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GetX<AudioPlayerController>(
                        builder: (controller) => Image.network(
                          controller.currentTrack['cover'] ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.music_note,
                              size: 100,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Obx(() => AudioVisualizer(
                          data: controller.visualizationData,
                          width: 200,
                          height: 60,
                          color: Theme.of(context).primaryColor,
                          isPlaying: controller.isPlaying.value,
                        )),
                  ),
                ],
              ),
            ),
            // 标题和作者
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetX<AudioPlayerController>(
                    builder: (controller) => Text(
                      controller.currentTrack['title']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GetX<AudioPlayerController>(
                    builder: (controller) => Text(
                      controller.currentTrack['author']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 进度条
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GetX<AudioPlayerController>(
                    builder: (controller) => Slider(
                      value: controller.progress.value,
                      onChanged: (value) {
                        final duration = controller.duration.value;
                        final position = Duration(
                          milliseconds: (value * duration.inMilliseconds).toInt(),
                        );
                        controller.seek(position);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GetX<AudioPlayerController>(
                          builder: (controller) => Text(
                            _formatDuration(controller.position.value),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                        GetX<AudioPlayerController>(
                          builder: (controller) => Text(
                            _formatDuration(controller.duration.value),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 控制按钮
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: controller.isShuffle.value ? Theme.of(context).colorScheme.primary : null,
                      ),
                      onPressed: controller.toggleShuffle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: controller.playPrevious,
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        if (controller.isPlaying.value) {
                          await controller.pause();
                        } else {
                          await controller.resume();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: controller.playNext,
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: controller.isLooping.value ? Theme.of(context).colorScheme.primary : null,
                      ),
                      onPressed: controller.toggleLoop,
                    ),
                  ),
                ],
              ),
            ),
            // 底部操作栏
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                        color: controller.isFavorite.value ? Colors.red : null,
                      ),
                      onPressed: controller.toggleFavorite,
                    ),
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isDownloaded.value ? Icons.download_done : Icons.download,
                        color: controller.isDownloaded.value ? Theme.of(context).colorScheme.primary : null,
                      ),
                      onPressed: controller.toggleDownload,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.playlist_play),
                    onPressed: () => _showPlaylistBottomSheet(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: () => _showVolumeBottomSheet(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.equalizer),
                    onPressed: () => _showEqualizerBottomSheet(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.timer),
                    onPressed: () => _showSleepTimerBottomSheet(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours > 0 ? '$hours:$minutes:$seconds' : '$minutes:$seconds';
  }
}

// 修改音频可视化画笔
class AudioVisualizerPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  const AudioVisualizerPainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final barWidth = width / data.length;
    final centerY = height / 2;

    for (var i = 0; i < data.length; i++) {
      final x = i * barWidth;
      final barHeight = data[i] * height;
      final topY = centerY - barHeight / 2;
      final bottomY = centerY + barHeight / 2;

      canvas.drawLine(
        Offset(x, topY),
        Offset(x, bottomY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AudioVisualizerPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}

// 均衡器底部弹窗
class EqualizerBottomSheet extends StatelessWidget {
  const EqualizerBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            '均衡器',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // 预设模式
          const EqualizerPresets(),
          const SizedBox(height: 20),
          // 均衡器滑块
          const EqualizerSliders(),
        ],
      ),
    );
  }
}

// 均衡器预设按钮组
class EqualizerPresets extends StatelessWidget {
  const EqualizerPresets({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          EqualizerPresetButton(label: '默认'),
          EqualizerPresetButton(label: '流行'),
          EqualizerPresetButton(label: '摇滚'),
          EqualizerPresetButton(label: '爵士'),
          EqualizerPresetButton(label: '古典'),
        ],
      ),
    );
  }
}

// 均衡器预设按钮
class EqualizerPresetButton extends GetView<AudioPlayerController> {
  final String label;

  const EqualizerPresetButton({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<AudioPlayerController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: ElevatedButton(
          onPressed: () => controller.setEqualizerPreset(label),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                controller.currentPreset.value == label ? Theme.of(context).colorScheme.primary : Colors.grey[300],
            foregroundColor: controller.currentPreset.value == label ? Colors.white : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

// 均衡器滑块组
class EqualizerSliders extends GetView<AudioPlayerController> {
  const EqualizerSliders({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<AudioPlayerController>(
      builder: (controller) => Column(
        children: List.generate(5, (index) => EqualizerSlider(index: index)),
      ),
    );
  }
}

// 均衡器单个滑块
class EqualizerSlider extends GetView<AudioPlayerController> {
  final int index;

  const EqualizerSlider({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final frequencies = ['60Hz', '230Hz', '910Hz', '3.6kHz', '14kHz'];

    return GetX<AudioPlayerController>(
      builder: (controller) => Column(
        children: [
          Text(frequencies[index]),
          Slider(
            value: controller.equalizerBands[index],
            onChanged: (value) => controller.updateEqualizerBand(index, value),
          ),
        ],
      ),
    );
  }
}
