import 'package:flutter/material.dart' show AlertDialog, AppBar, BuildContext, Column, EdgeInsets, ElevatedButton, Icon, IconButton, Icons, InputDecoration, MainAxisAlignment, MaterialPageRoute, Navigator, Padding, Scaffold, SizedBox, State, StatefulWidget, Text, TextButton, TextEditingController, TextField, Widget, showDialog;
import 'package:dio/dio.dart'; 
import 'dart:convert';
import 'package:my_app/pantallas/RegistrarseScreen.dart';

class IniciarSesionScreen extends StatefulWidget {
  const IniciarSesionScreen({super.key});

  @override
  _IniciarSesionScreenState createState() => _IniciarSesionScreenState();
}

class _IniciarSesionScreenState extends State<IniciarSesionScreen> {
  late TextEditingController _correoController;
  late TextEditingController _contrasenaController;
  bool _obscureText = true;
  late Dio _dio; 

  @override
  void initState() {
    super.initState();
    _correoController = TextEditingController();
    _contrasenaController = TextEditingController();
    _dio = Dio(); 
  }

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contrasenaController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _iniciarSesion();
              },
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrarseScreen()),
                );
              },
              child: const Text('¿No tienes una cuenta? Regístrate'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _iniciarSesion() async {
    final String correo = _correoController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    if (correo.isNotEmpty && contrasena.isNotEmpty) {
      try {
        final response = await _dio.post(
          'http://127.0.0.1:5000/inicio_sesion',
          data: {'correo': correo, 'contrasena': contrasena},
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.data);
          final mensaje = responseData['mensaje'];
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Mensaje'),
                content: Text(mensaje),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          throw Exception('Credenciales inválidas.');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Error de conexión. Por favor, inténtalo de nuevo más tarde.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Todos los campos son obligatorios.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
