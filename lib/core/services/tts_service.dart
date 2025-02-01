import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  TtsService._internal();

  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  String _currentLanguage = 'de-DE';

  bool get isInitialized => _isInitialized;
  String get currentLanguage => _currentLanguage;

  Future<void> initialize() async {
    try {
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playAndRecord,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.spokenAudio,
        );
      }

      _tts.setStartHandler(() {});
      _tts.setCompletionHandler(() {});
      _tts.setProgressHandler((text, start, end, word) {});
      _tts.setErrorHandler((message) {
        debugPrint('TTS Error: $message');
      });

      await _tts.setLanguage(_currentLanguage);
      await _tts.setSpeechRate(0.5);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      await _tts.awaitSpeakCompletion(true);
      _isInitialized = true;
    } catch (e) {
      debugPrint('TTS Initialisierungsfehler: $e');
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized) {
      try {
        if (Platform.isIOS) {
          await _tts.pause();
        }

        await _tts.setLanguage(_currentLanguage);
        await _tts.speak(text);
      } catch (e) {
        _isInitialized = false;
        await initialize();
        if (_isInitialized) {
          await speak(text);
        }
      }
    }
  }

  Future<void> stop() async {
    if (_isInitialized) {
      try {
        await _tts.stop();
      } catch (e) {
        debugPrint('TTS Stop-Fehler: $e');
      }
    }
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode == 'de' ? 'de-DE' : 'en-US';
    
    if (_isInitialized) {
      try {
        await _tts.setLanguage(_currentLanguage);
      } catch (e) {
        _isInitialized = false;
        await initialize();
      }
    }
  }
}
