import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '通知设置',
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
            title: '通知类型',
            children: [
              _buildSwitchTile(
                context: context,
                title: '新节目提醒',
                subtitle: '关注的主播发布新节目时通知',
                value: true,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                context: context,
                title: '更新提醒',
                subtitle: '订阅的播客更新时通知',
                value: true,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                context: context,
                title: '系统通知',
                subtitle: '系统消息和活动通知',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          _buildSection(
            context: context,
            title: '免打扰',
            children: [
              _buildSwitchTile(
                context: context,
                title: '开启免打扰',
                subtitle: '在指定时间段内不接收通知',
                value: false,
                onChanged: (value) {},
              ),
              _buildListTile(
                context: context,
                title: '免打扰时间',
                subtitle: '22:00 - 08:00',
                onTap: () {},
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
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
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
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }
}
