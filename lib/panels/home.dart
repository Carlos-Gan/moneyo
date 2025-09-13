import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/panels/home_cards.dart';
import 'package:moneyo/widgets/cuentas.dart';
import 'package:moneyo/widgets/tarjeta_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Listas
  List<Cuenta> listaCuentas = [];
  List<Tarjeta> listaTarjetas = [];

  Future<void> cargarDatos() async {
    final cuentas = await OperacionesBD.obtenerCuentas();
    final tarjetas = await OperacionesBD.obtenerTarjetas();
    setState(() {
      listaCuentas = cuentas;
      listaTarjetas = tarjetas;
    });
  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

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
          child: RefreshIndicator(
            onRefresh: cargarDatos,
            child: ListView(
              children: [
                //Tarjetas
                ...listaTarjetas.map(
                  (tarjeta) => Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                    child: TarjetasVisual(
                      tarjetaColor: Color(tarjeta.colorFondo),
                      numeroTarjeta: tarjeta.numeroTarjeta,
                      bancoNombre: tarjeta.nombre,
                      saldo: tarjeta.saldo,
                      fechaVencimiento: tarjeta.fechaVencimiento,
                      isCredito: tarjeta.esCredito,
                      fechaCorte: tarjeta.esCredito
                          ? (tarjeta.fechaCorte ?? '')
                          : '',
                      fechaLimitePago: tarjeta.esCredito
                          ? (tarjeta.fechaLimite ?? '')
                          : '',
                    ),
                  ),
                ),
                //Cuentas
                ...listaCuentas.map(
                  (cuenta) => Padding(
                    padding: EdgeInsetsGeometry.symmetric(vertical: 5),
                    child: Cuentas(
                      nombre: cuenta.nombre,
                      tipo: cuenta.tipo,
                      saldo: cuenta.saldo,
                      color: Color(cuenta.color),
                    ),
                  ),
                ),
              ],
            ),
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
