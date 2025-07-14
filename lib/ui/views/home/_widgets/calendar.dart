import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:intl/intl.dart';
import 'package:pocket/ui/common/ui_helpers.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChange;

  const Calendar({
    Key? key,
    required this.selectedDate,
    required this.onDateChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: selectedDate,
      activeColor: Colors.orange,
      headerProps: const EasyHeaderProps(
        showHeader: false,
      ),
      dayProps: const EasyDayProps(
        height: 70,
        width: 50,
      ),
      itemBuilder: (context, date, _, __) {
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        final dayName = isSelected
            ? DateFormat('E').format(date).toUpperCase()
            : DateFormat('E').format(date)[0];

        final isToday = date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

        return InkWell(
          onTap: () => onDateChange(date),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            decoration: isSelected
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isToday
                            ? Colors.orange.shade200
                            : Colors.grey.shade200),
                  )
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date.day.toString(),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.grey,
                    fontSize: 18,
                  ),
                ),
                verticalSpaceTiny,
                Text(
                  dayName,
                  style: GoogleFonts.inter(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.orange : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
