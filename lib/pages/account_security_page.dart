import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AccountSecurityPage extends StatelessWidget {
  const AccountSecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '账号安全',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: ListView(
        children: [
          _buildSection(
            context: context,
            title: '登录密码',
            children: [
              _buildListTile(
                context: context,
                title: '修改密码',
                subtitle: '定期修改密码可以提高账号安全性',
                onTap: () => _showChangePasswordDialog(context),
              ),
            ],
          ),
          _buildSection(
            context: context,
            title: '手机号',
            children: [
              _buildListTile(
                context: context,
                title: '更换手机号',
                subtitle: '当前绑定：138****8888',
                onTap: () => _showChangePhoneDialog(context),
              ),
            ],
          ),
          _buildSection(
            context: context,
            title: '安全设置',
            children: [
              _buildSwitchTile(
                context: context,
                title: '指纹解锁',
                subtitle: '使用指纹解锁应用',
                value: false,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                context: context,
                title: '面容解锁',
                subtitle: '使用面容解锁应用',
                value: false,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                context: context,
                title: '登录通知',
                subtitle: '当账号在新设备登录时通知',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          _buildSection(
            context: context,
            title: '账号注销',
            children: [
              _buildListTile(
                context: context,
                title: '注销账号',
                subtitle: '注销后账号将无法恢复',
                textColor: theme.colorScheme.error,
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? theme.colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: theme.colorScheme.onSurface.withOpacity(0.6),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
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
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final theme = Theme.of(context);
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: theme.brightness,
          primaryColor: theme.colorScheme.primary,
        ),
        child: CupertinoAlertDialog(
          title: Text(
            '修改密码',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: oldPasswordController,
                  placeholder: '当前密码',
                  obscureText: true,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: newPasswordController,
                  placeholder: '新密码',
                  obscureText: true,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: confirmPasswordController,
                  placeholder: '确认新密码',
                  obscureText: true,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                '取消',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text(
                '确定',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () {
                // TODO: 实现密码修改
                Navigator.pop(context);
                Get.snackbar(
                  '成功',
                  '密码修改成功',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: theme.colorScheme.surface,
                  colorText: theme.colorScheme.onSurface,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePhoneDialog(BuildContext context) {
    final theme = Theme.of(context);
    final phoneController = TextEditingController();
    final codeController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: theme.brightness,
          primaryColor: theme.colorScheme.primary,
        ),
        child: CupertinoAlertDialog(
          title: Text(
            '更换手机号',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: phoneController,
                  placeholder: '新手机号',
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: codeController,
                        placeholder: '验证码',
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // TODO: 发送验证码
                      },
                      child: Text(
                        '获取验证码',
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                '取消',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text(
                '确定',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () {
                // TODO: 实现手机号更换
                Navigator.pop(context);
                Get.snackbar(
                  '成功',
                  '手机号更换成功',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: theme.colorScheme.surface,
                  colorText: theme.colorScheme.onSurface,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final theme = Theme.of(context);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: theme.brightness,
          primaryColor: theme.colorScheme.primary,
        ),
        child: CupertinoAlertDialog(
          title: Text(
            '注销账号',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          content: Text(
            '注销后账号将无法恢复，确定要注销吗？',
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                '取消',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(
                '确定注销',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onPressed: () {
                // TODO: 实现账号注销
                Navigator.pop(context);
                Get.snackbar(
                  '成功',
                  '账号已注销',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: theme.colorScheme.surface,
                  colorText: theme.colorScheme.onSurface,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
