// import 'package:flutter/material.dart';
import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechProvider {
  final SpeechToText _speech = SpeechToText();
  final _wordController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _statusController = StreamController<String>.broadcast();
  
  bool _hasSpeech = false;
  String _words, _error, _status;
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];

  Stream<String> get wordStream => _wordController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<String> get statusStream => _statusController.stream;

  bool get hasSpeech => _hasSpeech;
  String get lastWords => _words;
  String get lastError => _error;
  String get lastStatus => _status;
  String get currentLocalID => _currentLocaleId;
  List<LocaleName> get localeNames => _localeNames;

  Future<void> initSpeechState(bool mounted) async {
    bool hasSpeech = await _speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await _speech.locales();
      var systemLocale = await _speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }
    // setstate
    if (!mounted) return;
    _hasSpeech = hasSpeech;
  }

  void resultListener(SpeechRecognitionResult result) {
    _words = result.recognizedWords;
    _wordController.sink.add(_words);
  }

  void errorListener(SpeechRecognitionError error) {
    _error = error.errorMsg;
    _wordController.sink.add(_error);
  }

  void statusListener(String status) {
    _status = status;
    _statusController.sink.add(_status);
  }

  Future<void> speechToText() async {
    await _speech.initialize(onStatus: statusListener, onError: errorListener)
        ? _speech.listen(onResult: resultListener)
        : print("The user has denied the use of speech recognition.");
    // some time later...
    _speech.stop();
  }

  dispose() {
    _wordController?.close();
    _errorController?.close();
    _statusController?.close();
  }
}
