import 'package:flutter/material.dart' show AlertDialog, AppBar, BuildContext, Column, EdgeInsets, ElevatedButton, Icon, IconButton, Icons, InputDecoration, MainAxisAlignment, Navigator, Padding, Scaffold, ScaffoldMessenger, SizedBox, SnackBar, State, StatefulWidget, Text, TextButton, TextEditingController, TextField, Widget, showDialog;
import 'package:dio/dio.dart'; 
import 'dart:convert';

class RegistrarseScreen extends StatefulWidget {
  const RegistrarseScreen({super.key});

  @override
  _RegistrarseScreenState createState() => _RegistrarseScreenState();
}

class _RegistrarseScreenState extends State<RegistrarseScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _contrasenaController;
  bool _obscureText = true;
  late Dio _dio; 

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidoController = TextEditingController();
    _telefonoController = TextEditingController();
    _correoController = TextEditingController();
    _contrasenaController = TextEditingController();
    _dio = Dio();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _apellidoController,
              decoration: const InputDecoration(
                labelText: 'Apellido',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _telefonoController,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
              ),
            ),
            const SizedBox(height: 20),
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
                _registrarse();
              },
              child: const Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrarse() async {
    print('Iniciando registro...');

    final String nombre = _nombreController.text.trim();
    final String apellido = _apellidoController.text.trim();
    final String telefono = _telefonoController.text.trim();
    final String correo = _correoController.text.trim();
    final String contrasena = _contrasenaController.text.trim();

    if (nombre.isNotEmpty &&
        apellido.isNotEmpty &&
        telefono.isNotEmpty &&
        correo.isNotEmpty &&
        contrasena.isNotEmpty) {
      try {
        print('Enviando solicitud de registro al servidor...');

        final response = await _dio.post(
          'http://127.0.0.1:5000/registro',
          data: {
            'nombre': nombre,
            'apellido': apellido,
            'telefono': telefono,
            'correo': correo,
            'contrasena': contrasena,
          },
        );

        print('Respuesta del servidor recibida.');

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.data);
          final mensaje = responseData['mensaje'];
          _limpiarCampos(); 
          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(
              content: Text(mensaje),
              duration: const Duration(seconds: 3), 
            ),
          );
        } else {
          throw Exception('Error al registrar el usuario');
        }
      } catch (e) {
        print('Error durante la solicitud: $e');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text(
                  'Error de conexión. Por favor, inténtalo de nuevo más tarde.'),
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
      print('Campos obligatorios no completados.');

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

  void _limpiarCampos() {
    _nombreController.clear();
    _apellidoController.clear();
    _telefonoController.clear();
    _correoController.clear();
    _contrasenaController.clear();
  }
}
