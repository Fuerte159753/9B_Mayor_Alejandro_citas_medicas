import 'package:flutter/material.dart';
import 'package:app_login/db/database_helper.dart';
import 'package:app_login/models/citas.dart';

class EditarCitaPage extends StatefulWidget {
  final Cita cita;

  EditarCitaPage({required this.cita});

  @override
  _EditarCitaPageState createState() => _EditarCitaPageState();
}

class _EditarCitaPageState extends State<EditarCitaPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fechaController;
  late TextEditingController _razonController;
  String? _estado;

  @override
  void initState() {
    super.initState();
    _fechaController = TextEditingController(text: widget.cita.fecha);
    _razonController = TextEditingController(text: widget.cita.razon);
    _estado = widget.cita.estado;
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _razonController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
    if (_formKey.currentState!.validate()) {
      Cita citaActualizada = Cita(
        id: widget.cita.id,
        fecha: _fechaController.text,
        razon: _razonController.text,
        idUsuario: widget.cita.idUsuario,
        estado: _estado!,
      );
      await DatabaseHelper().updateCita(citaActualizada);
      Navigator.pop(context); // Regresa a la pantalla anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cita'),
      ),
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
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: InputDecoration(labelText: 'Estado'),
                items: ['Pendiente', 'Confirmada', 'Cancelada']
                    .map((estado) => DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _estado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarCambios,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}