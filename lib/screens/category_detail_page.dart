import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/podcast_controller.dart';
import '../routes/app_pages.dart';

class CategoryDetailPage extends GetView<CategoryController> {
  const CategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              (controller.currentCategory.value?['name'] as String?) ?? '分类详情',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 10, // TODO: 使用实际的播客列表长度
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://example.com/cover$index.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
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
                      final podcastController = Get.find<PodcastController>();
                      podcastController.setCurrentPodcast({
                        'id': 'category_$index',
                        'title': '播客标题 $index',
                        'author': '作者名称',
                        'cover': 'https://example.com/cover$index.jpg',
                        'description': '播客描述',
                      });
                      Get.toNamed(AppRoute.player);
                    },
                  ),
                ],
              ),
              onTap: () => Get.toNamed(AppRoute.podcastDetail),
            );
          },
        );
      }),
    );
  }
}
