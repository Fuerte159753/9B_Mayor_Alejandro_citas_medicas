class Cita {
  final int? id;
  final String fecha;
  final String razon;
  final int idUsuario;
  final String estado;

  Cita({
    this.id,
    required this.fecha,
    required this.razon,
    required this.idUsuario,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'razon': razon,
      'idUsuario': idUsuario,
      'estado': estado,
    };
  }

  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      id: map['id'],
      fecha: map['fecha'],
      razon: map['razon'],
      idUsuario: map['idUsuario'],
      estado: map['estado'],
    );
  }
}
