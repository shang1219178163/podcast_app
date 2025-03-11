import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../controllers/podcast_controller.dart';
import '../widgets/network_image_widget.dart';

class FavoritesPage extends GetView<PodcastController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          '我的收藏',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // TODO: 使用实际的收藏列表长度
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
              '作者名称 · 2.3万订阅',
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
                      'id': 'favorite_$index',
                      'title': '播客标题 $index',
                      'author': '作者名称',
                      'cover': 'https://example.com/cover$index.jpg',
                      'description': '播客描述',
                    });
                    Get.toNamed(AppRoute.player);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: Colors.red,
                  onPressed: () {
                    // TODO: 取消收藏
                    Get.snackbar(
                      '成功',
                      '已取消收藏',
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
