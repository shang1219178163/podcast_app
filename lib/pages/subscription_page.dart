import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../routes/app_pages.dart';
import '../widgets/network_image_widget.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('我的订阅', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const SubscriptionCard(),
                childCount: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 50,
          height: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: NetworkImageWidget(
              url: AppConstants.podcastCovers['future_tech'] ?? AppConstants.placeholderImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorWidget: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        ),
        title: const Text(
          '未来科技浪潮',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: const Text('科技早知道'),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
        onTap: () => Get.toNamed(AppRoute.player),
      ),
    );
  }
}
