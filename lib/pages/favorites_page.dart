import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../controllers/podcast_controller.dart';
import '../widgets/network_image_widget.dart';

class FavoritesPage extends GetView<PodcastController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的收藏',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
              '作者名称 · 2.3万订阅',
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
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    // TODO: 取消收藏
                    Get.snackbar(
                      '成功',
                      '已取消收藏',
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
