import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket/models/conversation.dart';

class LocalStorageService {
  static const String _conversationPrefix = 'conversations_';

  /// Save conversations for a specific date
  Future<void> saveConversationsForDate(
      String dateKey, List<Conversation> conversations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = json.encode(
        conversations.map((c) => c.toMap()).toList(),
      );
      await prefs.setString('$_conversationPrefix$dateKey', conversationsJson);
    } catch (e) {
      print('LocalStorageService: Error saving conversations for $dateKey: $e');
    }
  }

  /// Load conversations for a specific date
  Future<List<Conversation>?> loadConversationsForDate(String dateKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final conversationsJson = prefs.getString('$_conversationPrefix$dateKey');

      if (conversationsJson != null) {
        final List<dynamic> decoded = json.decode(conversationsJson);
        final conversations =
            decoded.map((c) => Conversation.fromMap(c)).toList();

        return conversations;
      }

      return null;
    } catch (e) {
      print(
          'LocalStorageService: Error loading conversations for $dateKey: $e');
      return null;
    }
  }

  /// Add a new conversation to the beginning of the list for a specific date
  Future<void> addConversationToDate(
      String dateKey, Conversation conversation) async {
    try {
      final existingConversations =
          await loadConversationsForDate(dateKey) ?? [];

      existingConversations.insert(0, conversation);

      await saveConversationsForDate(dateKey, existingConversations);
    } catch (e) {
      print('LocalStorageService: Error adding conversation to $dateKey: $e');
    }
  }

  /// Clear all conversations data
  Future<void> clearAllConversations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      for (final key in keys) {
        if (key.startsWith(_conversationPrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('LocalStorageService: Error clearing conversations: $e');
    }
  }

  /// Check if conversations exist for a specific date
  Future<bool> hasConversationsForDate(String dateKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('$_conversationPrefix$dateKey');
    } catch (e) {
      print(
          'LocalStorageService: Error checking conversations for $dateKey: $e');
      return false;
    }
  }

  /// Get all stored conversation dates
  Future<List<String>> getAllConversationDates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();

      return keys
          .where((key) => key.startsWith(_conversationPrefix))
          .map((key) => key.substring(_conversationPrefix.length))
          .toList();
    } catch (e) {
      print('LocalStorageService: Error getting conversation dates: $e');
      return [];
    }
  }
}
