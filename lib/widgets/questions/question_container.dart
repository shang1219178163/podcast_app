import 'package:flutter/material.dart';

class QuestionContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isRequired;

  const QuestionContainer({
    Key? key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isRequired)
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
