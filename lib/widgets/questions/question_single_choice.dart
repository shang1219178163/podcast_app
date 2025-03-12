import 'package:flutter/material.dart';

class Choice {
  final String title;
  final String? subtitle;

  const Choice(this.title, [this.subtitle]);
}

class QuestionSingleChoice extends StatefulWidget {
  final List<Choice> choices;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? onSelect;
  final String? initialValue;
  final String? tip;

  const QuestionSingleChoice({
    Key? key,
    required this.choices,
    this.onChanged,
    this.onSelect,
    this.initialValue,
    this.tip,
  }) : super(key: key);

  @override
  State<QuestionSingleChoice> createState() => _QuestionSingleChoiceState();
}

class _QuestionSingleChoiceState extends State<QuestionSingleChoice> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(QuestionSingleChoice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedValue = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...widget.choices.map((choice) => _buildChoiceItem(context, choice)).toList(),
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

  Widget _buildChoiceItem(BuildContext context, Choice choice) {
    final isSelected = _selectedValue == choice.title;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = choice.title;
        });
        widget.onChanged?.call(choice.title!);
        widget.onSelect?.call(true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.transparent,
            width: isSelected ? 1 : 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                choice.title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? theme.primaryColor : Colors.black87,
                ),
              ),
            ),
            if (choice.subtitle != null)
              Text(
                choice.subtitle!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? theme.primaryColor : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
