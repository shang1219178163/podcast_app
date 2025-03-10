import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/podcast.dart';
import '../controllers/discover_controller.dart';
import '../widgets/network_image_widget.dart';

class DiscoverSearchWidget extends StatelessWidget {
  final DiscoverController controller;

  const DiscoverSearchWidget({
    super.key,
    required this.controller,
  });

  // 根据输入过滤播客选项
  List<Podcast> _filterOptions(String query) {
    if (query.isEmpty) {
      return [];
    }

    // 忽略大小写进行匹配
    final lowercaseQuery = query.toLowerCase();
    return controller.allPodcasts
        .where((podcast) =>
            (podcast.title?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (podcast.author?.toLowerCase().contains(lowercaseQuery) ?? false) ||
            (podcast.description?.toLowerCase().contains(lowercaseQuery) ?? false))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Podcast>(
      displayStringForOption: (Podcast option) => option.title ?? '未知标题',
      optionsBuilder: (TextEditingValue textEditingValue) {
        return _filterOptions(textEditingValue.text);
      },
      onSelected: (Podcast selection) {
        // 导航到播客详情页
        Get.toNamed('/podcast/detail', arguments: selection);
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: '搜索播客、主播...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
          onSubmitted: (String value) {
            onFieldSubmitted();
          },
        );
      },
      optionsViewBuilder: (
        BuildContext context,
        AutocompleteOnSelected<Podcast> onSelected,
        Iterable<Podcast> options,
      ) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400, maxWidth: 600),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final podcast = options.elementAt(index);
                  return ListTile(
                    leading: podcast.cover != null
                        ? NetworkImageWidget(
                            url: podcast.cover!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorWidget: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          )
                        : Container(
                            width: 40,
                            height: 40,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                    title: Text(
                      podcast.title ?? '未知标题',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      podcast.author ?? '未知作者',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      onSelected(podcast);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
