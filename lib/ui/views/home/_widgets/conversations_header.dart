import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConversationsHeader extends StatelessWidget {
  const ConversationsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Your conversations',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
