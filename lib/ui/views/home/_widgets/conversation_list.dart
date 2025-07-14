import 'package:flutter/material.dart';
import 'package:pocket/models/conversation.dart';
import 'conversation_item.dart';

class ConversationList extends StatelessWidget {
  final List<Conversation> conversations;

  const ConversationList({Key? key, required this.conversations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: conversations
          .map((conversation) => ConversationItem(conversation: conversation))
          .toList(),
    );
  }
}
