import 'package:flutter/material.dart';

class QuestionImageUpload extends StatelessWidget {
  final List<String> images;
  final VoidCallback onAddImage;
  final ValueChanged<int> onRemoveImage;
  final String? tip;

  const QuestionImageUpload({
    super.key,
    required this.images,
    required this.onAddImage,
    required this.onRemoveImage,
    this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...images.map((url) => _buildImageItem(context, url)).toList(),
            if (images.length < 10) _buildAddButton(context),
          ],
        ),
        if (tip != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.orange[700],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    tip!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(BuildContext context, String url) {
    final index = images.indexOf(url);
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => onRemoveImage(index),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: onAddImage,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey[400],
          size: 32,
        ),
      ),
    );
  }
}
