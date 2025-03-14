import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/network_image_widget.dart';

enum CellAccessoryType {
  none,
  disclosureIndicator,
  checkmark,
}

class ListItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Widget? icon;
  final Widget? titleRight;
  final Widget? subtitleRight;
  final VoidCallback? onTap;
  final Widget? trailing;
  final double? imageSize;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
  final bool showArrow;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final double? height;
  final CellAccessoryType accessoryType;
  final bool fixedHeight;
  final EdgeInsetsGeometry contentPadding;
  final bool highlighted;

  const ListItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.icon,
    this.titleRight,
    this.subtitleRight,
    this.onTap,
    this.trailing,
    this.imageSize = 48,
    this.iconSize = 22,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.showDivider = true,
    this.showArrow = true,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.height = 64,
    this.accessoryType = CellAccessoryType.disclosureIndicator,
    this.fixedHeight = true,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 10),
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBackgroundColor = theme.scaffoldBackgroundColor;
    final highlightColor = theme.colorScheme.surface;

    final Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Leading
        if (imageUrl != null || icon != null) ...[
          _buildLeading(context),
          const SizedBox(width: 16),
        ],

        // Title and Subtitle
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: fixedHeight ? MainAxisAlignment.center : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle ??
                          TextStyle(
                            fontSize: 17,
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w400,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (titleRight != null) ...[
                    const SizedBox(width: 8),
                    titleRight!,
                  ],
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle!,
                        style: subtitleStyle ??
                            TextStyle(
                              fontSize: 15,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                              height: 1.2,
                            ),
                      ),
                    ),
                    if (subtitleRight != null) ...[
                      const SizedBox(width: 8),
                      subtitleRight!,
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),

        // Trailing
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ] else if (showArrow && accessoryType != CellAccessoryType.none && onTap != null) ...[
          const SizedBox(width: 8),
          _buildAccessory(context),
        ],
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        color: highlighted ? highlightColor : (backgroundColor ?? defaultBackgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fixedHeight)
              SizedBox(
                height: height,
                child: Padding(
                  padding: padding!,
                  child: content,
                ),
              )
            else
              Padding(
                padding: padding!.add(contentPadding),
                child: content,
              ),
            if (showDivider)
              Padding(
                padding: EdgeInsets.only(
                  left: imageUrl != null || icon != null ? 60 : 16,
                ),
                child: Divider(
                  height: 0.5,
                  thickness: 0.5,
                  color: theme.dividerColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    final theme = Theme.of(context);
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: NetworkImageWidget(
          url: imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorWidget: Container(
            width: 40,
            height: 40,
            color: theme.colorScheme.surface,
            child: Icon(Icons.image, color: theme.colorScheme.onSurface.withOpacity(0.4)),
          ),
        ),
      );
    } else if (icon != null) {
      return icon!;
    }
    return const SizedBox.shrink();
  }

  Widget _buildAccessory(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) {
        switch (accessoryType) {
          case CellAccessoryType.disclosureIndicator:
            return Icon(
              CupertinoIcons.chevron_forward,
              size: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            );
          case CellAccessoryType.checkmark:
            return Icon(
              CupertinoIcons.checkmark,
              size: 18,
              color: theme.colorScheme.primary,
            );
          case CellAccessoryType.none:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
