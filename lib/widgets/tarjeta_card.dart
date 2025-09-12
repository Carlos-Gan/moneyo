import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/extras/extras.dart';

class TarjetasVisual extends StatelessWidget {
  final Color tarjetaColor;
  final String numeroTarjeta;
  final String bancoNombre;
  final double saldo;
  final String fechaVencimiento;
  final bool isCredito;
  final String fechaCorte;
  final String fechaLimitePago;

  TarjetasVisual({
    super.key,
    required this.tarjetaColor,
    required this.numeroTarjeta,
    required this.bancoNombre,
    required this.saldo,
    required this.fechaVencimiento,
    required this.isCredito,
    this.fechaCorte = '',
    this.fechaLimitePago = '',
  });

  final formatter = NumberFormat("#,##0.00", "en_US");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tarjetaColor,
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CardUtils.getCardLogo(numeroTarjeta),
              const SizedBox(width: 8),
              Text(
                bancoNombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Número de tarjeta en el centro
          Text(
            numeroTarjeta,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          //Fechas de corte y pago para crédito
          if (isCredito) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Corte: $fechaCorte',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Pago: $fechaLimitePago',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          // Fecha y saldo abajo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vence: $fechaVencimiento',
                style: const TextStyle(fontSize: 12),
              ),

              Text(
                "\$${formatter.format(saldo)}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
