import 'package:flutter/material.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contacto',
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
      body: const ParticlesBackground( 
        child: _ContactContent(),
      ),
    );
  }
}

class _ContactContent extends StatelessWidget {
  const _ContactContent({Key? key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlueAccent, Colors.blueAccent],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '¡Gracias por usar nuestra aplicación Restaurantes Celiacos!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ponte en contacto con nosotros si tienes alguna pregunta, sugerencia o problema:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, 
              ),
            ),
            const SizedBox(height: 20),
            _buildContactItem(context, Icons.email, 'Correo electrónico',
                'info@restaurantesceliacos.com'),
            const SizedBox(height: 10),
            _buildContactItem(
                context, Icons.phone, 'Teléfono', '+34 123 456 789'),
            const SizedBox(height: 10),
            _buildContactItem(context, Icons.location_on, 'Dirección',
                'Calle Ficticia, 123, Ciudad Ficticia'),
            const SizedBox(height: 20),
            const Text(
              '¡Esperamos poder ayudarte!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, IconData icon, String title, String content) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white, 
          size: 30,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white, 
              ),
            ),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ParticlesBackground extends StatefulWidget {
  final Widget child;

  const ParticlesBackground({required this.child, Key? key}) : super(key: key);

  @override
  _ParticlesBackgroundState createState() => _ParticlesBackgroundState();
}

class _ParticlesBackgroundState extends State<ParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        widget.child,
      ],
    );
  }
}
