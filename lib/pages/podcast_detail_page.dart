import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/network_image_widget.dart';

class PodcastDetailPage extends StatelessWidget {
  const PodcastDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(theme),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                _buildDescription(theme),
                _buildEpisodesList(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      flexibleSpace: FlexibleSpaceBar(
        background: NetworkImageWidget(
          url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorWidget: Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.colorScheme.surface,
            child: Icon(Icons.image, color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '未来科技浪潮',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipOval(
                child: NetworkImageWidget(
                  url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 32,
                    height: 32,
                    color: theme.colorScheme.surface,
                    child: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.5), size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '科技早知道',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('订阅'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '探索科技前沿，解读未来趋势。每周更新，带你了解最新科技动态。',
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildEpisodesList(ThemeData theme) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            '第 ${10 - index} 期：AI 技术的最新进展',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          subtitle: Text(
            '2024-03-${10 - index} · 45分钟',
            style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
          ),
          trailing: Icon(
            Icons.play_circle_outline,
            color: theme.colorScheme.primary,
          ),
          onTap: () {},
        );
      },
    );
  }
}
