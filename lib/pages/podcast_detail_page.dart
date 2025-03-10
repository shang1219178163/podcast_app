import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

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
        background: Image.network(
          AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
          fit: BoxFit.cover,
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
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    NetworkImage(AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage),
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
