import 'dart:async';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechProvider {
  final _wordController = StreamController<String>.broadcast();
  final SpeechToText _speech = SpeechToText();

  bool _hasSpeech;
  LocaleName language;
  String _words, _error, _status;

  Stream<String> get wordStream => _wordController.stream;
  String get status => _status;
  String get words => _words;
  String get error => _error;

  Future<void> init(bool mounted) async {
    bool hasSpeech = await _speech.initialize(
        onError: _errorListener, onStatus: _statusListener);
    if (hasSpeech) {
      language = await _speech.systemLocale();
    }
    _hasSpeech = mounted ? hasSpeech : _hasSpeech;
  }

  speechToText() {
    _speech
    .initialize(onStatus: _statusListener, onError: _errorListener)
    .then((avalaible) {
      if (avalaible) {
        _speech.listen(onResult: _resultListener, localeId: language.localeId);
      }
    });
    // some time later...
    _speech.stop();
  }

  cancelSpeech() => _speech.cancel();

  _resultListener(SpeechRecognitionResult result) =>
      _wordController.sink.add(_words = result.recognizedWords);

  _errorListener(SpeechRecognitionError error) => _error = error.errorMsg;

  _statusListener(String status) => _status = status;

  dispose() => _wordController?.close();
}
