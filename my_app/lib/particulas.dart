import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ParticlesBackground extends StatefulWidget {
  final Widget child;

  const ParticlesBackground({required this.child, super.key});

  @override
  _ParticlesBackgroundState createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<ParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _particles = List.generate(50, (_) => Particle());
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateParticles();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); 
    super.dispose();
  }

  void _updateParticles() {
    setState(() {
      for (var particle in _particles) {
        particle.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                    Colors.lightBlueAccent,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    _controller.value,
                    _controller.value + 0.5,
                    _controller.value + 1.0,
                  ].map((stop) => stop % 1.0).toList(),
                ),
              ),
            );
          },
        ),
        Stack(
          children: _particles
              .map((particle) => Positioned(
                    left: particle.x,
                    top: particle.y,
                    child: Container(
                      width: particle.size,
                      height: particle.size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(particle.opacity),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ))
              .toList(),
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late double opacity;
  late double speed;

  Particle() {
    final random = Random();
    x = random.nextDouble() * 500;
    y = random.nextDouble() * 500;
    size = random.nextDouble() * 10;
    opacity = random.nextDouble();
    speed = random.nextDouble() * 0.5;
  }

  void update() {
    x += speed;
    if (x > 500) {
      x = 0;
    }
  }
}
