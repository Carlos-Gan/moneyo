import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/panels/home_cards.dart';
import 'package:moneyo/widgets/cuentas.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  final List<Map<String, dynamic>> cuentas = const [
    {'nombre': 'Nu Debito', 'numeroCuenta': '7890', 'saldo': 1500.75},
    {'nombre': 'Santander Debito', 'numeroCuenta': '4321', 'saldo': 250.00},
    {'nombre': 'BBVA Debito', 'numeroCuenta': '4455', 'saldo': 0.00},
    {'nombre': 'Banorte Debito', 'numeroCuenta': '1234', 'saldo': 3200.50},
    {'nombre': 'HSBC Debito', 'numeroCuenta': '5678', 'saldo': 780.20},
    {'nombre': 'Citibanamex Debito', 'numeroCuenta': '9101', 'saldo': 450.00},
    {'nombre': 'Inbursa Debito', 'numeroCuenta': '1122', 'saldo': 600.00},
    {'nombre': 'Scotiabank Debito', 'numeroCuenta': '3344', 'saldo': 1200.00},
    {'nombre': 'BanCoppel Debito', 'numeroCuenta': '5566', 'saldo': 300.00},
    {'nombre': 'Banco Azteca Debito', 'numeroCuenta': '7788', 'saldo': 950.00},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Text(
          'Bienvenido, ',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        //Acciones
        Container(
          width: double.infinity - 60,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.lightSecondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Transferir
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightTertiary,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.moneyBillTransfer),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Transferir',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
              //Tarjetas
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightTertiary,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeCards()),
                        );
                      },
                      icon: FaIcon(FontAwesomeIcons.creditCard),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Cuentas',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
              //Movimientos
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightTertiary,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.magnifyingGlassDollar),
                    ),
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Movimientos',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
              //Resumen
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    //child: Icon(),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.lightTertiary,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.receipt),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Resumen',
                    style: TextStyle(fontSize: 12, color: AppColors.lightText),
                  ),
                ],
              ),
            ],
          ),
        ),
        //Cuentas
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Cuentas', style: TextStyle(fontSize: 20)),
            Text('0.00', style: TextStyle(fontSize: 20)),
          ],
        ),
        Expanded(
          child: ListView.separated(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: cuentas.length,
            separatorBuilder: (context, index) => SizedBox(height: 8),
            itemBuilder: (context, index) {
              final cuenta = cuentas[index];
              return Cuentas(
                nombre: cuenta['nombre'],
                numeroCuenta: cuenta['numeroCuenta'],
                saldo: cuenta['saldo'],
              );
            },
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Ver gastos e ingresos',
          style: TextStyle(fontSize: 18, color: AppColors.lightText),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
