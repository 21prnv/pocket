import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pocket/app/app.locator.dart';
import 'package:pocket/models/conversation.dart';
import 'package:pocket/services/local_storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

enum AnimationDirection { forward, backward }

class HomeViewModel extends BaseViewModel {
  final _localStorageService = locator<LocalStorageService>();
  late PageController pageController;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  final Map<String, List<Conversation>> _cachedConversations = {};

  List<Conversation> get conversations {
    final dateKey = _selectedDate.toIso8601String().substring(0, 10);
    final conversationList = _cachedConversations[dateKey] ?? [];

    if (conversationList.isEmpty) {
      _loadConversationsForDate(_selectedDate);
    }

    return conversationList;
  }

  late final RecorderController recorderController;
  String? _path;
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isRecordingSession = false;
  bool get isRecordingSession => _isRecordingSession;

  bool _isRecordingExpanded = false;
  bool get isRecordingExpanded => _isRecordingExpanded;

  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  Duration get recordingDuration => _recordingDuration;

  String get formattedRecordingTime {
    final minutes = _recordingDuration.inMinutes;
    final seconds = _recordingDuration.inSeconds % 60;
    final milliseconds = (_recordingDuration.inMilliseconds % 1000) ~/ 10;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
  }

  HomeViewModel() {
    pageController = PageController(
      initialPage: DateTime.now().difference(DateTime(2022, 1, 1)).inDays,
    );
    _initializeRecorder();
    _initialize();
  }

  void init() {
    pageController = PageController(
      initialPage: DateTime.now().difference(DateTime(2022, 1, 1)).inDays,
    );
    _initializeRecorder();
    _initialize();
  }

  void _initializeRecorder() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  Future<void> _initialize() async {
    await _loadConversationsForDate(_selectedDate);

    await preloadConversationsForDates();

    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    recorderController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  Future<void> onDateChange(DateTime date) async {
    final newPageIndex = date.difference(DateTime(2022, 1, 1)).inDays;
    pageController.jumpToPage(newPageIndex);
    _selectedDate = date;
    await _loadConversationsForDate(date);
    notifyListeners();
  }

  Future<void> onPageChanged(int index) async {
    final newDate = DateTime(2022, 1, 1).add(Duration(days: index));
    _selectedDate = newDate;
    await _loadConversationsForDate(newDate);
    notifyListeners();
  }

  Future<void> _loadConversationsForDate(DateTime date) async {
    final dateKey = date.toIso8601String().substring(0, 10);

    final conversations =
        await _localStorageService.loadConversationsForDate(dateKey);

    if (conversations != null) {
      _cachedConversations[dateKey] = conversations;
    } else {
      await _createAndStoreConversationsForDate(dateKey);
    }
  }

  Future<void> _createAndStoreConversationsForDate(String dateKey) async {
    final newConversations = _generateDummyConversationsForDate();
    _cachedConversations[dateKey] = newConversations;
    await _localStorageService.saveConversationsForDate(
        dateKey, newConversations);
  }

  List<Conversation> _generateDummyConversationsForDate() {
    final random = Random();
    final count = random.nextInt(4) + 1;

    final List<Map<String, dynamic>> conversationTemplates = [
      {
        'title': 'Morning thoughts',
        'subtitle': 'Daily reflection • 08:45',
        'gradients': [const Color(0xFF667eea), const Color(0xFF764ba2)],
        'hasIcon': false,
      },
      {
        'title': '1:1 w/ Akshay',
        'subtitle': 'Conversation about product features',
        'gradients': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
        'hasIcon': true,
      },
      {
        'title': '2025 predictions',
        'subtitle': 'Thoughts on tech trends for 2025',
        'gradients': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
        'hasIcon': false,
      },
      {
        'title': 'Project planning',
        'subtitle': 'Next steps for the new feature',
        'gradients': [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
        'hasIcon': true,
      },
      {
        'title': 'Team sync',
        'subtitle': 'Weekly catch-up with the team',
        'gradients': [const Color(0xFFfa709a), const Color(0xFFfee140)],
        'hasIcon': false,
      },
      {
        'title': 'Client meeting',
        'subtitle': 'Discussing project requirements',
        'gradients': [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
        'hasIcon': true,
      },
      {
        'title': 'Coffee chat',
        'subtitle': 'Casual conversation with colleague',
        'gradients': [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
        'hasIcon': false,
      },
      {
        'title': 'Weekly review',
        'subtitle': 'Reviewing progress and goals',
        'gradients': [const Color(0xFF8fd3f4), const Color(0xFF84fab0)],
        'hasIcon': true,
      },
      {
        'title': 'Brainstorming',
        'subtitle': 'Ideas for new features',
        'gradients': [const Color(0xFFd299c2), const Color(0xFFfed6e3)],
        'hasIcon': false,
      },
      {
        'title': 'Code review',
        'subtitle': 'Reviewing pull requests',
        'gradients': [const Color(0xFFff8a80), const Color(0xFFff80ab)],
        'hasIcon': true,
      },
    ];

    final selectedTemplates = <Map<String, dynamic>>[];
    final usedIndices = <int>{};

    for (int i = 0; i < count; i++) {
      int randomIndex;
      do {
        randomIndex = random.nextInt(conversationTemplates.length);
      } while (usedIndices.contains(randomIndex));

      usedIndices.add(randomIndex);
      selectedTemplates.add(conversationTemplates[randomIndex]);
    }

    return selectedTemplates.map((template) {
      return Conversation(
        title: template['title'] as String,
        subtitle: template['subtitle'] as String,
        gradientColors: template['gradients'] as List<Color>,
        hasIcon: template['hasIcon'] as bool,
        audioType: 'text',
        createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(24))),
      );
    }).toList();
  }

  List<Color> _generateRandomGradientColors() {
    final random = Random();
    final gradientSets = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
      [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
      [const Color(0xFFff8a80), const Color(0xFFff80ab)],
      [const Color(0xFF8fd3f4), const Color(0xFF84fab0)],
      [const Color(0xFFd299c2), const Color(0xFFfed6e3)],
    ];

    return gradientSets[random.nextInt(gradientSets.length)];
  }

  Future<void> _startRecording() async {
    final hasPermission = await Permission.microphone.isGranted;
    if (!hasPermission) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        return;
      }
    }
    await recorderController.record();
    _isRecording = true;
    _isRecordingSession = true;
    _startTimer();
    notifyListeners();
  }

  Future<void> _pauseRecording() async {
    await recorderController.pause();
    _isRecording = false;
    _stopTimer();
    notifyListeners();
  }

  Future<void> stopRecording() async {
    _path = await recorderController.stop();
    _isRecording = false;
    _isRecordingSession = false;
    _stopTimer();

    if (_path != null) {
      print('Recording path: $_path');
      await _saveRecordingAsConversation(_path!);
    } else {
      print('No recording path available');
    }

    _resetTimer();
  }

  Future<void> _saveRecordingAsConversation(String tempPath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${directory.path}/recordings');
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'recording_$timestamp.m4a';
      final permanentPath = '${recordingsDir.path}/$fileName';

      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.copy(permanentPath);
        await tempFile.delete();
      }

      final newConversation = Conversation(
        title: 'New Memory',
        subtitle: 'Audio recording • ${formattedRecordingTime}',
        gradientColors: _generateRandomGradientColors(),
        hasIcon: true,
        audioPath: permanentPath,
        audioType: 'audio',
        createdAt: DateTime.now(),
      );

      final dateKey = _selectedDate.toIso8601String().substring(0, 10);

      if (!_cachedConversations.containsKey(dateKey)) {
        _cachedConversations[dateKey] = [];
      }

      _cachedConversations[dateKey]!.insert(0, newConversation);

      await _localStorageService.addConversationToDate(
          dateKey, newConversation);

      hideRecordSheet();

      notifyListeners();
    } catch (e) {
      print('Error saving recording: $e');
    }
  }

  void _startTimer() {
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _recordingDuration += const Duration(milliseconds: 10);
      notifyListeners();
    });
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  void _resetTimer() {
    _recordingDuration = Duration.zero;
  }

  void toggleRecording() {
    if (_isRecording) {
      _pauseRecording();
    } else {
      _startRecording();
    }
  }

  void showRecordSheet(BuildContext context) {
    _isRecordingExpanded = true;
    notifyListeners();
  }

  void hideRecordSheet() {
    _isRecordingExpanded = false;
    notifyListeners();
  }

  Future<void> playAudioConversation(Conversation conversation) async {
    if (conversation.audioPath != null && conversation.audioType == 'audio') {
      final file = File(conversation.audioPath!);
      if (await file.exists()) {
        final playerController = PlayerController();
        try {
          await playerController.preparePlayer(path: conversation.audioPath!);
          await playerController.startPlayer();
        } catch (e) {
          print('Error playing audio: $e');
        }
      } else {
        print('Audio file not found: ${conversation.audioPath}');
      }
    }
  }

  Future<void> refreshConversations() async {
    final dateKey = _selectedDate.toIso8601String().substring(0, 10);
    _cachedConversations.remove(dateKey);
    await _loadConversationsForDate(_selectedDate);
    notifyListeners();
  }

  Future<void> clearAllConversations() async {
    await _localStorageService.clearAllConversations();
    _cachedConversations.clear();
    await _loadConversationsForDate(_selectedDate);
    notifyListeners();
  }

  Future<void> preloadConversationsForDates() async {
    final today = DateTime.now();

    for (int i = -7; i <= 7; i++) {
      final date = today.add(Duration(days: i));
      await _loadConversationsForDate(date);
    }

    notifyListeners();
  }
}
