import 'dart:convert';
import 'dart:ui';

class Conversation {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool hasIcon;
  final String? audioPath; // Path to the audio file
  final String? audioType; // Type of conversation (audio, text, etc.)
  final DateTime? createdAt; // When the conversation was created

  Conversation({
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.hasIcon = false,
    this.audioPath,
    this.audioType,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'gradientColors': gradientColors.map((c) => c.value).toList(),
      'hasIcon': hasIcon,
      'audioPath': audioPath,
      'audioType': audioType,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      title: map['title'],
      subtitle: map['subtitle'],
      gradientColors:
          (map['gradientColors'] as List).map((c) => Color(c as int)).toList(),
      hasIcon: map['hasIcon'] ?? false,
      audioPath: map['audioPath'],
      audioType: map['audioType'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Conversation.fromJson(String source) =>
      Conversation.fromMap(json.decode(source));
}
