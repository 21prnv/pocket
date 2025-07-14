import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocket/models/conversation.dart';
import 'package:pocket/ui/common/ui_helpers.dart';

class ConversationItem extends StatelessWidget {
  final Conversation conversation;

  const ConversationItem({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(colors: conversation.gradientColors),
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      conversation.title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (conversation.hasIcon) ...[
                      horizontalSpaceTiny,
                      Image.asset('assets/images/menu.png', width: 16)
                    ]
                  ],
                ),
                Text(
                  conversation.subtitle,
                  style: GoogleFonts.inter(color: Colors.grey, fontSize: 14),
                ),
                verticalSpaceMedium,
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 0.5,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
