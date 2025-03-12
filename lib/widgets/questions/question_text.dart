import 'package:flutter/material.dart';

class QuestionText extends StatelessWidget {
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? tip;

  const QuestionText({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: initialValue),
          onChanged: onChanged,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '请输入',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (tip != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: Colors.orange[700],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    tip!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
