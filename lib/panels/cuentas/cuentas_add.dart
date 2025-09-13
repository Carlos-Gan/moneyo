// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/extras/extras.dart';
import 'package:moneyo/extras/month_day_picker.dart';
import 'package:moneyo/bd/operaciones_bd.dart';

class AddAccounts extends StatefulWidget {
  const AddAccounts({super.key});

  @override
  State<AddAccounts> createState() => _AddAccountsState();
}

class _AddAccountsState extends State<AddAccounts> {
  // Controladores para los campos de texto
  final TextEditingController bankController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController corteEditingController = TextEditingController();
  final TextEditingController limiteEditingController = TextEditingController();

  // Variables dentro de _AddAccountsState
  Color accountColor = Colors.green; // Color por defecto
  String selectedType = 'Ahorro'; // Tipo de cuenta por defecto
  final TextEditingController nameControllerCuenta = TextEditingController();
  final TextEditingController balanceControllerCuenta = TextEditingController();

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  int selectedDayCorte = DateTime.now().day;
  int selectedDayLimite = DateTime.now().day;

  int selectedMonthCorte = DateTime.now().month;
  int selectedMonthLimite = DateTime.now().month;

  Color tarjetaColor = Colors.blue;

  @override
  void dispose() {
    bankController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  bool isCreditCard = false;

  String ocultarTarjeta(String numero) {
    if (numero.length <= 4) return numero; // Si tiene 4 o menos, no oculta nada
    final ultimos4 = numero.substring(numero.length - 4);
    final ocultos = '*' * (numero.length - 4);
    return '$ocultos$ultimos4';
  }

  double parseSaldo(String value) {
    // Quitar comas y espacios
    final cleaned = value.replaceAll(',', '').trim();
    // Intentar convertir
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final label = isCreditCard ? 'Límite de Crédito' : 'Saldo';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Agregar Cuenta'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Tarjetas'),
              Tab(text: 'Cuentas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Agregar Tarjeta de Crédito/Débito'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 15.0,
                      ),
                      child: Column(
                        children: [
                          // Nombre del banco
                          TextField(
                            controller: bankController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nombre del Banco',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Número de tarjeta
                          TextField(
                            controller: cardNumberController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [CardNumberFormatter()],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Número de Tarjeta',
                              prefixIcon: ValueListenableBuilder(
                                valueListenable: cardNumberController,
                                builder: (context, value, child) {
                                  final cardNumber = cardNumberController.text;
                                  if (cardNumber.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 10.0,
                                    ),
                                    child: CardUtils.getCardLogo(cardNumber),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Fecha de vencimiento
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
                                    final monthStr = selectedMonth
                                        .toString()
                                        .padLeft(2, '0');
                                    final yearStr = (selectedYear % 100)
                                        .toString()
                                        .padLeft(2, '0');
                                    expiryController.text =
                                        '$monthStr/$yearStr';
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),

                          // Saldo
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
                                final Color newColor =
                                    await showColorPickerDialog(
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

                          SizedBox(height: 20),
                          // Tipo de tarjeta
                          Row(
                            children: [
                              Text(
                                'Tipo de Tarjeta:',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 20),
                              Switch(
                                value: isCreditCard,
                                activeThumbColor: AppColors.lightText,
                                onChanged: (value) {
                                  setState(() {
                                    isCreditCard = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Campos adicionales para tarjetas de crédito
                          if (isCreditCard) ...[
                            //Fecha corte
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
                                      selectedMonthCorte =
                                          month ?? selectedMonthCorte;
                                      selectedDayCorte =
                                          day ?? selectedDayCorte;

                                      // Actualiza el TextField con formato MM/AA
                                      final dayStr = selectedDayCorte
                                          .toString()
                                          .padLeft(2, '0');
                                      final monthStr = selectedMonthCorte
                                          .toString()
                                          .padLeft(2, '0');
                                      corteEditingController.text =
                                          '$dayStr/$monthStr';
                                    });
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            //Limite de pago
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
                                      selectedMonthLimite =
                                          month ?? selectedMonthLimite;
                                      selectedDayLimite =
                                          day ?? selectedDayLimite;

                                      // Actualiza el TextField con formato MM/AA
                                      final dayStr = selectedDayLimite
                                          .toString()
                                          .padLeft(2, '0');
                                      final monthStr = selectedMonthLimite
                                          .toString()
                                          .padLeft(2, '0');
                                      limiteEditingController.text =
                                          '$dayStr/$monthStr';
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Guardar tarjetas boton
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : AppColors.lightText,
                        ),
                        foregroundColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                      onPressed: () {
                        // Validación general de campos obligatorios
                        if (bankController.text.isEmpty ||
                            cardNumberController.text.isEmpty ||
                            expiryController.text.isEmpty ||
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
                          nombre: bankController.text,
                          numeroTarjeta: cardNumberController.text,
                          fechaVencimiento: expiryController.text,
                          saldo: parseSaldo(balanceController.text),
                          esCredito: isCreditCard,
                          colorFondo: tarjetaColor.value32bit,
                          fechaCorte: isCreditCard
                              ? corteEditingController.text
                              : null,
                          fechaLimite: isCreditCard
                              ? limiteEditingController.text
                              : null,
                        );

                        // Guardar en la base de datos según tipo
                        if (isCreditCard) {
                          OperacionesBD.guardarTarjetaCredito(tarjeta);
                        } else {
                          print("Tarjeta guardada");
                          print(
                            "${tarjeta.nombre},${ocultarTarjeta(tarjeta.numeroTarjeta)}, ${tarjeta.fechaVencimiento}, ${tarjeta.saldo}",
                          );
                          OperacionesBD.guardarTarjetaDebito(tarjeta);
                          IconSnackBar.show(
                            context,
                            label: "Tarjeta guardada",
                            snackBarType: SnackBarType.success,
                          );
                        }

                        Navigator.pop(
                          context,
                        ); // Cerrar el diálogo después de guardar
                      },

                      child: Text('Agregar Tarjeta'),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Nombre de la cuenta
                    TextField(
                      controller: nameControllerCuenta,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Nombre de la cuenta',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.lightText,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Saldo inicial
                    TextField(
                      controller: balanceControllerCuenta,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Saldo inicial',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.lightText,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tipo de cuenta
                    DropdownButtonFormField<String>(
                      dropdownColor: Theme.of(context).colorScheme.onTertiary,
                      initialValue: selectedType,
                      items: AccountTypes.tipos
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelText: 'Tipo de cuenta',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.lightText,
                            width: 2,
                          ),
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
                        color: accountColor,
                        onSelect: () async {
                          final Color newColor = await showColorPickerDialog(
                            context,
                            accountColor,
                            title: const Text('Selecciona un color'),
                            pickersEnabled: const {
                              ColorPickerType.primary: true,
                              ColorPickerType.accent: false,
                              ColorPickerType.wheel: true,
                              ColorPickerType.custom: true,
                            },
                          );
                          setState(() {
                            accountColor = newColor;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Botón Guardar
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[800]
                              : AppColors.lightText,
                        ),
                        foregroundColor: const WidgetStatePropertyAll(
                          Colors.white,
                        ),
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                      onPressed: () {
                        if (nameControllerCuenta.text.isEmpty ||
                            balanceControllerCuenta.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Ingrese todos los datos de la cuenta',
                              ),
                            ),
                          );
                          return;
                        }

                        // Crear objeto cuenta
                        final account = Cuenta(
                          nombre: nameControllerCuenta.text,
                          saldo:
                              double.tryParse(balanceControllerCuenta.text) ??
                              0.0,
                          tipo: selectedType,
                          color: accountColor.value,
                        );

                        // Guardar en base de datos
                        OperacionesBD.guardarCuenta(account);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cuenta guardada correctamente'),
                          ),
                        );

                        Navigator.pop(context); // Cerrar pantalla
                      },
                      child: const Text('Agregar Cuenta'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
