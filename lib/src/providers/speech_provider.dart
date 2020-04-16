import 'dart:async';

import 'package:appstt/src/models/language_model.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SpeechProvider {
  SpeechRecognition _speechRecognition = SpeechRecognition();
  bool _isAvailable = false;
  bool _isListening = false;

  String _resultText = "";
  Language _locale = Language.languages.first;

  final _lastWordsController = StreamController<String>.broadcast();

  Stream<String> get wordStream => _lastWordsController.stream;

  String get lastWords => _resultText;
  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  Language get language => _locale;

  set lang(Language language) => _locale = language;

  void initSpeechRecognizer() {
    _speechRecognition
        .setAvailabilityHandler((bool result) => _isAvailable = result);

    _speechRecognition.setRecognitionStartedHandler(() => _isListening = true);

    _speechRecognition.setRecognitionResultHandler(
        (String speech) => _lastWordsController.sink.add(_resultText = speech));

    _speechRecognition
        .setRecognitionCompleteHandler(() => _isListening = false);

    _speechRecognition.activate().then((result) => _isAvailable = result);
  }

  Future<void> speechToText() async {
    if (_isAvailable && !_isListening)
      _speechRecognition
          .listen(locale: _locale.code)
          .then((result) => print('$result'));
  }

  Future<void> stopSpeech() async {
    if (_isListening)
      _speechRecognition.stop().then((result) => _isListening = result);
  }

  Future<void> cancelSpeech() async {
    if (_isListening)
      _speechRecognition.cancel().then((result) {
        _isListening = result;
        _lastWordsController.sink.add(_resultText = "");
      });
  }

  dispose() {
    _lastWordsController?.close();
  }
}
