import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/hospital_app_bar.dart';
import '../widgets/hospital_service_card.dart';
import '../widgets/hospital_task_card.dart';
import '../widgets/hospital_stats_card.dart';
import '../widgets/hospital_guide_card.dart';
import '../widgets/hospital_quick_action.dart';
import '../utils/R.dart';
import '../controllers/tab_bar_controller.dart';

// 自定义梯形裁剪器
class HospitalTrapezoidClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.15); // 左上角
    path.lineTo(size.width, 0); // 右上角
    path.lineTo(size.width, size.height); // 右下角
    path.lineTo(0, size.height); // 左下角
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class HospitalManagementPage extends StatelessWidget {
  const HospitalManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HospitalAppBar(
        logoUrl: R.image.urls[0],
        hospitalName: '北京空港医院',
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWelcomeSection(theme),
          const SizedBox(height: 24),
          _buildServiceSection(context, theme),
          const SizedBox(height: 24),
          _buildTaskSection(theme),
          const SizedBox(height: 24),
          _buildQuickActionSection(theme),
          const SizedBox(height: 24),
          _buildStatsSection(theme),
          const SizedBox(height: 24),
          _buildGuideSection(theme),
        ],
      ),
      bottomNavigationBar: GetBuilder<NTabBarController>(
        builder: (controller) => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.changeNav(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: '消息',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: '患者',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '全病程管理平台欢迎您',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '累计患者数：22',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceSection(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildSectionTitle(theme, '健康服务'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: HospitalServiceCard(
                title: '管理方案',
                imageUrl: R.image.urls[1],
                onTap: () => _showServiceDialog(context, '管理方案'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: HospitalServiceCard(
                title: '康复计划',
                imageUrl: R.image.urls[2],
                onTap: () => _showServiceDialog(context, '康复计划'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskSection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionTitle(theme, '待办事项'),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2,
          children: const [
            HospitalTaskCard(title: '待处理', count: '22', backgroundColor: Color(0xFFFFF3E0)),
            HospitalTaskCard(title: '待接诊', count: '22', backgroundColor: Color(0xFFE8F5E9)),
            HospitalTaskCard(title: '未打卡', count: '22', backgroundColor: Color(0xFFE3F2FD)),
            HospitalTaskCard(title: '异常反馈', count: '22', backgroundColor: Color(0xFFFFEBEE)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionSection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionTitle(theme, '快速发送'),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            HospitalQuickAction(icon: Icons.message, title: '消息'),
            HospitalQuickAction(icon: Icons.assignment, title: '问卷'),
            HospitalQuickAction(icon: Icons.calendar_today, title: '预约'),
            HospitalQuickAction(icon: Icons.medical_services, title: '处方'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionTitle(theme, '数据统计'),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(
              child: HospitalStatsCard(
                title: '总患者数',
                value: '1,234',
                icon: Icons.people,
                color: Color(0xFF6CBFFF),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: HospitalStatsCard(
                title: '今日新增',
                value: '56',
                icon: Icons.trending_up,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGuideSection(ThemeData theme) {
    return Column(
      children: [
        _buildSectionTitle(theme, '指南'),
        const SizedBox(height: 12),
        Column(
          children: [
            HospitalGuideCard(
              title: '全病程介绍',
              subtitle: '通过研究型互联网医疗平台，全病程管理...',
              imageUrl: R.image.urls[3],
            ),
            const SizedBox(height: 12),
            HospitalGuideCard(
              title: '服务介绍',
              subtitle: '医生方面极致患者病情综合评估，推荐需要...',
              imageUrl: R.image.urls[4],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showServiceDialog(BuildContext context, String title) {
    final theme = Theme.of(context);
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '该功能正在开发中，敬请期待...',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  '确定',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
