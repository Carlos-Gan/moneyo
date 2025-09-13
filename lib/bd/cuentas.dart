class Cuenta {
  int? id;
  final String nombre;
  final double saldo;
  String tipo;
  final int color;

  Cuenta({
    this.id,
    required this.nombre,
    required this.saldo,
    required this.tipo,
    required this.color,
  });

  factory Cuenta.fromMap(Map<String, dynamic> json) => Cuenta(
    id: json['id'],
    nombre: json['nombre'],
    saldo: json['saldo'],
    tipo: json['tipo'],
    color: json['color'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'saldo': saldo,
    'tipo': tipo,
    'color': color,
  };
}
