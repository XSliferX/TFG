import 'dart:async';
import 'package:flutter/material.dart';

class SobreNosotrosScreen extends StatefulWidget {
  const SobreNosotrosScreen({Key? key});

  @override
  _SobreNosotrosScreenState createState() => _SobreNosotrosScreenState();
}

class _SobreNosotrosScreenState extends State<SobreNosotrosScreen> {
  late Timer _timer;
  late Color _startColor;
  late Color _endColor;
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _startColor = Colors.blueAccent;
    _endColor = Colors.lightBlueAccent;
    _currentColor = _startColor;
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _animateColor();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _animateColor() {
    setState(() {
      _currentColor = _currentColor == _startColor ? _endColor : _startColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sobre nosotros',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0, 
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [_currentColor, _currentColor.withOpacity(0.8)],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                const SizedBox(height: 20), 
                const Text(
                  'Descubre más sobre nosotros',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16), 
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Somos un equipo dedicado a ofrecerte la mejor experiencia gastronómica, especializados en restaurantes celiacos. Nuestra misión es proporcionar opciones deliciosas y seguras para todos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), 
                    child: Text(
                      'Conoce más',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
