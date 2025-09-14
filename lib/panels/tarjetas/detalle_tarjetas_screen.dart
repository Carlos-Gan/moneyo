import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/extras/extras.dart';
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
                  'Nombre de la tarjeta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(tarjeta.nombre, style: TextStyle(fontSize: 20)),
              ],
            ),
            SizedBox(height: 10),
            //Numero de tarjeta
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Numero de tarjeta label
                const Text(
                  'Numero de la tarjeta',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                //Numero de tarjeta dinamico
                Row(
                  children: [
                    CardUtils.getCardLogoRow(tarjeta.numeroTarjeta, 45),
                    const SizedBox(width: 10),
                    Text(tarjeta.numeroTarjeta, style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            //Fecha de vencimiento
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fecha de Vencimiento',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  CardUtils.formatFechaVencimiento(tarjeta.fechaVencimiento),
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 10),
            //Si es credito
            if (tarjeta.esCredito) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Fecha de Corte
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha de Corte',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(tarjeta.fechaCorte!, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  //Fecha de Limite
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Fecha Limite',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        tarjeta.fechaLimite!,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            const Text(
              'Ultimas transacciones',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
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
