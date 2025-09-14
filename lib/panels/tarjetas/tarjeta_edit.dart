import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/extras/extras.dart';
import 'package:moneyo/extras/month_day_picker.dart';

class EditCards extends StatefulWidget {
  final Tarjeta tarjeta;
  const EditCards({super.key, required this.tarjeta});

  @override
  State<EditCards> createState() => _EditCardsState();
}

class _EditCardsState extends State<EditCards> {
  // Controladores
  late TextEditingController bankController;
  late TextEditingController cardNumberController;
  late TextEditingController expiryController;
  late TextEditingController balanceController;
  late TextEditingController corteEditingController;
  late TextEditingController limiteEditingController;

  // Fechas seleccionadas para datepickers
  late int selectedMonth;
  late int selectedYear;
  late int selectedDayCorte;
  late int selectedDayLimite;
  late int selectedMonthCorte;
  late int selectedMonthLimite;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores con datos de la tarjeta
    bankController = TextEditingController(text: widget.tarjeta.nombre);
    cardNumberController = TextEditingController(
      text: widget.tarjeta.numeroTarjeta,
    );
    expiryController = TextEditingController(
      text: widget.tarjeta.fechaVencimiento,
    );

    // Formatear saldo con coma y dos decimales
    balanceController = TextEditingController(
      text: NumberFormat("#,##0.00", "en_US").format(widget.tarjeta.saldo),
    );

    // Solo si es tarjeta de crédito inicializamos corte y límite
    if (widget.tarjeta.esCredito) {
      corteEditingController = TextEditingController(
        text: widget.tarjeta.fechaCorte ?? '',
      );
      limiteEditingController = TextEditingController(
        text: widget.tarjeta.fechaLimite ?? '',
      );

      // Parsear fecha de corte si existe
      if (widget.tarjeta.fechaCorte != null &&
          widget.tarjeta.fechaCorte!.contains('/')) {
        final parts = widget.tarjeta.fechaCorte!.split('/');
        selectedDayCorte = int.tryParse(parts[0]) ?? DateTime.now().day;
        selectedMonthCorte = int.tryParse(parts[1]) ?? DateTime.now().month;
      } else {
        selectedDayCorte = DateTime.now().day;
        selectedMonthCorte = DateTime.now().month;
      }

      // Parsear fecha límite si existe
      if (widget.tarjeta.fechaLimite != null &&
          widget.tarjeta.fechaLimite!.contains('/')) {
        final parts = widget.tarjeta.fechaLimite!.split('/');
        selectedDayLimite = int.tryParse(parts[0]) ?? DateTime.now().day;
        selectedMonthLimite = int.tryParse(parts[1]) ?? DateTime.now().month;
      } else {
        selectedDayLimite = DateTime.now().day;
        selectedMonthLimite = DateTime.now().month;
      }
    } else {
      corteEditingController = TextEditingController();
      limiteEditingController = TextEditingController();
      selectedDayCorte = 0;
      selectedMonthCorte = 0;
      selectedDayLimite = 0;
      selectedMonthLimite = 0;
    }

    // Fecha de vencimiento
    if (widget.tarjeta.fechaVencimiento.contains('/')) {
      final parts = widget.tarjeta.fechaVencimiento.split('/');
      selectedMonth = int.tryParse(parts[0]) ?? DateTime.now().month;
      selectedYear = int.tryParse(parts[1]) ?? DateTime.now().year;
    } else {
      selectedMonth = DateTime.now().month;
      selectedYear = DateTime.now().year;
    }
  }

  double parseSaldo(String value) {
    // Quitar comas y espacios
    final cleaned = value.replaceAll(',', '').trim();
    // Intentar convertir
    return double.tryParse(cleaned) ?? 0.0;
  }

  String ocultarTarjeta(String numero) {
    if (numero.length <= 4) return numero; // Si tiene 4 o menos, no oculta nada
    final ultimos4 = numero.substring(numero.length - 4);
    final ocultos = '*' * (numero.length - 4);
    return '$ocultos$ultimos4';
  }

  late Color tarjetaColor = Color(widget.tarjeta.colorFondo);

  @override
  Widget build(BuildContext context) {
    bool isCreditCard = widget.tarjeta.esCredito;
    final label = isCreditCard ? 'Límite de Crédito' : 'Saldo';
    return Scaffold(
      appBar: AppBar(title: Text("Modificacion de ${widget.tarjeta.nombre}")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            //Nombre
            TextField(
              controller: bankController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de la Tarjeta',
              ),
            ),
            SizedBox(height: 20),
            //Numero de la tarjeta
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ValueListenableBuilder(
                  valueListenable: cardNumberController,
                  builder: (context, value, child) {
                    return Padding(
                      padding: EdgeInsetsGeometry.only(bottom: 8),
                      child: CardUtils.getCardLogoRow(
                        cardNumberController.text,
                      ),
                    );
                  },
                ),
                TextField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [CardNumberFormatter()],
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Número de Tarjeta',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            //Fecha de Vencimiento
            TextField(
              controller: expiryController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Fecha de Vencimiento (MM/AA)',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                CustomDatePickerBottomSheet.show(
                  context,
                  mode: DatePickerModes.monthYear,
                  initialMonth: selectedMonth,
                  initialYear: selectedYear,
                  onChanged: ({int? day, int? month, int? year}) {
                    setState(() {
                      selectedMonth = month ?? selectedMonth;
                      selectedYear = year ?? selectedYear;

                      // Actualiza el TextField con formato MM/AA
                      final monthStr = selectedMonth.toString().padLeft(2, '0');
                      final yearStr = (selectedYear % 100).toString().padLeft(
                        2,
                        '0',
                      );
                      expiryController.text = '$monthStr/$yearStr';
                    });
                  },
                );
              },
            ),
            SizedBox(height: 20),
            //Saldo
            TextField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyInputFormatter()],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: label,
              ),
            ),
            SizedBox(height: 20),
            //Seleccion de color
            ListTile(
              title: const Text('Color de fondo de la tarjeta'),
              trailing: ColorIndicator(
                width: 40,
                height: 40,
                borderRadius: 8,
                color: tarjetaColor,
                onSelect: () async {
                  final Color newColor = await showColorPickerDialog(
                    context,
                    tarjetaColor,
                    title: const Text('Selecciona un color'),
                    pickersEnabled: const {
                      ColorPickerType.primary: true,
                      ColorPickerType.accent: false,
                      ColorPickerType.wheel: true,
                      ColorPickerType.custom: true,
                    },
                  );
                  setState(() {
                    tarjetaColor = newColor;
                  });
                },
              ),
            ),
            if (isCreditCard) ...[
              SizedBox(height: 20),
              //Fecha de corte
              TextField(
                keyboardType: TextInputType.number,
                readOnly: true,
                controller: corteEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de Corte',
                ),
                onTap: () async {
                  CustomDatePickerBottomSheet.show(
                    context,
                    mode: DatePickerModes.monthDay,
                    initialMonth: selectedMonthCorte,
                    initialDay: selectedDayCorte,
                    onChanged: ({int? day, int? month, int? year}) {
                      setState(() {
                        selectedMonthCorte = month ?? selectedMonthCorte;
                        selectedDayCorte = day ?? selectedDayCorte;

                        // Actualiza el TextField con formato MM/AA
                        final dayStr = selectedDayCorte.toString().padLeft(
                          2,
                          '0',
                        );
                        final monthStr = selectedMonthCorte.toString().padLeft(
                          2,
                          '0',
                        );
                        corteEditingController.text = '$dayStr/$monthStr';
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              //Fecha limite
              TextField(
                keyboardType: TextInputType.number,
                readOnly: true,
                controller: limiteEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha Límite de Pago',
                ),
                onTap: () async {
                  CustomDatePickerBottomSheet.show(
                    context,
                    mode: DatePickerModes.monthDay,
                    initialMonth: selectedMonthLimite,
                    initialDay: selectedDayLimite,
                    onChanged: ({int? day, int? month, int? year}) {
                      setState(() {
                        selectedMonthLimite = month ?? selectedMonthLimite;
                        selectedDayLimite = day ?? selectedDayLimite;

                        final dayStr = selectedDayLimite.toString().padLeft(
                          2,
                          '0',
                        );
                        final monthStr = selectedMonthLimite.toString().padLeft(
                          2,
                          '0',
                        );
                        limiteEditingController.text = '$dayStr/$monthStr';
                      });
                    },
                  );
                },
              ),
            ],
            SizedBox(height: 20),
            //Guardar tarjetas boton
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : AppColors.lightText,
                ),
                foregroundColor: const WidgetStatePropertyAll(Colors.white),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              onPressed: () {
                // Validación general de campos obligatorios
                if (bankController.text.isEmpty ||
                    cardNumberController.text.isEmpty ||
                    expiryController.text.isEmpty ||
                    widget.tarjeta.id == null ||
                    (isCreditCard &&
                        (limiteEditingController.text.isEmpty ||
                            corteEditingController.text.isEmpty))) {
                  String mensaje = "";

                  if (bankController.text.isEmpty) {
                    mensaje = "Ingrese el nombre del banco";
                  } else if (cardNumberController.text.isEmpty) {
                    mensaje = "Ingrese el número de tarjeta";
                  } else if (expiryController.text.isEmpty) {
                    mensaje = "Seleccione la fecha de vencimiento";
                  } else if (isCreditCard &&
                      limiteEditingController.text.isEmpty) {
                    mensaje = "Ingrese el límite de crédito";
                  } else if (isCreditCard &&
                      corteEditingController.text.isEmpty) {
                    mensaje = "Ingrese la fecha de corte";
                  } else if (widget.tarjeta.id == null) {
                    mensaje = 'La tarjeta no tiene ID y no se puede actualizar';
                  }

                  IconSnackBar.show(
                    context,
                    label: mensaje,
                    snackBarType: SnackBarType.fail,
                  );
                  return; // Salir si falta algún dato
                }

                // Crear objeto tarjeta según tipo
                final tarjeta = Tarjeta(
                  id: widget.tarjeta.id,
                  nombre: bankController.text,
                  numeroTarjeta: cardNumberController.text,
                  fechaVencimiento: expiryController.text,
                  saldo: parseSaldo(balanceController.text),
                  esCredito: isCreditCard,
                  colorFondo: tarjetaColor.value32bit,
                  fechaCorte: isCreditCard ? corteEditingController.text : null,
                  fechaLimite: isCreditCard
                      ? limiteEditingController.text
                      : null,
                );

                print("Tarjeta actualizada");
                print(
                  "${tarjeta.nombre},${ocultarTarjeta(tarjeta.numeroTarjeta)}, ${tarjeta.fechaVencimiento}, ${tarjeta.saldo}",
                );

                OperacionesBD.actualizarTarjeta(tarjeta);
                IconSnackBar.show(
                  context,
                  label: "Tarjeta Actualizada",
                  snackBarType: SnackBarType.success,
                );

                Navigator.pop(
                  context,
                  true,
                ); // Cerrar el diálogo después de guardar
              },

              child: Text('Modificar Tarjeta'),
            ),
          ],
        ),
      ),
    );
  }
}
