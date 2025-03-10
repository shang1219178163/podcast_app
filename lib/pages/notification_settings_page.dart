import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatelessWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '通知设置',
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
            title: '通知类型',
            children: [
              _buildSwitchTile(
                title: '新节目提醒',
                subtitle: '关注的主播发布新节目时通知',
                value: true,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: '更新提醒',
                subtitle: '订阅的播客更新时通知',
                value: true,
                onChanged: (value) {},
              ),
              _buildSwitchTile(
                title: '系统通知',
                subtitle: '系统消息和活动通知',
                value: true,
                onChanged: (value) {},
              ),
            ],
          ),
          _buildSection(
            title: '免打扰',
            children: [
              _buildSwitchTile(
                title: '开启免打扰',
                subtitle: '在指定时间段内不接收通知',
                value: false,
                onChanged: (value) {},
              ),
              _buildListTile(
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
  }) {
    return ListTile(
      title: Text(title),
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
}
