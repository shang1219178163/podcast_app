import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class VolumeSettingsPage extends GetView<SettingsController> {
  const VolumeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '音量设置',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '主音量',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: [
                    Slider(
                      value: controller.volume.value,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(controller.volume.value * 100).round()}%',
                      onChanged: (value) {
                        controller.volume.value = value;
                        controller.saveSettings();
                      },
                    ),
                    Text('${(controller.volume.value * 100).round()}%'),
                  ],
                )),
            const SizedBox(height: 32),
            const Text(
              '均衡器',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildEqualizerSlider('低音', 0.5),
            _buildEqualizerSlider('中音', 0.5),
            _buildEqualizerSlider('高音', 0.5),
          ],
        ),
      ),
    );
  }

  Widget _buildEqualizerSlider(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: '${(value * 100).round()}%',
          onChanged: (value) {
            // TODO: 实现均衡器调节
          },
        ),
      ],
    );
  }
}
