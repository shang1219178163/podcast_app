import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class QuestionImageUpload extends StatefulWidget {
  final List<String>? initialImages;
  final Function(List<String>) onImagesChanged;
  final String? tip;
  final int maxCount;
  final int numOfRow;

  const QuestionImageUpload({
    super.key,
    this.initialImages,
    required this.onImagesChanged,
    this.tip,
    this.maxCount = 10,
    this.numOfRow = 4,
  });

  @override
  State<QuestionImageUpload> createState() => _QuestionImageUploadState();
}

class _QuestionImageUploadState extends State<QuestionImageUpload> {
  late List<String> _images;

  @override
  void initState() {
    super.initState();
    _images = widget.initialImages?.toList() ?? [];
  }

  @override
  void didUpdateWidget(QuestionImageUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialImages != oldWidget.initialImages) {
      setState(() {
        _images = widget.initialImages?.toList() ?? [];
      });
    }
  }

  // 检查并请求权限
  Future<bool> _checkPermission() async {
    // 检查平台
    if (Platform.isIOS) {
      // iOS 权限检查
      PermissionStatus photoStatus = await Permission.photos.status;

      if (!photoStatus.isGranted) {
        photoStatus = await Permission.photos.request();
        if (!photoStatus.isGranted) {
          _showPermissionDeniedDialog('相册');
          return false;
        }
      }

      // 如果需要相机权限
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          _showPermissionDeniedDialog('相机');
          return false;
        }
      }

      return true;
    } else if (Platform.isAndroid) {
      // Android 权限检查
      // 检查 Android 版本
      if (await _isAndroid13OrAbove()) {
        // Android 13+ 使用 READ_MEDIA_IMAGES
        PermissionStatus mediaImagesStatus = await Permission.photos.status;
        if (!mediaImagesStatus.isGranted) {
          mediaImagesStatus = await Permission.photos.request();
          if (!mediaImagesStatus.isGranted) {
            _showPermissionDeniedDialog('相册');
            return false;
          }
        }
      } else {
        // Android 12 及以下使用 READ_EXTERNAL_STORAGE
        PermissionStatus storageStatus = await Permission.storage.status;
        if (!storageStatus.isGranted) {
          storageStatus = await Permission.storage.request();
          if (!storageStatus.isGranted) {
            _showPermissionDeniedDialog('存储');
            return false;
          }
        }
      }

      // 如果需要相机权限
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          _showPermissionDeniedDialog('相机');
          return false;
        }
      }

      return true;
    }

    // 其他平台
    return true;
  }

  // 检查是否为 Android 13 或更高版本
  Future<bool> _isAndroid13OrAbove() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33; // Android 13 是 API 33
    }
    return false;
  }

  // 显示权限被拒绝的对话框
  void _showPermissionDeniedDialog(String permissionName) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('需要$permissionName权限'),
        content: Text('请在设置中允许应用访问您的$permissionName，以便上传图片'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('去设置'),
          ),
        ],
      ),
    );
  }

  // 选择图片
  Future<void> _pickImage() async {
    if (_images.length >= widget.maxCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('最多只能上传${widget.maxCount}张图片'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // // 检查权限
    // bool hasPermission = await _checkPermission();
    // if (!hasPermission) return;

    // 计算还可以选择的图片数量
    final int remainingCount = widget.maxCount - _images.length;

    // 使用wechat_assets_picker选择图片
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: remainingCount,
        requestType: RequestType.image,
      ),
    );

    if (result != null && result.isNotEmpty) {
      // 处理选中的图片
      for (final AssetEntity asset in result) {
        final File? file = await asset.file;
        if (file != null) {
          setState(() {
            _images.add(file.path);
          });
        }
      }

      // 通知父组件图片变化
      widget.onImagesChanged(_images);
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });

    // 通知父组件图片变化
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            // 计算图片项的宽度，基于每行显示的图片数量和可用宽度
            final availableWidth = constraints.maxWidth;
            final spacing = 8.0 * (widget.numOfRow - 1); // 图片之间的间距总和
            final itemWidth = (availableWidth - spacing) / widget.numOfRow;

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._images.map((path) => _buildImageItem(context, path, itemWidth)).toList(),
                if (_images.length < widget.maxCount) _buildAddButton(context, itemWidth),
              ],
            );
          },
        ),
        if (widget.tip != null)
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
                    widget.tip!,
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

  Widget _buildImageItem(BuildContext context, String path, double width) {
    final index = _images.indexOf(path);
    return Stack(
      children: [
        Container(
          width: width.truncateToDouble(),
          height: width.truncateToDouble(),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: path.startsWith('http') ? NetworkImage(path) as ImageProvider : FileImage(File(path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
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

  Widget _buildAddButton(BuildContext context, double width) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: width,
        height: width,
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
