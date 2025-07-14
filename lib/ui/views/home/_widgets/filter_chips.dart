import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket/ui/common/ui_helpers.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          FilterChip(text: 'Mettings', cardCount: 3),
          FilterChip(text: 'Chats', cardCount: 2),
          FilterChip(text: 'Thoughts', cardCount: 1),
        ],
      ),
    );
  }
}

class FilterChip extends StatelessWidget {
  final String text;
  final int cardCount;

  const FilterChip({
    Key? key,
    required this.text,
    required this.cardCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imageAssets = text == 'Thoughts'
        ? ['assets/images/thought-grade.png']
        : [
            'assets/images/grad1.png',
            'assets/images/grad2.png',
            'assets/images/grad3.png',
          ];

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      color: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              height: 35,
              child: Stack(
                children: List.generate(cardCount, (index) {
                  return Positioned(
                    left: index * 9.0,
                    top: index * 1.0,
                    child: Container(
                      width: 32,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          imageAssets[index % imageAssets.length],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            horizontalSpaceSmall,
            Text(
              text,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
