class Tarjeta {
  int? id;
  final String nombre;
  final String numeroTarjeta;
  final String? fechaCorte;
  final double saldo;
  final bool esCredito;
  final String? fechaLimite;
  final String fechaVencimiento;
  final int colorFondo;

  Tarjeta({
    this.id,
    required this.nombre,
    required this.numeroTarjeta,
    this.fechaCorte,
    required this.saldo,
    required this.esCredito,
    this.fechaLimite,
    required this.fechaVencimiento,
    required this.colorFondo,
  });

  factory Tarjeta.fromMap(Map<String, dynamic> json) => Tarjeta(
    id: json['id'],
    nombre: json['nombre'],
    numeroTarjeta: json['numero'],
    fechaVencimiento: json['fechaVencimiento'],
    saldo: json['saldo'],
    esCredito: json['esCredito'] == 1,
    colorFondo: json['color'],
    fechaCorte: json['fechaCorte'],
    fechaLimite: json['fechaLimite'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'numero': numeroTarjeta,
    'fechaVencimiento': fechaVencimiento,
    'saldo': saldo,
    'esCredito': esCredito ? 1 : 0,
    'color': colorFondo,
    'fechaCorte': fechaCorte,
    'fechaLimite': fechaLimite,
  };
}