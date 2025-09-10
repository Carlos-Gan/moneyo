import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/panels/home.dart';

class PanelPrincipal extends StatefulWidget {
  const PanelPrincipal({super.key});

  @override
  State<PanelPrincipal> createState() => _PanelPrincipalState();
}

class _PanelPrincipalState extends State<PanelPrincipal> {
  int _currentIndex = 0; // 0=Home, 1=Notificaciones, 2=Ajustes

  final List<Widget> _pages = const [
    Padding(padding: EdgeInsets.symmetric(horizontal: 30.0), child: Home()),
    Center(child: Text('Notificaciones')),
    Center(child: Text('Ajustes')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomAppBar(
        color: AppColors.appBarColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        height: 60,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavIcon(FontAwesomeIcons.house, 0, 'Inicio'),
              _buildNavIcon(FontAwesomeIcons.bell, 1, 'Notificaciones'),
              _buildNavIcon(FontAwesomeIcons.gear, 2, 'Ajustes'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, String tooltip) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10), // Aumenta la zona clickeable
        color: Colors.transparent, // Necesario para detectar taps
        child: FaIcon(
          icon,
          size: 28,
          color: _currentIndex == index
              ? Colors.amber.shade700
              : Colors.grey.shade600,
        ),
      ),
    );
  }
}
