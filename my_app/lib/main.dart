import 'package:flutter/material.dart';
import 'package:my_app/pantallas/restaurantes_celiacos_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Celiapp',
      theme: ThemeData(
        primaryColor: Colors.white70,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
        scaffoldBackgroundColor: Colors.white70, 
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white70,
          iconTheme: IconThemeData(
              color: Colors.black), 
        ),
      ),
      home: const RestaurantesCeliacosScreen(),
    );
  }
}

