import 'dart:async';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechData {
  bool status;
  String text, error;
}

class SpeechProvider {
  static SpeechProvider _instance = SpeechProvider();
  
  final _data = SpeechData();
  final _speech = SpeechToText();
  final _speechController = StreamController<SpeechData>.broadcast();

  LocaleName language;

  static SpeechProvider get instance => _instance;
  Stream<SpeechData> get dataStream => _speechController.stream;
  Function(SpeechData) get dataSink => _speechController.sink.add;

  init() {
    _speech
    .initialize(onError: _errorListener, onStatus: _statusListener)
    .then((active) {
      if (active) _speech.systemLocale().then((locale) => language = locale);
    });
  }

  speechToText() {
    _speech
    .initialize(onStatus: _statusListener, onError: _errorListener)
    .then((avalaible) {
      if (avalaible)
        _speech.listen(onResult: _resultListener, localeId: language.localeId);
    });
    // some time later...
    _speech.stop();
  }

  _resultListener(SpeechRecognitionResult result) {
    _data.text = result.recognizedWords;
    dataSink(_data);
  }

  _errorListener(SpeechRecognitionError error) {
    _data.error = error.errorMsg;
    dataSink(_data);
  }

  _statusListener(String status) {
    _data.status = status == "listening";
    dataSink(_data);
  }

  dispose() => _speechController?.close();
}
