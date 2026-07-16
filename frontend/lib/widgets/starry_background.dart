import 'dart:math' show sin, pi, Random;
import 'package:flutter/material.dart';

class StarryBackground extends StatefulWidget {
  final Widget child;

  const StarryBackground({super.key, required this.child});

  @override
  State<StarryBackground> createState() => _StarryBackgroundState();
}

class _StarryBackgroundState extends State<StarryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Star> _stars = [];
  final _random = Random(42);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 40; i++) {
      _stars.add(_Star(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: 1.0 + _random.nextDouble() * 2.5,
        opacity: 0.2 + _random.nextDouble() * 0.5,
        speed: 0.5 + _random.nextDouble() * 2.0,
      ));
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (!isDark) return widget.child;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0B1026),
            Color(0xFF1B2A4A),
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size.infinite,
                painter: _StarPainter(stars: _stars, controller: _controller),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double speed;

  _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.speed,
  });
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final Animation<double> controller;

  _StarPainter({required this.stars, required this.controller});

  @override
  void paint(Canvas canvas, Size size) {
    final now = controller.value;
    for (final star in stars) {
      final twinkle = 0.5 + 0.5 * sin((now * star.speed * 2 * pi) + star.x * 10);
      final paint = Paint()
        ..color = Colors.white.withOpacity(star.opacity * twinkle)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}


