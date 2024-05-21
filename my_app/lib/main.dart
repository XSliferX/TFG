import 'package:flutter/material.dart';
import 'package:my_app/pantallas/restaurantes_celiacos_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurantes Celiacos',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, 
          iconTheme: IconThemeData(
              color: Colors.black), 
        ),
      ),
      home: const RestaurantesCeliacosScreen(),
    );
  }
}

