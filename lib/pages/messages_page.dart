import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '消息中心',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 清空消息
              Get.snackbar(
                '成功',
                '已清空消息',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: theme.colorScheme.surface,
                colorText: theme.colorScheme.onSurface,
              );
            },
            child: Text(
              '清空',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // TODO: 使用实际的消息列表长度
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Icon(
                _getMessageIcon(index),
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              _getMessageTitle(index),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              _getMessageContent(index),
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              '2小时前',
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            onTap: () {
              // TODO: 处理消息点击
            },
          );
        },
      ),
    );
  }

  IconData _getMessageIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.notifications;
      case 1:
        return Icons.favorite;
      case 2:
        return Icons.system_update;
      default:
        return Icons.info;
    }
  }

  String _getMessageTitle(int index) {
    switch (index % 4) {
      case 0:
        return '系统通知';
      case 1:
        return '订阅更新';
      case 2:
        return '新节目提醒';
      default:
        return '活动通知';
    }
  }

  String _getMessageContent(int index) {
    switch (index % 4) {
      case 0:
        return '您的账号已成功登录新设备';
      case 1:
        return '您订阅的播客《未来科技浪潮》已更新新节目';
      case 2:
        return '您关注的主播发布了新的节目';
      default:
        return '新活动：参与评论赢取会员';
    }
  }
}
