import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/extras/extras.dart';

class CuentaEdit extends StatefulWidget {
  final Cuenta cuenta;
  const CuentaEdit({super.key, required this.cuenta});

  @override
  State<CuentaEdit> createState() => _CuentaEditState();
}

class _CuentaEditState extends State<CuentaEdit> {
  //Controladores
  late TextEditingController nombreController;
  late TextEditingController tipoController;

  @override
  void initState() {
    //Inicializar controlador de el nombre de la cuenta
    nombreController = TextEditingController(text: widget.cuenta.nombre);
    //Inicializar controlador de el tipo de cuenta
    tipoController = TextEditingController(text: widget.cuenta.tipo);
    super.initState();
  }

  //Inicializar color de la cuenta antes seleccionado
  late Color cuentaColor = Color(widget.cuenta.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Modificacion de ${widget.cuenta.nombre}")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            //Nombre
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Nombre de la Tarjeta',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.lightText, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tipo de cuenta
            DropdownButtonFormField<String>(
              dropdownColor: Theme.of(context).colorScheme.onTertiary,
              initialValue: widget.cuenta.tipo,
              items: AccountTypes.tipos
                  .map(
                    (tipo) => DropdownMenuItem(value: tipo, child: Text(tipo)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  widget.cuenta.tipo = value!;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelText: 'Tipo de cuenta',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.lightText, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Selección de color
            ListTile(
              title: const Text('Color de la cuenta'),
              trailing: ColorIndicator(
                width: 40,
                height: 40,
                borderRadius: 8,
                color: cuentaColor,
                onSelect: () async {
                  final Color newColor = await showColorPickerDialog(
                    context,
                    cuentaColor,
                    title: const Text('Selecciona un color'),
                    pickersEnabled: const {
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                      ColorPickerType.wheel: true,
                      ColorPickerType.custom: true,
                    },
                  );
                  setState(() {
                    cuentaColor = newColor;
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final cuenta = Cuenta(
                  id: widget.cuenta.id,
                  nombre: nombreController.text,
                  tipo: widget.cuenta.tipo,
                  color: cuentaColor.value32bit,
                  saldo: widget.cuenta.saldo,
                );
                OperacionesBD.actualizarCuenta(cuenta);
                IconSnackBar.show(
                  context,
                  snackBarType: SnackBarType.success,
                  label: 'Cuenta modificada correctamente',
                );
                Navigator.pop(context, true);
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : AppColors.lightText,
                ),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
                padding: WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              child: Text("Modificar Cuenta"),
            ),
          ],
        ),
      ),
    );
  }
}
