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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.state.currentCategoryName.value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Obx(() {
        if (controller.state.isLoading.value && controller.state.podcasts.isEmpty) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        return EasyRefresh(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoad: controller.onLoading,
          child: controller.state.podcasts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.podcasts,
                        size: 64,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无播客内容',
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
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
