import 'package:flutter/material.dart';
import 'package:app_login/db/database_helper.dart';
import 'package:app_login/models/citas.dart';

class NewCitaPage extends StatefulWidget {
  final int idUsuario;

  NewCitaPage({required this.idUsuario});

  @override
  _NewCitaPageState createState() => _NewCitaPageState();
}

class _NewCitaPageState extends State<NewCitaPage> {
  final _formKey = GlobalKey<FormState>();
  final _fechaController = TextEditingController();
  final _razonController = TextEditingController();
  final _estadoController = TextEditingController();

  Future<void> _agregarCita() async {
    if (_formKey.currentState!.validate()) {
      Cita cita = Cita(
        fecha: _fechaController.text,
        razon: _razonController.text,
        idUsuario: widget.idUsuario,
        estado: _estadoController.text,
      );
      await DatabaseHelper().insertCita(cita);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Cita')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _razonController,
                decoration: InputDecoration(labelText: 'Razón'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la razón';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _agregarCita,
                child: Text('Agregar Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
