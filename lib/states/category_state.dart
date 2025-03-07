import 'package:get/get.dart';
import '../models/category.dart';
import '../models/podcast.dart';

class CategoryState {
  final categories = <Category>[].obs;
  final currentCategory = Rxn<Category>();
  final currentCategoryName = '分类详情'.obs;
  final podcasts = <Podcast>[].obs;
  final isLoading = false.obs;
  final page = 1.obs;
  final hasMore = true.obs;

  void setCurrentCategory(Category category) {
    currentCategory.value = category;
    currentCategoryName.value = category.name ?? '未知分类';
    podcasts.value = category.podcasts ?? [];
  }

  void clearCurrentCategory() {
    currentCategory.value = null;
    currentCategoryName.value = '分类详情';
    podcasts.clear();
  }

  void updatePodcasts(List<Podcast> newPodcasts, {bool clearExisting = false}) {
    if (clearExisting) {
      podcasts.clear();
    }
    podcasts.addAll(newPodcasts);
  }
}
