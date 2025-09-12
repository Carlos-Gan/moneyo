import 'package:flutter/material.dart';
import 'package:moneyo/bd/bd_helper.dart';
import 'package:moneyo/extras/app_colors.dart';
import 'package:moneyo/panels/panel_principal.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await BdHelper.database;
  print('DB initialized at: ${db.path}');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''), // Español
        Locale('en', ''), // Inglés
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.backgroundLight,
          brightness: Brightness.light,
          surface: AppColors.backgroundLight,
          secondary: AppColors.lightSecondary,
          tertiary: AppColors.lightTertiary,
          onPrimaryContainer: Colors.white,
          surfaceDim: AppColors.lightText,
        ),
        useMaterial3: true,
      ),
      home: const PanelPrincipal(),
    );
  }
}
