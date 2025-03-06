import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.progress,
    required this.duration,
    required this.currentTime,
    required this.isPlaying,
    required this.onSeek,
    required this.onPlayPause,
    required this.onRewind,
    required this.onForward,
  });

  final double progress;
  final Duration duration;
  final Duration currentTime;
  final bool isPlaying;
  final ValueChanged<double> onSeek;
  final VoidCallback onPlayPause;
  final VoidCallback onRewind;
  final VoidCallback onForward;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.defaultPadding),
      child: Column(
        children: [
          _buildProgressBar(context),
          const SizedBox(height: AppConstants.defaultSpacing),
          _buildTimeInfo(),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding * 1.5),
      child: SliderTheme(
        data: Theme.of(context).sliderTheme,
        child: Slider(
          value: progress,
          onChanged: onSeek,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding * 1.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDuration(currentTime),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Text(
            _formatDuration(duration),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10),
          iconSize: AppConstants.defaultIconSize * 1.5,
          onPressed: onRewind,
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            iconSize: AppConstants.defaultIconSize * 2,
            color: Colors.white,
            onPressed: onPlayPause,
          ),
        ),
        const SizedBox(width: AppConstants.defaultPadding),
        IconButton(
          icon: const Icon(Icons.forward_30),
          iconSize: AppConstants.defaultIconSize * 1.5,
          onPressed: onForward,
        ),
      ],
    );
  }
}
