import 'package:flutter/material.dart';
import 'package:moneyo/extras/app_colors.dart';

class Cuentas extends StatelessWidget {
  final String nombre;
  final String numeroCuenta;
  final double saldo;
  const Cuentas({super.key, required this.nombre, required this.numeroCuenta, required this.saldo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.lightQuaternary,
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
                  style: TextStyle(fontSize: 16, color: AppColors.lightText),
                ),
                SizedBox(height: 10),
                Text('· $numeroCuenta', style: TextStyle(fontSize: 18)),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$ ${saldo.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Saldo Disponible', style: TextStyle(fontSize: 18)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
