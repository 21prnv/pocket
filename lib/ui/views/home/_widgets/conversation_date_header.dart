import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConversationDateHeader extends StatelessWidget {
  final DateTime selectedDate;
  final int conversationCount;

  const ConversationDateHeader({
    Key? key,
    required this.selectedDate,
    required this.conversationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dayName = DateFormat("EEEE").format(selectedDate);
    final dateOnly = DateFormat("MMM d ''yy").format(selectedDate);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$dayName, ',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: dateOnly,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              conversationCount.toString(),
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ],
    );
  }
}
