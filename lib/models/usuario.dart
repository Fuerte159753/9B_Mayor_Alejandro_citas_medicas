class Usuario {
  final int? id;
  final String nombre;
  final String apellidoPaterno;
  final String usuario;
  final String contrasena;

  Usuario({
    this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.usuario,
    required this.contrasena,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidoPaterno': apellidoPaterno,
      'usuario': usuario,
      'contrasena': contrasena,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      apellidoPaterno: map['apellidoPaterno'],
      usuario: map['usuario'],
      contrasena: map['contrasena'],
    );
  }
}