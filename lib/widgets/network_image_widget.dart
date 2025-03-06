import 'package:flutter/material.dart';
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

  const NetworkImageWidget({
    Key? key,
    this.url,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.enableLoadState = true,
    this.enableMemoryCache = true,
    this.cacheMaxAge,
    this.clearMemoryCacheIfFailed = true,
    this.clearMemoryCacheWhenDispose = true,
    this.border,
    this.isAntiAlias = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _buildPlaceholder();
    }

    return ExtendedImage.network(
      url!,
      width: width == null ? null : (width! * 3),
      height: height == null ? null : (height! * 3),
      fit: fit ?? BoxFit.cover,
      borderRadius: borderRadius,
      loadStateChanged: enableLoadState ? _buildLoadState : null,
      enableMemoryCache: enableMemoryCache,
      cacheMaxAge: cacheMaxAge,
      clearMemoryCacheIfFailed: clearMemoryCacheIfFailed,
      clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
      border: border,
      isAntiAlias: isAntiAlias,
    );
  }

  Widget? _buildLoadState(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.completed:
        final image = state.extendedImageInfo?.image;
        return ExtendedRawImage(
          image: image,
          width: width ?? image?.width.toDouble(),
          height: height ?? image?.height.toDouble(),
          fit: fit,
        );
      default:
        return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return placeholder!;
    }

    final placeholderImage = Image(
      image:  AssetImage("assets/images/img_placeholder.png"),
      width: width,
      height: height,
      fit: fit,
    );

    
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: placeholderImage,
    );
  }

  Widget _buildErrorWidget() {
    if (errorWidget != null) {
      return errorWidget!;
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(
        Icons.error_outline,
        color: Colors.grey,
      ),
    );
  }
}
