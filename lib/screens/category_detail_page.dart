import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../controllers/category_controller.dart';
import '../controllers/podcast_controller.dart';
import '../routes/app_pages.dart';
import '../widgets/podcast_list_item.dart';

class CategoryDetailPage extends GetView<CategoryController> {
  const CategoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.state.currentCategoryName.value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.state.isLoading.value && controller.state.podcasts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return EasyRefresh(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoad: controller.onLoading,
          child: controller.state.podcasts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.podcasts,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        '暂无播客内容',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.state.podcasts.length,
                  itemBuilder: (context, index) {
                    final podcast = controller.state.podcasts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: PodcastListItem(
                        podcast: podcast,
                        onTap: () => Get.toNamed(
                          AppRoute.podcastDetail,
                          arguments: podcast,
                        ),
                        onPlayTap: () {
                          final podcastController = Get.find<PodcastController>();
                          podcastController.setCurrentPodcast(podcast.toJson());
                          Get.toNamed(AppRoute.player);
                        },
                      ),
                    );
                  },
                ),
        );
      }),
    );
  }
}
