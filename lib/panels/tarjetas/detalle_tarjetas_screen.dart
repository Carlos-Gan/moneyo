import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/panels/tarjetas/tarjeta_edit.dart';

class DetalleTarjetasScreen extends StatefulWidget {
  final Tarjeta tarjeta;
  const DetalleTarjetasScreen({super.key, required this.tarjeta});

  @override
  State<DetalleTarjetasScreen> createState() => _DetalleTarjetasScreenState();
}

class _DetalleTarjetasScreenState extends State<DetalleTarjetasScreen> {
  late Tarjeta tarjeta; // Se podrá actualizar

  @override
  void initState() {
    super.initState();
    tarjeta = widget.tarjeta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de ${tarjeta.nombre}"),
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
                child: Text('Modificar Tarjeta'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'borrar',
                child: Text('Borrar Tarjeta'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Banco: ${tarjeta.nombre}\n"
          "Número: ${tarjeta.numeroTarjeta}\n"
          "Saldo: ${tarjeta.saldo}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void _modificarTarjeta(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCards(tarjeta: tarjeta)),
    );

    if (result == true) {
      // Volvemos a consultar la tarjeta actualizada de la BD
      final tarjetas = await OperacionesBD.obtenerTarjetas();
      final updated = tarjetas.firstWhere((t) => t.id == tarjeta.id);

      setState(() {
        tarjeta = updated;
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
        content: Text(
          "¿Seguro que deseas borrar la tarjeta ${tarjeta.nombre}?",
        ),
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
      await OperacionesBD.eliminarTarjeta(tarjeta.id!);
      //Regresar Notificando cambios
      if (mounted) {
        IconSnackBar.show(
          context,
          label: "Tarjeta borrada con exito",
          snackBarType: SnackBarType.success,
        );
        Navigator.pop(context, true);
      }
    }
  }
}
