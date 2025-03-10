import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class PlaybackSpeedSettingsPage extends GetView<SettingsController> {
  const PlaybackSpeedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '播放速度',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSpeedOption(
            title: '0.5x',
            subtitle: '慢速播放',
            value: 0.5,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
          _buildSpeedOption(
            title: '0.75x',
            subtitle: '较慢播放',
            value: 0.75,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
          _buildSpeedOption(
            title: '1.0x',
            subtitle: '正常速度',
            value: 1.0,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
          _buildSpeedOption(
            title: '1.25x',
            subtitle: '较快播放',
            value: 1.25,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
          _buildSpeedOption(
            title: '1.5x',
            subtitle: '快速播放',
            value: 1.5,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
          _buildSpeedOption(
            title: '2.0x',
            subtitle: '倍速播放',
            value: 2.0,
            groupValue: controller.playbackSpeed.value,
            onChanged: (value) {
              controller.playbackSpeed.value = value!;
              controller.saveSettings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedOption({
    required String title,
    required String subtitle,
    required double value,
    required double? groupValue,
    required ValueChanged<double?> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Radio<double>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
