import 'package:flutter/material.dart';

class AudioVisualizer extends StatefulWidget {
  final List<double> data;
  final double width;
  final double height;
  final Color color;
  final double barWidth;
  final double spacing;
  final bool isPlaying;

  const AudioVisualizer({
    Key? key,
    required this.data,
    this.width = 200,
    this.height = 60,
    this.color = Colors.blue,
    this.barWidth = 3,
    this.spacing = 2,
    this.isPlaying = true,
  }) : super(key: key);

  @override
  State<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.width, widget.height),
            painter: AudioVisualizerPainter(
              data: widget.data,
              color: widget.color,
              barWidth: widget.barWidth,
              spacing: widget.spacing,
              animation: _animation.value,
              isPlaying: widget.isPlaying,
            ),
          );
        },
      ),
    );
  }
}

class AudioVisualizerPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double barWidth;
  final double spacing;
  final double animation;
  final bool isPlaying;

  const AudioVisualizerPainter({
    required this.data,
    required this.color,
    required this.barWidth,
    required this.spacing,
    required this.animation,
    required this.isPlaying,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final totalBars = data.length;
    final totalWidth = (barWidth + spacing) * totalBars - spacing;
    final startX = (size.width - totalWidth) / 2;

    for (var i = 0; i < totalBars; i++) {
      final x = startX + i * (barWidth + spacing);
      final amplitude = data[i] * animation;
      final barHeight = amplitude * size.height;

      // 绘制上半部分
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          centerY - barHeight / 2,
          barWidth,
          barHeight / 2,
        ),
        paint,
      );

      // 绘制下半部分
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          centerY,
          barWidth,
          barHeight / 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AudioVisualizerPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.barWidth != barWidth ||
        oldDelegate.spacing != spacing ||
        oldDelegate.animation != animation ||
        oldDelegate.isPlaying != isPlaying;
  }
}
