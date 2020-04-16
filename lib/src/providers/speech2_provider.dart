import 'dart:async';

import 'package:speech_recognition/speech_recognition.dart';

class SpeechProvider {
  SpeechRecognition _speechRecognition = SpeechRecognition();
  bool _isAvailable = false;
  bool _isListening = false;

  String _resultText = "";

  final _availableController = StreamController<bool>.broadcast();
  final _listeningController = StreamController<bool>.broadcast();
  final _lastWordsController = StreamController<String>.broadcast();

  Stream<String> get wordStream => _lastWordsController.stream;
  Stream<bool> get avaibleStream => _availableController.stream;
  Stream<bool> get listenStream => _listeningController.stream;

  String get lastWords => _resultText;
  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;

  void initSpeechRecognizer() {
    _setAvailabilityHandler();
    _setRecognitionStartedHandler();
    _setRecognitionResultHandler();
    _setRecognitionCompleteHandler();
    _activateThen();
  }

  void _setAvailabilityHandler() {
    _speechRecognition.setAvailabilityHandler((bool result) {
      _isAvailable = result;
      _availableController.sink.add(result);
    });
  }

  void _setRecognitionStartedHandler() {
    _speechRecognition.setRecognitionStartedHandler(() {
      _isListening = true;
      _listeningController.sink.add(true);
    });
  }

  void _setRecognitionResultHandler() {
    _speechRecognition.setRecognitionResultHandler((String speech) {
      _resultText = speech;
      _lastWordsController.sink.add(speech);
    });
  }

  void _setRecognitionCompleteHandler() {
    _speechRecognition.setRecognitionCompleteHandler(() {
      _isListening = false;
      _listeningController.sink.add(false);
    });
  }

  void _activateThen() {
    _speechRecognition.activate().then((result) {
      _isAvailable = result;
      _availableController.sink.add(result);
    });
  }

  Future<void> speechToText() async {
    if (_isAvailable && !_isListening)
      _speechRecognition
          .listen(locale: "en_US")
          .then((result) => print('$result'));
    // ...
    stopSpeech();
  }

  Future<void> stopSpeech() async {
    if (_isListening) {
      _speechRecognition.stop().then((result) {
        _isListening = result;
        _listeningController.sink.add(result);
      });
    }
  }

  Future<void> cancelSpeech() async {
    if (_isListening) {
      _speechRecognition.cancel().then((result) {
        _isListening = result;
        _resultText = "";
        _listeningController.sink.add(result);
        _lastWordsController.sink.add("");
      });
    }
  }

  dispose() {
    _availableController?.close();
    _listeningController?.close();
    _lastWordsController?.close();
  }
}
