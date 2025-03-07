import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../models/category.dart';
import '../models/podcast.dart';
import '../states/category_state.dart';

class CategoryController extends GetxController {
  final state = CategoryState();
  late final EasyRefreshController refreshController;

  // 定义固定的图片资源链接
  static const _coverImages = [
    // 音乐类
    'https://cdn.pixabay.com/photo/2018/08/01/14/04/microphone-3577562_1280.jpg',
    'https://cdn.pixabay.com/photo/2015/05/07/11/02/guitar-756326_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/19/13/57/audio-1839162_1280.jpg',
    'https://cdn.pixabay.com/photo/2019/05/26/06/20/turntable-4229955_1280.jpg',

    // 科技类
    'https://cdn.pixabay.com/photo/2016/11/22/19/15/hand-1850120_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/12/02/14/38/contact-us-2993000_1280.jpg',
    'https://cdn.pixabay.com/photo/2020/02/19/07/48/web-4861605_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/05/08/08/44/artificial-intelligence-3382507_1280.jpg',

    // 商业类
    'https://cdn.pixabay.com/photo/2019/07/09/11/04/podcast-4326108_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/19/09/57/man-1838330_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/03/27/21/43/startup-3267505_1280.jpg',
    'https://cdn.pixabay.com/photo/2015/01/09/11/08/startup-594090_1280.jpg',

    // 教育类
    'https://cdn.pixabay.com/photo/2015/07/31/11/45/library-869061_1280.jpg',
    'https://cdn.pixabay.com/photo/2015/11/19/21/10/glasses-1052010_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/29/09/41/bag-1868758_1280.jpg',
    'https://cdn.pixabay.com/photo/2016/11/19/14/00/code-1839406_1280.jpg',

    // 生活方式
    'https://cdn.pixabay.com/photo/2017/08/06/12/06/people-2591874_1280.jpg',
    'https://cdn.pixabay.com/photo/2018/01/01/01/56/yoga-3053488_1280.jpg',
    'https://cdn.pixabay.com/photo/2017/02/04/12/25/man-2037255_1280.jpg',
  ];

  String _getCoverImage(int index) {
    return _coverImages[index % _coverImages.length];
  }

  @override
  void onInit() {
    super.onInit();
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    loadCategories();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> loadCategories() async {
    if (state.isLoading.value) return;

    state.isLoading.value = true;
    try {
      // TODO: 从API加载分类列表
      await Future.delayed(const Duration(seconds: 1)); // 模拟加载
      final categoriesData = [
        Category(
          id: '1',
          name: '音乐',
          icon: 'music_note',
          podcasts: [
            Podcast(
              id: '1',
              title: '古典音乐赏析',
              author: 'David Chen',
              subscribers: '2.3万',
              cover: _getCoverImage(0),
            ),
          ],
        ),
        Category(
          id: '2',
          name: '科技',
          icon: 'science',
          podcasts: [
            Podcast(
              id: '2',
              title: '科技前沿',
              author: 'Tech Insider',
              subscribers: '4.5万',
              cover: _getCoverImage(1),
            ),
          ],
        ),
      ];

      state.categories.value = categoriesData;

      // 如果当前没有选中的分类，默认选择第一个
      if (state.currentCategory.value == null && categoriesData.isNotEmpty) {
        state.setCurrentCategory(categoriesData[0]);
      } else if (state.currentCategory.value != null && categoriesData.isNotEmpty) {
        // 更新当前分类的播客列表
        final currentId = state.currentCategory.value?.id;
        final category = currentId != null
            ? categoriesData.firstWhereOrNull((c) => c.id == currentId) ?? categoriesData[0]
            : categoriesData[0];
        state.setCurrentCategory(category);
      }
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载分类列表失败: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> loadData() async {
    if (state.isLoading.value) return;

    state.isLoading.value = true;
    try {
      // 模拟网络请求
      await Future.delayed(const Duration(seconds: 1));

      // 获取当前分类
      final currentCategory = state.currentCategory.value;
      if (currentCategory == null) {
        throw Exception('没有选中的分类');
      }

      // 生成新的播客数据
      final baseIndex = (state.page.value - 1) * 10;
      final newPodcasts = List.generate(
        10,
        (index) => Podcast(
          id: '${baseIndex + index + 1}',
          title: '${currentCategory.name ?? ''} 播客 ${baseIndex + index + 1}',
          author: '作者 ${baseIndex + index + 1}',
          subscribers: '${(baseIndex + index + 1) * 100}',
          cover: _getCoverImage(baseIndex + index),
        ),
      );

      state.updatePodcasts(
        newPodcasts,
        clearExisting: state.page.value == 1,
      );
      state.hasMore.value = state.page.value < 3; // 模拟只有3页数据
    } catch (e) {
      Get.snackbar(
        '错误',
        '加载播客列表失败: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow; // 重新抛出异常以便上层处理
    } finally {
      state.isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      state.page.value = 1;
      state.hasMore.value = true;
      await loadData();
      refreshController.finishRefresh(IndicatorResult.success);
      refreshController.resetFooter();
    } catch (e) {
      refreshController.finishRefresh(IndicatorResult.fail);
    }
  }

  Future<void> onLoading() async {
    try {
      if (!state.hasMore.value) {
        refreshController.finishLoad(IndicatorResult.noMore);
        return;
      }

      state.page.value++;
      await loadData();
      refreshController.finishLoad(state.hasMore.value ? IndicatorResult.success : IndicatorResult.noMore);
    } catch (e) {
      state.page.value--; // 恢复页码
      refreshController.finishLoad(IndicatorResult.fail);
    }
  }

  void setCurrentCategory(Category category) {
    state.setCurrentCategory(category);
    onRefresh();
  }
}
