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
  final Duration? cacheMaxAge;
  final bool clearMemoryCacheIfFailed;
  final bool clearMemoryCacheWhenDispose;
  final Border? border;
  final bool isAntiAlias;
  final double? aspectRatio;

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
    this.cacheMaxAge = const Duration(days: 30),
    this.clearMemoryCacheIfFailed = false,
    this.clearMemoryCacheWhenDispose = false,
    this.border,
    this.isAntiAlias = true,
    this.aspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder(context);
    }

    Widget image = ExtendedImage.network(
      url!,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      borderRadius: borderRadius,
      loadStateChanged: enableLoadState ? (state) => _buildLoadState(context, state) : null,
      cacheMaxAge: cacheMaxAge,
      clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
      clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
      border: border,
      isAntiAlias: isAntiAlias,
      cache: true,
      retries: 3,
      timeLimit: const Duration(seconds: 15),
      headers: const {'accept': '*/*'},
      imageCacheName: url,
      compressionRatio: 0.7,
    );

    if (aspectRatio != null) {
      image = AspectRatio(
        aspectRatio: aspectRatio!,
        child: image,
      );
    }

    return image;
  }

  Widget? _buildLoadState(BuildContext context, ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.completed:
        final Widget completedImage = state.completedWidget;
        return aspectRatio != null ? AspectRatio(aspectRatio: aspectRatio!, child: completedImage) : completedImage;
      case LoadState.failed:
        return _buildErrorWidget(context);
      default:
        return _buildPlaceholder(context);
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) {
      return _wrapWithAspectRatio(placeholder!);
    }

    return _wrapWithAspectRatio(
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          'assets/images/img_placeholder.png',
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) {
      return _wrapWithAspectRatio(errorWidget!);
    }

    return _wrapWithAspectRatio(
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          'assets/images/img_placeholder.png',
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
        ),
      ),
    );
  }

  Widget _wrapWithAspectRatio(Widget child) {
    if (aspectRatio != null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: child,
      );
    }
    return child;
  }
}
