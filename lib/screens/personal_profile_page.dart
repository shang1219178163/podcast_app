import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class PersonalProfilePage extends GetView<ProfileController> {
  const PersonalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '个人资料',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = controller.userProfile.value;
        if (profile == null) {
          return const Center(child: Text('加载失败'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildAvatarSection(profile),
            const SizedBox(height: 24),
            _buildProfileField(
              title: '昵称',
              value: (profile['nickname'] as String?) ?? '',
              onTap: () => _showEditDialog(context, 'nickname'),
            ),
            _buildProfileField(
              title: '个人简介',
              value: (profile['bio'] as String?) ?? '',
              onTap: () => _showEditDialog(context, 'bio'),
            ),
            _buildProfileField(
              title: '手机号',
              value: (profile['phone'] as String?) ?? '未绑定',
              onTap: () => _showEditDialog(context, 'phone'),
            ),
            _buildProfileField(
              title: '邮箱',
              value: (profile['email'] as String?) ?? '未绑定',
              onTap: () => _showEditDialog(context, 'email'),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildAvatarSection(Map<String, dynamic> profile) {
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
                    color: Theme.of(Get.context!).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            (profile['nickname'] as String?) ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showEditDialog(BuildContext context, String field) {
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
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('确定'),
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
