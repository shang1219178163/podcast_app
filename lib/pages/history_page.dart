import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../controllers/podcast_controller.dart';
import '../widgets/network_image_widget.dart';

class HistoryPage extends GetView<PodcastController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '收听历史',
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
              // TODO: 清空历史记录
              Get.snackbar(
                '成功',
                '已清空历史记录',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: theme.colorScheme.surface,
                colorText: theme.colorScheme.onSurface,
              );
            },
            child: Text(
              '清空',
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // TODO: 使用实际的历史记录长度
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                url: 'https://example.com/cover$index.jpg',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surface,
                  child: Icon(
                    Icons.image,
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            ),
            title: Text(
              '播客标题 $index',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '作者名称 · 2小时前',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.play_circle_outline,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    controller.setCurrentPodcast({
                      'id': 'history_$index',
                      'title': '播客标题 $index',
                      'author': '作者名称',
                      'cover': 'https://example.com/cover$index.jpg',
                      'description': '播客描述',
                    });
                    Get.toNamed(AppRoute.player);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                  onPressed: () {
                    // TODO: 删除单条历史记录
                    Get.snackbar(
                      '成功',
                      '已删除该条历史记录',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: theme.colorScheme.surface,
                      colorText: theme.colorScheme.onSurface,
                    );
                  },
                ),
              ],
            ),
            onTap: () => Get.toNamed(AppRoute.podcastDetail),
          );
        },
      ),
    );
  }
}
