import 'dart:async';

import 'package:speech_recognition/speech_recognition.dart';

class SpeechProvider {
  SpeechRecognition _speechRecognition = SpeechRecognition();
  bool _isAvailable = false;
  bool _isListening = false;

  String _resultText = "";
  String _locale = "en_US";

  final _availableController = StreamController<bool>.broadcast();
  final _listeningController = StreamController<bool>.broadcast();
  final _lastWordsController = StreamController<String>.broadcast();

  Stream<String> get wordStream => _lastWordsController.stream;
  Stream<bool> get avaibleStream => _availableController.stream;
  Stream<bool> get listenStream => _listeningController.stream;

  Function(String) get wordChange => _lastWordsController.sink.add;
  Function(bool) get availableChange => _availableController.sink.add;
  Function(bool) get listeningChange => _availableController.sink.add;

  String get lastWords => _resultText;
  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;

  void initSpeechRecognizer() {
    _speechRecognition.setAvailabilityHandler(
        (bool result) => availableChange(_isAvailable = result));

    _speechRecognition.setRecognitionStartedHandler(
        () => listeningChange(_isListening = true));

    _speechRecognition.setRecognitionResultHandler(
        (String speech) => wordChange(_resultText = speech));

    _speechRecognition.setRecognitionCompleteHandler(
        () => listeningChange(_isListening = false));

    _speechRecognition
        .activate()
        .then((result) => availableChange(_isAvailable = result));
  }

  Future<void> speechToText() async {
    if (_isAvailable && !_isListening)
      _speechRecognition
          .listen(locale: _locale)
          .then((result) => print('$result'));
  }

  Future<void> stopSpeech() async {
    if (_isListening)
      _speechRecognition
          .stop()
          .then((result) => listeningChange(_isListening = result));
  }

  Future<void> cancelSpeech() async {
    if (_isListening)
      _speechRecognition.cancel().then((result) {
        listeningChange(_isListening = result);
        wordChange(_resultText = "");
      });
  }

  dispose() {
    _availableController?.close();
    _listeningController?.close();
    _lastWordsController?.close();
  }
}
