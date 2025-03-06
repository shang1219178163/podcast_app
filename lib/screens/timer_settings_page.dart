import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimerSettingsPage extends StatelessWidget {
  const TimerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '定时关闭',
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
          _buildTimerOption(
            title: '15分钟',
            subtitle: '15分钟后自动停止播放',
            onTap: () => _setTimer(context, 15),
          ),
          _buildTimerOption(
            title: '30分钟',
            subtitle: '30分钟后自动停止播放',
            onTap: () => _setTimer(context, 30),
          ),
          _buildTimerOption(
            title: '45分钟',
            subtitle: '45分钟后自动停止播放',
            onTap: () => _setTimer(context, 45),
          ),
          _buildTimerOption(
            title: '60分钟',
            subtitle: '60分钟后自动停止播放',
            onTap: () => _setTimer(context, 60),
          ),
          _buildTimerOption(
            title: '自定义',
            subtitle: '设置自定义时间',
            onTap: () => _showCustomTimerDialog(context),
          ),
          _buildTimerOption(
            title: '关闭定时',
            subtitle: '关闭定时停止功能',
            onTap: () => _cancelTimer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerOption({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _setTimer(BuildContext context, int minutes) {
    // TODO: 实现定时设置
    Get.back();
    Get.snackbar(
      '成功',
      '已设置$minutes分钟后自动停止播放',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showCustomTimerDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('设置自定义时间'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CupertinoTextField(
            keyboardType: TextInputType.number,
            placeholder: '请输入分钟数',
            suffix: const Text('分钟'),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                final minutes = int.tryParse(value);
                if (minutes != null && minutes > 0) {
                  Navigator.pop(context);
                  _setTimer(context, minutes);
                }
              }
            },
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _cancelTimer(BuildContext context) {
    // TODO: 实现取消定时
    Get.back();
    Get.snackbar(
      '成功',
      '已关闭定时停止功能',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
