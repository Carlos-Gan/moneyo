class Tarjeta {
  final String nombre;
  final String numeroTarjeta;
  final String? fechaCorte;
  final double saldo;
  final bool esCredito;
  final String? fechaLimite;
  final String fechaVencimiento;
  final int colorFondo;

  Tarjeta({
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
    nombre: json['nombre'],
    numeroTarjeta: json['numero'],
    fechaVencimiento: json['fechaVencimiento'],
    saldo: json['saldo'],
    esCredito: json['esCredito'] == 1,
    colorFondo: json['color'],
    fechaCorte: json['fechaCorte'],
    fechaLimite: json['fechaLimite'],
  );
}

class Cuenta {
  final String nombre;
  final double saldo;
  final String tipo;
  final int color;

  Cuenta({
    required this.nombre,
    required this.saldo,
    required this.tipo,
    required this.color,
  });

  factory Cuenta.fromMap(Map<String, dynamic> json) => Cuenta(
    nombre: json['nombre'],
    saldo: json['saldo'],
    tipo: json['tipo'],
    color: json['color'],
  );
}
