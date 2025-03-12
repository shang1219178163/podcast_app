import 'package:flutter/material.dart';
import 'network_image_widget.dart';

class HospitalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoUrl;
  final String hospitalName;

  const HospitalAppBar({
    super.key,
    required this.logoUrl,
    required this.hospitalName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(
            height: 24,
            child: NetworkImageWidget(
              url: logoUrl,
              height: 24,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            hospitalName,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6CBFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.qr_code, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
