import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CardUtils {
  static Widget getCardLogo(String cardNumber) {
    if (cardNumber.isEmpty) return const SizedBox();

    final cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.startsWith('4')) {
      return Image.asset('assets/logos/visa.png', height: 10);
    } else if (cleanNumber.startsWith('506')) {
      return Image.asset('assets/logos/carnet.png', height: 24);
    } else if (cleanNumber.startsWith('3')) {
      return Image.asset('assets/logos/amex.png', height: 24);
    } else if (cleanNumber.startsWith('5')) {
      return Image.asset('assets/logos/mastercard.png', height: 24);
    } else if (cleanNumber.startsWith('6')) {
      return Image.asset('assets/logos/discover.png', height: 24);
    }

    // default genérico si no coincide
    return const Icon(Icons.credit_card, size: 24, color: Colors.white);
  }

  static Widget getCardLogoWithType(String cardNumber) {
    if (cardNumber.isEmpty) return const SizedBox();

    final cleanNumber = cardNumber.replaceAll(' ', '');
    String type = getCardType(cleanNumber);

    switch (type) {
      case 'Visa':
        return Row(
          children: [
            Image.asset('assets/logos/visa.png', height: 10),
            const SizedBox(width: 5),
          ],
        );
      case 'MasterCard':
        return Row(
          children: [
            Image.asset('assets/logos/mastercard.png', height: 20),
            const SizedBox(width: 5),
          ],
        );
      case 'Amex':
        return Row(
          children: [
            Image.asset('assets/logos/amex.png', height: 20),
            const SizedBox(width: 5),
          ],
        );
      case 'Carnet':
        return Row(
          children: [
            Image.asset('assets/logos/carnet.png', height: 20),
            const SizedBox(width: 5),
          ],
        );
      default:
        return Row(children: [
          ],
        );
    }
  }

  static String getCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'MasterCard';
    if (cardNumber.startsWith('3')) return 'Amex';
    if (cardNumber.startsWith('506')) return 'Carnet';
    return 'Desconocida';
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
