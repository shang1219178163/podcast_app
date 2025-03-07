import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const ListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing = const Icon(Icons.arrow_forward_ios, size: 16),
    this.onTap,
    this.titleFontSize = 16,
    this.subtitleFontSize = 12,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      color: backgroundColor,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  fontSize: subtitleFontSize,
                  color: Colors.grey[600],
                ),
              )
            : null,
        leading: leading,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
