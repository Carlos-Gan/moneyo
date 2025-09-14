import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class CardUtils {
  static final Map<String, String> logos = {
    'Visa': "assets/logos/visa.png",
    'MasterCard': "assets/logos/mastercard.png",
    'Amex': "assets/logos/amex.png",
    'Carnet': "assets/logos/carnet.png",
    'Discover': "assets/logos/discover.png",
  };

  static String getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'MasterCard';
    if (cardNumber.startsWith('3')) return "Amex";
    if (cardNumber.startsWith('506')) return 'Carnet';
    if (cardNumber.startsWith('6')) return 'Discover';
    return 'Desconocida';
  }

  static Widget getCardLogoRow(String cardNumber) {
    final cleanNumber = cardNumber.replaceAll(" ", "");
    final tipo = getCardType(cleanNumber);

    // 🔹 Si no hay número -> mostrar todos los logos en gris
    if (cleanNumber.isEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: logos.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Image.asset(
                  entry.value,
                  height: 30,
                ),
              ),
            )
            .toList(),
      );
    }

    // 🔹 Si hay número -> mostrar solo el logo correspondiente
    if (logos.containsKey(tipo)) {
      return Image.asset(logos[tipo]!, height: 30);
    }

    // 🔹 Si no coincide -> ícono genérico
    return const FaIcon(FontAwesomeIcons.creditCard, size: 30);
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    int maxLength = digitsOnly.startsWith('3') ? 15 : 16;
    if (digitsOnly.length > maxLength)
      digitsOnly = digitsOnly.substring(0, maxLength);

    String formatted = '';
    List<int> spaceIndexes = [];

    if (digitsOnly.startsWith('3')) {
      // AMEX 4-6-5
      for (int i = 0; i < digitsOnly.length; i++) {
        formatted += digitsOnly[i];
        if (i == 3 || i == 9) {
          formatted += ' ';
          spaceIndexes.add(formatted.length - 1);
        }
      }
    } else {
      // 16 dígitos 4-4-4-4
      for (int i = 0; i < digitsOnly.length; i++) {
        formatted += digitsOnly[i];
        if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
          formatted += ' ';
          spaceIndexes.add(formatted.length - 1);
        }
      }
    }

    // Ajuste de cursor
    int selectionIndex = newValue.selection.end;

    // Contar cuántos espacios hay antes del cursor
    int spacesBeforeCursor = spaceIndexes
        .where((index) => index < selectionIndex)
        .length;

    int newSelectionIndex = selectionIndex + spacesBeforeCursor;

    // Limitar al tamaño del texto
    if (newSelectionIndex > formatted.length)
      newSelectionIndex = formatted.length;

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Permite vacío
    if (text.isEmpty) return newValue;

    // Guarda si hay punto decimal
    bool hasDecimal = text.contains('.');

    // Divide parte entera y decimal
    List<String> parts = text.split('.');
    String integerPart = parts[0].replaceAll(
      ',',
      '',
    ); // quitar comas anteriores
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Formatea sólo la parte entera
    String formattedInteger = _formatter.format(int.tryParse(integerPart) ?? 0);

    // Reconstruye el texto
    String newText = hasDecimal
        ? '$formattedInteger.$decimalPart'
        : formattedInteger;

    // Ajusta la posición del cursor
    int selectionIndex =
        newText.length - (text.length - newValue.selection.end);
    selectionIndex = selectionIndex.clamp(0, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

//Agregar tipos de cuentas aqui
class AccountTypes {
  static final List<String> tipos = ['Ahorro', 'Efectivo', 'Cripto'];
}
