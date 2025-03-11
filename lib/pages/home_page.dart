import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_pages.dart';
import '../widgets/network_image_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
          SliverToBoxAdapter(
            child: _buildCategories(),
          ),
          SliverToBoxAdapter(
            child: _buildRecommendedSection(),
          ),
          SliverToBoxAdapter(
            child: _buildNewEpisodesSection(),
          ),
          SliverToBoxAdapter(
            child: _buildPopularSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      pinned: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text(
        '发现',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(Get.context!);
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(width: 8),
            Text(
              '搜索播客、节目、主播',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'icon': Icons.music_note, 'name': '音乐'},
      {'icon': Icons.science, 'name': '科技'},
      {'icon': Icons.business, 'name': '商业'},
      {'icon': Icons.psychology, 'name': '心理'},
      {'icon': Icons.sports_esports, 'name': '游戏'},
      {'icon': Icons.movie, 'name': '影视'},
      {'icon': Icons.school, 'name': '教育'},
      {'icon': Icons.sports_soccer, 'name': '体育'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final theme = Theme.of(context);
          return Container(
            width: 60,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Icon(
                    categories[index]['icon'] as IconData,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index]['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedSection() {
    final theme = Theme.of(Get.context!);
    return _buildSection(
      title: '为你推荐',
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              width: 160,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: NetworkImageWidget(
                      url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: double.infinity,
                        height: 120,
                        color: theme.colorScheme.surface,
                        child: Icon(Icons.image, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '未来科技浪潮',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '科技早知道',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewEpisodesSection() {
    final theme = Theme.of(Get.context!);
    return _buildSection(
      title: '最新更新',
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: NetworkImageWidget(
                url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surface,
                  child: Icon(Icons.image, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                ),
              ),
            ),
            title: Text(
              'AI 技术的最新进展',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '科技早知道 · 2小时前',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              onPressed: () {},
            ),
            onTap: () => Get.toNamed(AppRoute.player),
          );
        },
      ),
    );
  }

  Widget _buildPopularSection() {
    final theme = Theme.of(Get.context!);
    return _buildSection(
      title: '热门播客',
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.defaultPadding,
              vertical: 8,
            ),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: NetworkImageWidget(
                url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surface,
                  child: Icon(Icons.image, color: theme.colorScheme.onSurface.withOpacity(0.4)),
                ),
              ),
            ),
            title: Text(
              '未来科技浪潮',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              '科技早知道 · 2.3万订阅',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              onPressed: () {},
            ),
            onTap: () => Get.toNamed(AppRoute.podcastDetail),
          );
        },
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    final theme = Theme.of(Get.context!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  '更多',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
