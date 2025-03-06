import 'package:flutter/material.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户协议'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '用户协议',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '欢迎使用播客应用！',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '1. 服务说明',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '播客应用是一个提供音频内容播放服务的平台。通过使用本应用，您同意遵守本协议的所有条款。',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '2. 用户行为规范',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '您在使用本应用时应遵守以下规范：\n'
              '• 遵守相关法律法规\n'
              '• 尊重知识产权\n'
              '• 维护良好的使用环境',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '3. 隐私保护',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '我们重视您的隐私保护，具体内容请参考隐私政策。',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '4. 协议修改',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '我们保留随时修改本协议的权利。修改后的协议将在应用内公布，继续使用本应用即表示您接受修改后的协议。',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
