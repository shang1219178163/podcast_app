import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/podcast.dart';
import '../widgets/network_image_widget.dart';
import '../routes/app_pages.dart';

class PodcastCard extends StatelessWidget {
  final Podcast podcast;

  const PodcastCard({
    super.key,
    required this.podcast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoute.podcastDetail,
          arguments: podcast.toJson(),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: NetworkImageWidget(
                url: podcast.cover ?? 'https://via.placeholder.com/160',
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
                errorWidget: Container(
                  width: double.infinity,
                  height: 160,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title ?? '未知标题',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    podcast.author ?? '未知作者',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
