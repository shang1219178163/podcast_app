import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class TimerSettingsPage extends StatelessWidget {
  const TimerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '定时关闭',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: ListView(
        children: [
          _buildTimerOption(
            context: context,
            title: '15分钟',
            subtitle: '15分钟后自动停止播放',
            onTap: () => _setTimer(context, 15),
          ),
          _buildTimerOption(
            context: context,
            title: '30分钟',
            subtitle: '30分钟后自动停止播放',
            onTap: () => _setTimer(context, 30),
          ),
          _buildTimerOption(
            context: context,
            title: '45分钟',
            subtitle: '45分钟后自动停止播放',
            onTap: () => _setTimer(context, 45),
          ),
          _buildTimerOption(
            context: context,
            title: '60分钟',
            subtitle: '60分钟后自动停止播放',
            onTap: () => _setTimer(context, 60),
          ),
          _buildTimerOption(
            context: context,
            title: '自定义',
            subtitle: '设置自定义时间',
            onTap: () => _showCustomTimerDialog(context),
          ),
          _buildTimerOption(
            context: context,
            title: '关闭定时',
            subtitle: '关闭定时停止功能',
            onTap: () => _cancelTimer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      colorText: Theme.of(context).colorScheme.onSurface,
    );
  }

  void _showCustomTimerDialog(BuildContext context) {
    final theme = Theme.of(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: theme.brightness,
          primaryColor: theme.colorScheme.primary,
        ),
        child: CupertinoAlertDialog(
          title: Text(
            '设置自定义时间',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CupertinoTextField(
              keyboardType: TextInputType.number,
              placeholder: '请输入分钟数',
              suffix: Text(
                '分钟',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
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
              child: Text(
                '取消',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      colorText: Theme.of(context).colorScheme.onSurface,
    );
  }
}
