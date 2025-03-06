import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '账号安全',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: '登录密码',
            children: [
              _buildListTile(
                title: '修改密码',
                subtitle: '定期修改密码可以提高账号安全性',
                onTap: () => _showChangePasswordDialog(context),
              ),
            ],
          ),
          _buildSection(
            title: '手机号',
            children: [
              _buildListTile(
                title: '更换手机号',
                subtitle: '当前绑定：138****8888',
                onTap: () => _showChangePhoneDialog(context),
              ),
            ],
          ),
          _buildSection(
            title: '安全设置',
            children: [
              _buildSwitchTile(
                title: '指纹解锁',
                subtitle: '使用指纹解锁应用',
                value: false,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: '面容解锁',
                subtitle: '使用面容解锁应用',
                value: false,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: '登录通知',
                subtitle: '当账号在新设备登录时通知',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          _buildSection(
            title: '账号注销',
            children: [
              _buildListTile(
                title: '注销账号',
                subtitle: '注销后账号将无法恢复',
                textColor: Colors.red,
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('修改密码'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: oldPasswordController,
                placeholder: '当前密码',
                obscureText: true,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: newPasswordController,
                placeholder: '新密码',
                obscureText: true,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: confirmPasswordController,
                placeholder: '确认新密码',
                obscureText: true,
              ),
            ],
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
              // TODO: 实现密码修改
              Navigator.pop(context);
              Get.snackbar(
                '成功',
                '密码修改成功',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog(BuildContext context) {
    final phoneController = TextEditingController();
    final codeController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('更换手机号'),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                controller: phoneController,
                placeholder: '新手机号',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: codeController,
                      placeholder: '验证码',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      // TODO: 发送验证码
                    },
                    child: const Text('获取验证码'),
                  ),
                ],
              ),
            ],
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
              // TODO: 实现手机号更换
              Navigator.pop(context);
              Get.snackbar(
                '成功',
                '手机号更换成功',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('注销账号'),
        content: const Text('注销后账号将无法恢复，确定要注销吗？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('确定注销'),
            onPressed: () {
              // TODO: 实现账号注销
              Navigator.pop(context);
              Get.snackbar(
                '成功',
                '账号已注销',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),
    );
  }
}
