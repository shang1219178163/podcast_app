import 'package:flutter/material.dart';
import '../models/podcast.dart';
import 'network_image_widget.dart';

class PodcastListItem extends StatelessWidget {
  final Podcast podcast;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;

  const PodcastListItem({
    super.key,
    required this.podcast,
    this.onTap,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: NetworkImageWidget(
          url: podcast.cover ?? '',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        podcast.title ?? '未知标题',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${podcast.author ?? '未知作者'} · ${podcast.subscribers ?? '0'}订阅',
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
            onPressed: onPlayTap,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
