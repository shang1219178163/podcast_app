import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:extended_image/extended_image.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableLoadState;
  final bool enableMemoryCache;
  final Duration? cacheMaxAge;
  final bool clearMemoryCacheIfFailed;
  final bool clearMemoryCacheWhenDispose;
  final Border? border;
  final bool isAntiAlias;
  final double aspectRatio;

  const NetworkImageWidget({
    super.key,
    this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.enableLoadState = true,
    this.enableMemoryCache = true,
    this.cacheMaxAge = const Duration(days: 30),
    this.clearMemoryCacheIfFailed = false,
    this.clearMemoryCacheWhenDispose = false,
    this.border,
    this.isAntiAlias = true,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder(context);
    }

    // 计算实际的宽高
    final double? actualWidth = width;
    final double? actualHeight = height ?? (actualWidth != null ? actualWidth / aspectRatio : null);

    final name = url?.split('/').last;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ExtendedImage.network(
        url!,
        width: actualWidth,
        height: actualHeight,
        fit: fit ?? BoxFit.cover,
        borderRadius: borderRadius,
        loadStateChanged: enableLoadState ? (state) => _buildLoadState(context, state) : null,
        enableMemoryCache: enableMemoryCache,
        cacheMaxAge: cacheMaxAge,
        clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        border: border,
        isAntiAlias: isAntiAlias,
        cache: true,
        retries: 3,
        timeLimit: const Duration(seconds: 15),
        headers: const {'accept': '*/*'},
        imageCacheName: "cache_image_$name",
        cacheWidth: (actualWidth ?? 200).toInt() * 2,
        compressionRatio: 0.7,
      ),
    );
  }

  Widget? _buildLoadState(BuildContext context, ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.completed:
        final image = state.extendedImageInfo?.image;
        return ExtendedRawImage(
          image: image,
          width: width,
          height: height ?? (width != null ? width! / aspectRatio : null),
          fit: fit ?? BoxFit.cover,
        );
      case LoadState.failed:
        return _buildErrorWidget(context);
      default:
        return _buildPlaceholder(context);
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return placeholder!;
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          'assets/images/img_placeholder.png',
          width: width,
          height: height ?? (width != null ? width! / aspectRatio : null),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) {
      return errorWidget!;
    }

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          'assets/images/img_placeholder.png',
          width: width,
          height: height ?? (width != null ? width! / aspectRatio : null),
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }
}
