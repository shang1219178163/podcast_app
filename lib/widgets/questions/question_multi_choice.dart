import 'package:flutter/material.dart';

class QuestionMultiChoice extends StatefulWidget {
  final List<String> options;
  final List<String> initialValues;
  final ValueChanged<List<String>> onChanged;
  final String? tip;

  const QuestionMultiChoice({
    super.key,
    required this.options,
    required this.initialValues,
    required this.onChanged,
    this.tip,
  });

  @override
  State<QuestionMultiChoice> createState() => _QuestionMultiChoiceState();
}

class _QuestionMultiChoiceState extends State<QuestionMultiChoice> {
  late List<String> _selectedValues;

  @override
  void initState() {
    super.initState();
    _selectedValues = List.from(widget.initialValues);
  }

  @override
  void didUpdateWidget(QuestionMultiChoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != oldWidget.initialValues) {
      setState(() {
        _selectedValues = List.from(widget.initialValues);
      });
    }
  }

  void _toggleOption(String option) {
    setState(() {
      if (_selectedValues.contains(option)) {
        _selectedValues.remove(option);
      } else {
        _selectedValues.add(option);
      }
      widget.onChanged(_selectedValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.options.map((option) => _buildOptionItem(context, option)).toList(),
        if (widget.tip != null)
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
                    widget.tip!,
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

  Widget _buildOptionItem(BuildContext context, String option) {
    final isSelected = _selectedValues.contains(option);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _toggleOption(option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: isSelected ? 1 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? theme.primaryColor : Colors.black87,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? theme.primaryColor : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
