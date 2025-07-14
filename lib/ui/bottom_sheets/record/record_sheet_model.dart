import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:stacked/stacked.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordSheetModel extends BaseViewModel {
  late final RecorderController recorderController;

  String? _path;
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  RecordSheetModel() {
    _initialize();
  }

  void _initialize() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
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
    notifyListeners();
  }

  Future<void> _pauseRecording() async {
    await recorderController.pause();
    _isRecording = false;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    await recorderController.stop();
    _path = await recorderController.stop();
    _isRecording = false;
    notifyListeners();
  }

  void toggleRecording() {
    if (_isRecording) {
      _pauseRecording();
    } else {
      _startRecording();
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }
}
