import 'package:flutter/material.dart';
import 'package:app_login/db/database_helper.dart';
import 'package:app_login/models/usuario.dart';
import 'package:app_login/Pantallas/inicio.dart';
import 'package:app_login/Pantallas/registro.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      Usuario? usuario = await DatabaseHelper().getUsuario(
        _usuarioController.text,
        _contrasenaController.text,
      );
      if (usuario != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login exitoso')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InicioPage(usuario: usuario)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario o contraseña incorrectos')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFF6A4A), // Fondo de la pantalla
      //appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80% de la pantalla
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5), // Fondo blanco con opacidad para el efecto glass
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.5)), // Borde grisáceo
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ajusta el tamaño del Column
              children: [
                TextFormField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    labelText: 'Usuario',
                    filled: true,
                    fillColor: Colors.grey[200], // Fondo de campo de texto más oscuro
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      borderSide: BorderSide(color: Colors.grey, width: 2), // Contorno remarcado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2), // Contorno al enfocar
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre de usuario';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.grey[200], // Fondo de campo de texto más oscuro
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                      borderSide: BorderSide(color: Colors.grey, width: 2), // Contorno remarcado
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.blue, width: 2), // Contorno al enfocar
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistroPage()),
                    );
                  },
                  child: Text('¿No tienes una cuenta? Regístrate aquí'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
