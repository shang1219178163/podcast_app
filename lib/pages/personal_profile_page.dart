import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class PersonalProfilePage extends GetView<ProfileController> {
  const PersonalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '个人资料',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }
        final profile = controller.userProfile.value;
        if (profile == null) {
          return Center(
            child: Text(
              '加载失败',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatarSection(profile, context),
            const SizedBox(height: 24),
            _buildProfileField(
              context: context,
              title: '昵称',
              value: (profile['nickname'] as String?) ?? '',
              onTap: () => _showEditDialog(context, 'nickname'),
            ),
            _buildProfileField(
              context: context,
              title: '个人简介',
              value: (profile['bio'] as String?) ?? '',
              onTap: () => _showEditDialog(context, 'bio'),
            ),
            _buildProfileField(
              context: context,
              title: '手机号',
              value: (profile['phone'] as String?) ?? '未绑定',
              onTap: () => _showEditDialog(context, 'phone'),
            ),
            _buildProfileField(
              context: context,
              title: '邮箱',
              value: (profile['email'] as String?) ?? '未绑定',
              onTap: () => _showEditDialog(context, 'email'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAvatarSection(Map<String, dynamic> profile, BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage((profile['avatar'] as String?) ?? ''),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            (profile['nickname'] as String?) ?? '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required BuildContext context,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
    );
  }

  void _showEditDialog(BuildContext context, String field) {
    final theme = Theme.of(context);
    final controller = TextEditingController(
      text: (this.controller.userProfile.value?[field] as String?) ?? '',
    );
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('修改$field'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: CupertinoTextField(
            controller: controller,
            placeholder: '请输入新的$field',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
            placeholderStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                final newProfile = Map<String, dynamic>.from(
                  this.controller.userProfile.value ?? {},
                );
                newProfile[field] = value;
                this.controller.updateProfile(newProfile);
                Navigator.pop(context);
              }
            },
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              '取消',
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: Text(
              '确定',
              style: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
            onPressed: () {
              final newValue = controller.text;
              if (newValue.isNotEmpty) {
                final newProfile = Map<String, dynamic>.from(
                  this.controller.userProfile.value ?? {},
                );
                newProfile[field] = newValue;
                this.controller.updateProfile(newProfile);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
