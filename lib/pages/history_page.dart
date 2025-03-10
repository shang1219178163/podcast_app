import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../controllers/podcast_controller.dart';
import '../widgets/network_image_widget.dart';

class HistoryPage extends GetView<PodcastController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '收听历史',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 清空历史记录
              Get.snackbar(
                '成功',
                '已清空历史记录',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('清空'),
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
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            title: Text(
              '播客标题 $index',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '作者名称 · 2小时前',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_outline),
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
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    // TODO: 删除单条历史记录
                    Get.snackbar(
                      '成功',
                      '已删除该条历史记录',
                      snackPosition: SnackPosition.BOTTOM,
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
