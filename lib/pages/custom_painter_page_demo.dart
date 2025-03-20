import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomPainterPageDemo extends StatefulWidget {
  const CustomPainterPageDemo({super.key});

  @override
  State<CustomPainterPageDemo> createState() => _CustomPainterPageDemoState();
}

class _CustomPainterPageDemoState extends State<CustomPainterPageDemo> {
  double _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义绘制示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomPaint(
                painter: RoundedTrianglePainter(
                  radius: _radius,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _radius,
              min: 0,
              max: 50,
              divisions: 50,
              label: _radius.round().toString(),
              onChanged: (value) {
                setState(() {
                  _radius = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedTrianglePainter extends CustomPainter {
  final double radius;
  final Color color;

  RoundedTrianglePainter({
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // 计算三角形的尺寸
    final triangleHeight = size.height * 0.3;
    final triangleWidth = size.width * 0.2;

    // 计算三角形的中心点
    final triangleCenterX = size.width * 0.4;
    final triangleBottomY = size.height;

    // 计算圆角矩形的四个角点
    final topLeft = Offset(radius, radius);
    final topRight = Offset(size.width - radius, radius);
    final bottomLeft = Offset(radius, size.height - radius);
    final bottomRight = Offset(size.width - radius, size.height - radius);

    // 绘制圆角矩形
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);

    // 计算三角形与圆角矩形的交点
    final triangleLeftPoint = Offset(
      triangleCenterX - triangleWidth,
      triangleBottomY - triangleHeight,
    );
    final triangleRightPoint = Offset(
      triangleCenterX + triangleWidth,
      triangleBottomY - triangleHeight,
    );

    // 计算圆角与三角形的交点
    final leftIntersection = _calculateCircleLineIntersection(
      bottomLeft,
      radius,
      triangleLeftPoint,
      Offset(triangleCenterX, triangleBottomY),
    );
    final rightIntersection = _calculateCircleLineIntersection(
      bottomRight,
      radius,
      triangleRightPoint,
      Offset(triangleCenterX, triangleBottomY),
    );

    // 绘制三角形部分
    path.lineTo(leftIntersection.dx, leftIntersection.dy);
    path.lineTo(triangleCenterX, triangleBottomY - triangleHeight);
    path.lineTo(rightIntersection.dx, rightIntersection.dy);
    path.lineTo(size.width - radius, size.height);
    path.quadraticBezierTo(size.width - radius, size.height, size.width - radius, size.height - radius);
    path.lineTo(radius, size.height - radius);
    path.quadraticBezierTo(radius, size.height, radius, size.height - radius);
    path.close();

    canvas.drawPath(path, paint);
  }

  Offset _calculateCircleLineIntersection(
    Offset circleCenter,
    double radius,
    Offset lineStart,
    Offset lineEnd,
  ) {
    // 计算线段的方向向量
    final dx = lineEnd.dx - lineStart.dx;
    final dy = lineEnd.dy - lineStart.dy;
    final length = math.sqrt(dx * dx + dy * dy);

    // 单位向量
    final ux = dx / length;
    final uy = dy / length;

    // 计算从圆心到线段的垂直距离
    final t = (circleCenter.dx - lineStart.dx) * ux + (circleCenter.dy - lineStart.dy) * uy;

    // 计算垂足
    final projection = Offset(
      lineStart.dx + t * ux,
      lineStart.dy + t * uy,
    );

    // 计算圆心到垂足的距离
    final distance = math.sqrt(
      math.pow(circleCenter.dx - projection.dx, 2) + math.pow(circleCenter.dy - projection.dy, 2),
    );

    // 如果距离大于半径，返回线段的端点
    if (distance > radius) {
      return lineStart;
    }

    // 计算交点
    final h = math.sqrt(radius * radius - distance * distance);
    final intersection = Offset(
      projection.dx - h * uy,
      projection.dy + h * ux,
    );

    return intersection;
  }

  @override
  bool shouldRepaint(RoundedTrianglePainter oldDelegate) {
    return true;
    return oldDelegate.radius != radius || oldDelegate.color != color;
  }
}
