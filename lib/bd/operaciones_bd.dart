import 'package:moneyo/bd/bd_helper.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:sqflite/sqflite.dart';

class OperacionesBD {
  // Guardar tarjeta de crédito
  static Future<void> guardarTarjetaCredito(Tarjeta tarjeta) async {
    final db = await BdHelper.database;
    await db.insert('tarjetas', {
      "nombre": tarjeta.nombre,
      "numero": tarjeta.numeroTarjeta,
      "fechaVencimiento": tarjeta.fechaVencimiento,
      "saldo": tarjeta.saldo,
      "esCredito": 1,
      "color": tarjeta.colorFondo,
      "fechaCorte": tarjeta.fechaCorte,
      "fechaLimite": tarjeta.fechaLimite,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Guardar tarjeta de débito
  static Future<void> guardarTarjetaDebito(Tarjeta tarjeta) async {
    final db = await BdHelper.database;
    await db.insert('tarjetas', {
      "nombre": tarjeta.nombre,
      "numero": tarjeta.numeroTarjeta,
      "fechaVencimiento": tarjeta.fechaVencimiento,
      "saldo": tarjeta.saldo,
      "esCredito": 0,
      "color": tarjeta.colorFondo,
      "fechaCorte": null,
      "fechaLimite": null,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Guardar cuenta (ahorro, efectivo o cripto)
  static Future<void> guardarCuenta(Cuenta cuenta) async {
    final db = await BdHelper.database;
    await db.insert('cuentas', {
      "nombre": cuenta.nombre,
      "saldo": cuenta.saldo,
      "tipo": cuenta.tipo,
      "color": cuenta.color,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Obtener todas las tarjetas
  static Future<List<Tarjeta>> obtenerTarjetas() async {
    final db = await BdHelper.database;
    final result = await db.query('tarjetas', orderBy: 'id DESC');
    return result.map((json) => Tarjeta.fromMap(json)).toList();
  }

  // Obtener todas las cuentas
  static Future<List<Cuenta>> obtenerCuentas() async {
    final db = await BdHelper.database;
    final result = await db.query('cuentas', orderBy: 'id DESC');
    return result.map((json) => Cuenta.fromMap(json)).toList();
  }

  // Actualizar tarjeta (crédito o débito)
  static Future<void> actualizarTarjeta(Tarjeta tarjeta) async {
    final db = await BdHelper.database;

    // Asegúrate de que la tarjeta tenga un id
    if (tarjeta.id == null) {
      throw Exception('La tarjeta no tiene ID y no se puede actualizar');
    }

    await db.update(
      'tarjetas',
      tarjeta.toMap(),
      where: 'id = ?',
      whereArgs: [tarjeta.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Actualizar cuenta (ahorro, efectivo o cripto)
  static Future<void> actualizarCuenta(Cuenta cuenta) async {
    final db = await BdHelper.database;

    if (cuenta.id == null) {
      throw Exception('La cuenta no tiene ID y no se puede actualizar');
    }

    await db.update(
      'cuentas',
      cuenta.toMap(),
      where: 'id = ?',
      whereArgs: [cuenta.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Eliminar tarjeta
  static Future<void> eliminarTarjeta(int id) async {
    final db = await BdHelper.database;
    await db.delete('tarjetas', where: 'id = ?', whereArgs: [id]);
  }

  // Eliminar cuenta
  static Future<void> eliminarCuenta(int id) async {
    final db = await BdHelper.database;
    await db.delete('cuentas', where: 'id = ?', whereArgs: [id]);
  }
}
