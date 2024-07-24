import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  // Importa intl para el formateo de fechas
import 'package:app_login/db/database_helper.dart';
import 'package:app_login/models/citas.dart';
import 'package:app_login/models/usuario.dart';
import 'package:app_login/pantallas/citas/newcita.dart';
import 'package:app_login/pantallas/citas/editarcita.dart';

class InicioPage extends StatefulWidget {
  final Usuario usuario;

  InicioPage({required this.usuario});

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late Future<List<Cita>> citas;

  @override
  void initState() {
    super.initState();
    citas = DatabaseHelper().getCitasByUsuario(widget.usuario.id!);
  }

  void _refreshCitas() {
    setState(() {
      citas = DatabaseHelper().getCitasByUsuario(widget.usuario.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Fecha actual: $fechaActual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cita>>(
              future: citas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay citas.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Cita cita = snapshot.data![index];
                    return ListTile(
                      title: Text('${cita.fecha} - ${cita.razon}'),
                      subtitle: Text('Estado: ${cita.estado}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditarCitaPage(cita: cita),
                                ),
                              ).then((_) => _refreshCitas());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await DatabaseHelper().deleteCita(cita.id!);
                              _refreshCitas();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewCitaPage(idUsuario: widget.usuario.id!)),
          ).then((_) => _refreshCitas());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
