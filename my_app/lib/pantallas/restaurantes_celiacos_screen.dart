import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/pantallas/IniciarSesionScreen.dart';
import 'package:my_app/pantallas/configuracion_screen.dart';
import 'package:my_app/pantallas/contacto_screen.dart';
import 'package:my_app/pantallas/restaurant_detail_screen.dart';
import 'package:my_app/pantallas/sobre_nosotros_screen.dart';

class Restaurant {
  final String name;
  final String address;
  final String phoneNumber;
  final String image;

  Restaurant(this.name, this.address, this.phoneNumber, this.image);
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

class RestaurantesCeliacosScreen extends StatefulWidget {
  const RestaurantesCeliacosScreen({super.key});

  @override
  State<RestaurantesCeliacosScreen> createState() =>
      _RestaurantesCeliacosScreenState();
}

class _RestaurantesCeliacosScreenState
    extends State<RestaurantesCeliacosScreen> with TickerProviderStateMixin {
  final List<Restaurant> _allRestaurants = [
    Restaurant('CeliFood', '123 Calle Principal', '+1 123 456 789',
        'assets/images/Imagen1.jpeg'),
    Restaurant('G-Free Paradise', '456 Avenida Central', '+1 987 654 321',
        'assets/images/Imagen2.jpeg'),
    Restaurant('Healthy Eats', '789 Calle Secundaria', '+1 555 123 456',
        'assets/images/Imagen3.jpeg'),
    Restaurant('Green Plate', '321 Carretera Principal', '+1 333 444 555',
        'assets/images/Imagen4.jpeg'),
  ];

  late List<Restaurant> _filteredRestaurants;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _filteredRestaurants = _allRestaurants;
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _particles = List.generate(50, (_) => Particle());
    _controller.addListener(() {
      setState(() {
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurantes Celiacos',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              size: 30,
            ),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.lightGreen,
                      Colors.green,
                      Colors.teal,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
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
              );
            },
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterRestaurants,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar restaurantes celiacos',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: _filteredRestaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = _filteredRestaurants[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RestaurantDetailScreen(restaurant: restaurant),
                          ),
                        );
                      },
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 8,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              restaurant.image,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                restaurant.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black,
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _filterRestaurants(String query) {
    setState(() {
      _filteredRestaurants = _allRestaurants
          .where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showPopupMenu(BuildContext context) {
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(Offset.zero),
          overlay.localToGlobal(Offset(overlay.size.width, overlay.size.height)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: '/sobre_nosotros',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SobreNosotrosScreen()),
            );
          },
          child: const Text(
            'Sobre nosotros',
            style: TextStyle(fontSize: 18),
          ),
        ),
        PopupMenuItem(
          value: '/contacto',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactoScreen()),
            );
          },
          child: const Text(
            'Contacto',
            style: TextStyle(fontSize: 18),
          ),
        ),
        PopupMenuItem(
          value: '/configuracion',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ConfiguracionScreen()),
            );
          },
          child: const Text(
            'Configuración',
            style: TextStyle(fontSize: 18),
          ),
        ),
        PopupMenuItem(
          value: '/registro',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const IniciarSesionScreen()),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 10),
              Text(
                'Registrarse/Iniciar sesión',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }
}