import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneyo/bd/cuentas.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/panels/cuentas/detalle_cuentas_screen.dart';
import 'package:moneyo/panels/tarjetas/cuentas_add.dart';
import 'package:moneyo/panels/tarjetas/detalle_tarjetas_screen.dart';
import 'package:moneyo/widgets/cuentas.dart';
import 'package:moneyo/widgets/tarjeta_card.dart';

class HomeCards extends StatefulWidget {
  const HomeCards({super.key});

  @override
  State<HomeCards> createState() => _HomeCardsState();
}

class _HomeCardsState extends State<HomeCards> {
  List<Tarjeta> listaTarjetas = [];
  List<Cuenta> listaCuentas = [];

  @override
  void initState() {
    super.initState();
    cargarTarjetas(); // cargar al inicio
    cargarCuentas();
  }

  Future<void> cargarTarjetas() async {
    final tarjetas = await OperacionesBD.obtenerTarjetas();
    setState(() {
      listaTarjetas = tarjetas;
    });
  }

  Future<void> cargarCuentas() async {
    final cuentas = await OperacionesBD.obtenerCuentas();
    setState(() {
      listaCuentas = cuentas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Cuentas'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddAccounts()),
              );
              if (result == true) {
                setState(() {}); // refresca el FutureBuilder
              }
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {}); // refresca FutureBuilder
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tarjetas Disponibles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: FutureBuilder<List<Tarjeta>>(
                  future: OperacionesBD.obtenerTarjetas(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final tarjetas = snapshot.data!;
                    if (tarjetas.isEmpty) {
                      return const Center(
                        child: Text('No hay tarjetas disponibles'),
                      );
                    }
                    if (tarjetas.length > 3) {
                      return PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: tarjetas.length,
                        itemBuilder: (context, index) {
                          final tarjeta = tarjetas[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleTarjetasScreen(tarjeta: tarjeta),
                                ),
                              );
                              if (result == true) setState(() {});
                            },
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
                          );
                        },
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: tarjetas.map((tarjeta) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleTarjetasScreen(
                                            tarjeta: tarjeta,
                                          ),
                                    ),
                                  );
                                  if (result == true) setState(() {});
                                },
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
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Cuentas Disponibles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: FutureBuilder<List<Cuenta>>(
                  future: OperacionesBD.obtenerCuentas(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final cuentas = snapshot.data!;
                    if (cuentas.isEmpty) {
                      return const Center(
                        child: Text('No hay cuentas disponibles'),
                      );
                    }
                    if (cuentas.length > 3) {
                      return PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: PageController(viewportFraction: 0.8),
                        itemCount: cuentas.length,
                        itemBuilder: (context, index) {
                          final cuenta = cuentas[index];
                          return GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleCuentaScreen(cuenta: cuenta),
                                ),
                              );
                              if (result == true) setState(() {});
                            },
                            child: Cuentas(
                              color: Color(cuenta.color),
                              nombre: cuenta.nombre,
                              tipo: cuenta.tipo,
                              saldo: cuenta.saldo,
                              width: 250,
                            ),
                          );
                        },
                      );
                    } else {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: cuentas.map((cuenta) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalleCuentaScreen(cuenta: cuenta),
                                    ),
                                  );
                                  if (result == true) setState(() {});
                                },
                                child: Cuentas(
                                  color: Color(cuenta.color),
                                  nombre: cuenta.nombre,
                                  tipo: cuenta.tipo,
                                  saldo: cuenta.saldo,
                                  width: 250,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
