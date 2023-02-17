import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorenz_attractor/painter/lorenzo_painter.dart';

import 'package:vector_math/vector_math_64.dart' hide Colors;

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ValueNotifier<List<Vector3>> _positionsNotifier;
  Timer? _timer;

  /// constansts
  double x = 0.01;
  double y = 0;
  double z = 0;

  //
  double a = 10;
  double b = 28;
  double c = 8 / 3;
  @override
  void initState() {
    super.initState();
    _positionsNotifier = ValueNotifier([]);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initiazlize();
    });
  }

  void _initiazlize() {
    _timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      _calculateUsingLorenzoFML();
    });
  }

  void _calculateUsingLorenzoFML() {
    double dt = 0.01;
    double dx = (a * (y - x)) * dt;
    double dy = (x * (b - z) - y) * dt;
    double dz = (x * y - c * z) * dt;
    x = x + dx;
    y = y + dy;
    z = z + dz;
    final currentPos = Vector3(x, y, z);
    _positionsNotifier.value = [
      ..._positionsNotifier.value,
      currentPos,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()..setEntry(3, 2, 0.001),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: _positionsNotifier,
              builder: (_, positions, __) {
                final lastVectorItem = positions.lastOrNull ?? Vector3.zero();
                return Transform.scale(
                  scale: 10,
                  child: Center(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateZ(lastVectorItem.z * (pi) / 180)
                        ..rotateY(lastVectorItem.y * (pi) / 180)
                        ..rotateX(lastVectorItem.x * (pi) / 180),
                      child: CustomPaint(
                        painter: LorenzoPainter(
                          positions: positions,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionsNotifier.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
