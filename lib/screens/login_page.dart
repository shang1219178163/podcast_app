import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/user_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 120,
              ),
              const SizedBox(height: 24),
              // 标题
              const Text(
                '播客',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // 副标题
              const Text(
                '聆听世界的声音',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              // 微信登录按钮
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (!controller.agreedToTerms.value) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text('提示'),
                                  content: const Text('请先阅读并同意用户协议和隐私政策'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('取消'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text('同意并继续'),
                                      onPressed: () {
                                        controller.agreedToTerms.value = true;
                                        Navigator.pop(context);
                                        controller.loginWithWeChat();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              controller.loginWithWeChat();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/wechat.png',
                          height: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '微信登录',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              // 手机号登录按钮
              Obx(() => OutlinedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (!controller.agreedToTerms.value) {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) => CupertinoAlertDialog(
                                  title: const Text('提示'),
                                  content: const Text('请先阅读并同意用户协议和隐私政策'),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text('取消'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text('同意并继续'),
                                      onPressed: () {
                                        controller.agreedToTerms.value = true;
                                        Navigator.pop(context);
                                        controller.loginWithPhone();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              controller.loginWithPhone();
                            }
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: const Text(
                      '手机号登录',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              // 用户协议和隐私政策
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(() => Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                        children: [
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            baseline: TextBaseline.alphabetic,
                            child: Container(
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: controller.agreedToTerms.value,
                                  onChanged: (_) => controller.toggleAgreement(),
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' 我已阅读并同意'),
                          TextSpan(
                            text: '《用户协议》',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = controller.openUserAgreement,
                          ),
                          const TextSpan(text: '和'),
                          TextSpan(
                            text: '《隐私政策》',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = controller.openPrivacyPolicy,
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                      ),
                    )),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
