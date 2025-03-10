import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/network_image_widget.dart';

class PodcastDetailPage extends StatelessWidget {
  const PodcastDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildDescription(),
                _buildEpisodesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: NetworkImageWidget(
          url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorWidget: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: const Icon(Icons.image, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '未来科技浪潮',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey, size: 16),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('科技早知道'),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('订阅'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '探索科技前沿，解读未来趋势。每周更新，带你了解最新科技动态。',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildEpisodesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('第 ${10 - index} 期：AI 技术的最新进展'),
          subtitle: Text('2024-03-${10 - index} · 45分钟'),
          trailing: const Icon(Icons.play_circle_outline),
          onTap: () {},
        );
      },
    );
  }
}
