import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket/ui/common/ui_helpers.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pocket',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Good morning, Sayan',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset('assets/images/search.png', width: 40),
            horizontalSpaceSmall,
            Stack(
              children: [
                Image.asset('assets/images/profile.png', width: 35),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset('assets/images/pro.png', width: 15),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
