import 'package:flutter/material.dart';
import 'package:moneyo/extras/app_colors.dart';

class Cuentas extends StatelessWidget {
  final String nombre;
  final String tipo;
  final double saldo;
  final Color color;
  final double width;
  const Cuentas({
    super.key,
    required this.nombre,
    required this.tipo,
    required this.saldo,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: TextStyle(fontSize: 16, color: AppColors.lightText, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('· $tipo', style: TextStyle(fontSize: 18)),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Saldo Disponible', style: TextStyle(fontSize: 12)),
                SizedBox(height: 10),
                Text(
                  '\$ ${saldo.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
