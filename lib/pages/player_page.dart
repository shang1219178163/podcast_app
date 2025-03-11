import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/audio_player_controller.dart';
import '../widgets/audio_visualizer.dart';
import '../widgets/network_image_widget.dart';

class PlayerPage extends GetView<AudioPlayerController> {
  const PlayerPage({super.key});

  void _showPlaylistBottomSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
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
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '播放列表',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => Text(
                      '${controller.currentIndex.value + 1}/${controller.playlistUrls.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                            child: NetworkImageWidget(
                              url: track['cover']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorWidget: Container(
                                width: 50,
                                height: 50,
                                color: theme.colorScheme.surface,
                                child: Icon(
                                  Icons.image,
                                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            track['title']!,
                            style: TextStyle(
                              fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                              color: isCurrentTrack ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                            ),
                          ),
                          subtitle: Text(
                            track['author']!,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          trailing: isCurrentTrack
                              ? GetX<AudioPlayerController>(
                                  builder: (controller) => Icon(
                                    controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                    color: theme.colorScheme.primary,
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
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
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
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '音量控制',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                GetX<AudioPlayerController>(
                  builder: (controller) => Text(
                    '${(controller.volume.value * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                    color: theme.colorScheme.primary,
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.3),
                        thumbColor: theme.colorScheme.primary,
                      ),
                      child: Slider(
                        value: controller.volume.value,
                        onChanged: controller.setVolume,
                      ),
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
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
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
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              '睡眠定时器',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
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
                Text(
                  '自定义时间：',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 10),
                GetX<AudioPlayerController>(
                  builder: (controller) => Theme(
                    data: Theme.of(context).copyWith(
                      dropdownMenuTheme: DropdownMenuThemeData(
                        textStyle: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    child: DropdownButton<int>(
                      value: controller.sleepTimerMinutes.value > 0 ? controller.sleepTimerMinutes.value : 30,
                      items: List.generate(12, (index) {
                        final minutes = (index + 1) * 15;
                        return DropdownMenuItem(
                          value: minutes,
                          child: Text(
                            '$minutes分钟',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          controller.setSleepTimer(value);
                        }
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: theme.colorScheme.onSurface,
                      ),
                      dropdownColor: theme.scaffoldBackgroundColor,
                    ),
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
    final theme = Theme.of(context);
    return GetX<AudioPlayerController>(
      builder: (controller) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.sleepTimerMinutes.value > 0 && label == '${controller.sleepTimerMinutes.value}分钟'
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          foregroundColor: controller.sleepTimerMinutes.value > 0 && label == '${controller.sleepTimerMinutes.value}分钟'
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.onSurface,
        ),
        onPressed: () {
          if (label == '关闭') {
            controller.cancelSleepTimer();
          } else {
            final minutes = int.parse(label.replaceAll('分钟', ''));
            controller.setSleepTimer(minutes);
          }
        },
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '正在播放',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
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
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GetX<AudioPlayerController>(
                        builder: (controller) => NetworkImageWidget(
                          url: controller.currentTrack['cover'] ?? "",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: theme.colorScheme.surface,
                            child: Icon(
                              Icons.image,
                              color: theme.colorScheme.onSurface.withOpacity(0.4),
                              size: 48,
                            ),
                          ),
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
                          color: theme.colorScheme.primary,
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GetX<AudioPlayerController>(
                    builder: (controller) => Text(
                      controller.currentTrack['author']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                    builder: (controller) => SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: theme.colorScheme.primary,
                        inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.3),
                        thumbColor: theme.colorScheme.primary,
                      ),
                      child: Slider(
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
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        GetX<AudioPlayerController>(
                          builder: (controller) => Text(
                            _formatDuration(controller.duration.value),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                        color: controller.isShuffle.value
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: controller.toggleShuffle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: controller.playPrevious,
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 64,
                        color: theme.colorScheme.primary,
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
                    icon: Icon(
                      Icons.skip_next,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: controller.playNext,
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        Icons.repeat,
                        color: controller.isLooping.value
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
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
                        color: controller.isFavorite.value
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: controller.toggleFavorite,
                    ),
                  ),
                  GetX<AudioPlayerController>(
                    builder: (controller) => IconButton(
                      icon: Icon(
                        controller.isDownloaded.value ? Icons.download_done : Icons.download,
                        color: controller.isDownloaded.value
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: controller.toggleDownload,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.playlist_play,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => _showPlaylistBottomSheet(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => _showVolumeBottomSheet(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.equalizer,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    onPressed: () => _showEqualizerBottomSheet(context),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.timer,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
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
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
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
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '均衡器',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const EqualizerPresetButton(),
            ],
          ),
          const SizedBox(height: 20),
          const EqualizerSliders(),
        ],
      ),
    );
  }
}

// 均衡器预设按钮
class EqualizerPresetButton extends GetView<AudioPlayerController> {
  const EqualizerPresetButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presets = ['默认', '流行', '摇滚', '爵士', '古典'];
    return GetX<AudioPlayerController>(
      builder: (controller) => TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
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
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    '均衡器预设',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...presets.map(
                    (preset) => ListTile(
                      title: Text(
                        preset,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: controller.currentPreset.value == preset
                          ? Icon(
                              Icons.check,
                              color: theme.colorScheme.primary,
                            )
                          : null,
                      onTap: () {
                        controller.setEqualizerPreset(preset);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: Text(
          controller.currentPreset.value,
          style: TextStyle(
            color: theme.colorScheme.primary,
          ),
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
    final theme = Theme.of(context);
    final frequencies = ['60Hz', '230Hz', '910Hz', '3.6kHz', '14kHz'];

    return GetX<AudioPlayerController>(
      builder: (controller) => Column(
        children: [
          Text(
            frequencies[index],
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: theme.colorScheme.primary,
              inactiveTrackColor: theme.colorScheme.primary.withOpacity(0.3),
              thumbColor: theme.colorScheme.primary,
            ),
            child: Slider(
              value: controller.equalizerBands[index],
              onChanged: (value) => controller.updateEqualizerBand(index, value),
            ),
          ),
        ],
      ),
    );
  }
}
