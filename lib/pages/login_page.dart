import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              Text(
                '播客',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              // 副标题
              Text(
                '聆听世界的声音',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                                        '同意并继续',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
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
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
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
                        Text(
                          '微信登录',
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
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
                                        '同意并继续',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
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
                        side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                      ),
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    child: Text(
                      '手机号登录',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  )),
              const SizedBox(height: 24),
              // 用户协议和隐私政策
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(() => Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
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
                                  activeColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(text: ' 我已阅读并同意'),
                          TextSpan(
                            text: '《用户协议》',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = controller.openUserAgreement,
                          ),
                          const TextSpan(text: '和'),
                          TextSpan(
                            text: '《隐私政策》',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = controller.openPrivacyPolicy,
                          ),
                        ],
                      ),
                      style: TextStyle(
                        textBaseline: TextBaseline.alphabetic,
                        color: theme.colorScheme.onSurface,
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
