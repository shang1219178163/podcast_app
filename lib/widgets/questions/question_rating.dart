import 'package:flutter/material.dart';

class RatingOption {
  final String text;
  final int value;

  const RatingOption(this.text, this.value);
}

class QuestionRating extends StatefulWidget {
  final List<RatingOption> options;
  final int? initialValue;
  final ValueChanged<int>? onChanged;
  final String? tip;

  const QuestionRating({
    super.key,
    required this.options,
    this.initialValue,
    this.onChanged,
    this.tip,
  });

  @override
  State<QuestionRating> createState() => _QuestionRatingState();
}

class _QuestionRatingState extends State<QuestionRating> {
  int? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.options
          .map((option) => _buildRatingOption(option))
          .toList(),
    );
  }

  Widget _buildRatingOption(RatingOption option) {
    final isSelected = _selectedValue == option.value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = option.value;
        });
        widget.onChanged?.call(option.value);
      },
      child: Column(
        children: [
          Icon(
            Icons.star,
            color: isSelected ? Colors.amber : Colors.grey[300],
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            option.text,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.amber : Colors.grey[600],
            ),
          ),
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
      ),
    );
  }
} 