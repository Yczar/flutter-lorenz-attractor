import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class LorenzoPainter extends CustomPainter {
  LorenzoPainter({
    required this.positions,
  }) : _path = Path();
  final List<Vector3> positions;

  final Path _path;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromARGB(255, 100, 255, 255)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _path.moveTo(size.width / 2, size.height / 2);
    int hue = 1;
    for (int i = 1; i < positions.length - 1; ++i) {
      paint = paint..color = Color.fromARGB(255, hue, 255, 255);
      final p0 = positions[i - 1];
      var p1 = positions[i];
      hue = hue + 1;
      _path.quadraticBezierTo(p0.x, p0.y, p1.x, p1.y);
      _path.moveTo(p1.x, p1.y);
    }
    canvas.drawPath(_path, paint);
  }

  @override
  bool shouldRepaint(covariant LorenzoPainter oldDelegate) =>
      oldDelegate.positions.length != positions.length;
}
