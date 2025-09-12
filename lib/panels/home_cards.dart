import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneyo/bd/operaciones_bd.dart';
import 'package:moneyo/bd/tarjetas.dart';
import 'package:moneyo/panels/cuentas_add.dart';
import 'package:moneyo/widgets/tarjeta_card.dart';

class HomeCards extends StatelessWidget {
  const HomeCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Cuentas'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddAccounts()),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: [
            Text(
              'Tarjetas Disponibles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: FutureBuilder<List<Tarjeta>>(
                future: OperacionesBD.obtenerTarjetas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay tarjetas disponibles'),
                    );
                  }

                  final tarjetas = snapshot.data!;

                  if (tarjetas.length > 3) {
                    return PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: PageController(viewportFraction: 0.8),
                      itemBuilder: (context, index) {
                        final tarjeta = tarjetas[index % tarjetas.length];
                    
                        return TarjetasVisual(
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
                        );
                      },
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: tarjetas
                            .map(
                              (tarjeta) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
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
                            )
                            .toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cuentas Disponibles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
