import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/discover_controller.dart';
import '../widgets/list_item_widget.dart';

class DiscoverPage extends GetView<DiscoverController> {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildRoutesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      title: const Text(
        '路由导航',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.black87),
          onPressed: controller.refreshData,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: TextField(
            onChanged: controller.filterRoutes,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: '搜索路由...',
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600], size: 22),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoutesList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: controller.filteredRoutes.length,
        itemBuilder: (context, index) {
          final route = controller.filteredRoutes[index];
          final title = route
              .substring(1)
              .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
              .trim()
              .capitalize!;

          return ListItemWidget(
            title: title,
            subtitle: route,
            icon: Icons.route,
            onTap: () => controller.onRouteSelected(route),
            accessoryType: CellAccessoryType.none,
          );
        },
      ),
    );
  }
}
