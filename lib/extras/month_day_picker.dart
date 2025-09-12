import 'package:flutter/material.dart';

enum DatePickerModes { monthDay, monthYear, fullDate }

class CustomDatePickerBottomSheet {
  static Future<void> show(
    BuildContext context, {
    DatePickerModes mode = DatePickerModes.fullDate,
    int? initialDay,
    int? initialMonth,
    int? initialYear,
    int minYear = 1900,
    int maxYear = 2100,
    required void Function({int? day, int? month, int? year}) onChanged,
  }) async {
    // Valores iniciales
    int selectedDay = initialDay ?? DateTime.now().day;
    int selectedMonth = initialMonth ?? DateTime.now().month;
    int selectedYear = initialYear ?? DateTime.now().year;

    final monthController = FixedExtentScrollController(
      initialItem: 1000 * 12 + selectedMonth - 1,
    );

    final dayController = FixedExtentScrollController(
      initialItem: 1000 * 31 + selectedDay - 1,
    );

    final yearController = FixedExtentScrollController(
      initialItem: 1000 * (maxYear - minYear + 1) + (selectedYear - minYear),
    );

    const monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    int daysInMonth(int y, int m) {
      final nextMonth = m == 12 ? DateTime(y + 1, 1, 1) : DateTime(y, m + 1, 1);
      return nextMonth.subtract(const Duration(days: 1)).day;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              // Barra de botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      onChanged(
                        day: mode != DatePickerModes.monthYear
                            ? selectedDay
                            : null,
                        month: selectedMonth,
                        year: mode != DatePickerModes.monthDay
                            ? selectedYear
                            : null,
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Día
                    if (mode != DatePickerModes.monthYear)
                      SizedBox(
                        width: 60,
                        child: ListWheelScrollView.useDelegate(
                          controller: dayController,
                          itemExtent: 40,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            final maxDay = daysInMonth(
                              selectedYear,
                              selectedMonth,
                            );
                            selectedDay = (index % maxDay) + 1;
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final maxDay = daysInMonth(
                                selectedYear,
                                selectedMonth,
                              );
                              final dayNum = (index % maxDay) + 1;
                              return Center(child: Text(dayNum.toString()));
                            },
                          ),
                        ),
                      ),

                    if (mode != DatePickerModes.monthYear)
                      const SizedBox(width: 16),

                    // Mes
                    SizedBox(
                      width: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: monthController,
                        itemExtent: 40,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          selectedMonth = (index % 12) + 1;
                          final maxDay = daysInMonth(
                            selectedYear,
                            selectedMonth,
                          );
                          if (selectedDay > maxDay) selectedDay = maxDay;
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final monthNum = (index % 12) + 1;
                            return Center(
                              child: Text(monthNames[monthNum - 1]),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Año
                    if (mode != DatePickerModes.monthDay)
                      SizedBox(
                        width: 80,
                        child: ListWheelScrollView.useDelegate(
                          controller: yearController,
                          itemExtent: 40,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            selectedYear =
                                minYear + (index % (maxYear - minYear + 1));
                            if (mode == DatePickerModes.fullDate) {
                              final maxDay = daysInMonth(
                                selectedYear,
                                selectedMonth,
                              );
                              if (selectedDay > maxDay) selectedDay = maxDay;
                            }
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final y =
                                  minYear + (index % (maxYear - minYear + 1));
                              return Center(child: Text(y.toString()));
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
