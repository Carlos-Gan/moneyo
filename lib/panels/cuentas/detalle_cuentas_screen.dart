import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/panels/cuentas/cuenta_edit.dart';

class DetalleCuentaScreen extends StatefulWidget {
  final Cuenta cuenta;
  const DetalleCuentaScreen({super.key, required this.cuenta});

  @override
  State<DetalleCuentaScreen> createState() => _DetalleCuentaScreen();
}

class _DetalleCuentaScreen extends State<DetalleCuentaScreen> {
  late Cuenta cuenta; // Se podrá actualizar

  @override
  void initState() {
    super.initState();
    cuenta = widget.cuenta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de ${cuenta.nombre}"),
        actions: [
          PopupMenuButton<String>(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.tertiary,
            onSelected: (value) {
              switch (value) {
                case "agregar":
                  // Navegar a pantalla de agregar transacción
                  break;
                case "modificar":
                  _modificarTarjeta(context);
                  break;
                case 'borrar':
                  _borrarTarjeta(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'agregar',
                child: Text('Agregar Transacción'),
              ),
              const PopupMenuItem(
                value: 'modificar',
                child: Text('Modificar Cuenta'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'borrar',
                child: Text('Borrar Cuenta'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            //Nombre de la tarjeta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre de la cuenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(cuenta.nombre, style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            //Numero de tarjeta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Numero de tarjeta label
                const Text(
                  'Tipo de cuenta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                //Numero de tarjeta dinamico
                Text(
                  cuenta.tipo,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 10),
            //Fecha de vencimiento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Saldo',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  cuenta.saldo.toString(),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              'Ultimas transacciones',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
      
            //Ultimas transacciones
          ],
        ),
      ),
    );
  }

  void _modificarTarjeta(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CuentaEdit(cuenta: cuenta)),
    );

    if (result == true) {
      // Volvemos a consultar la tarjeta actualizada de la BD
      final cuentas = await OperacionesBD.obtenerCuentas();
      final updated = cuentas.firstWhere((t) => t.id == cuenta.id);

      setState(() {
        cuenta = updated;
      });

      // Propagar cambio a HomeCards
      Navigator.pop(context, true);
    }
  }

  void _borrarTarjeta(BuildContext context) async {
    final confirmacion = await showAdaptiveDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: Text('Confirmar eliminacion'),
        content: Text("¿Seguro que deseas borrar la cuenta ${cuenta.nombre}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancelar"),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.red.shade800),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Borrar"),
          ),
        ],
      ),
    );
    if (confirmacion == true) {
      await OperacionesBD.eliminarCuenta(cuenta.id!);
      //Regresar Notificando cambios
      if (mounted) {
        IconSnackBar.show(
          context,
          label: "Cuenta borrada con exito",
          snackBarType: SnackBarType.success,
        );
        Navigator.pop(context, true);
      }
    }
  }
}
