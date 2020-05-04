import 'dart:async';

import 'package:googleapis/language/v1.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:appstt/src/providers/auth_credentials.dart';

class NaturalLanguageProvider {
  static NaturalLanguageProvider _instance = NaturalLanguageProvider();

  final _scopes = [LanguageApi.CloudLanguageScope];
  final _jsonController = StreamController<Map<String, Object>>.broadcast();

  static final _doc = {
    "type": "PLAIN_TEXT",
    "language": "ES",
    "content": "textToAnalyze",
  };

  final _json = {"document": _doc, "encodingType": "UTF8"};

  LanguageApi _api;
  AutoRefreshingAuthClient _client;

  static NaturalLanguageProvider get instance => _instance;
  Stream<Map<String, Object>> get jsonStream => _jsonController.stream;

  init() {
    clientViaServiceAccount(accountCredentials, _scopes)
        .then((client) => _api = LanguageApi(_client = client))
        .catchError((e) => print('AN ERROR HAS OCURRED WHILE SIGNING IN'));
  }

  analizeEntities(String text) {
    _doc["content"] = text;
    var req = AnalyzeEntitiesRequest.fromJson(_json);

    _api.documents
        .analyzeEntities(req)
        .then((res) => _jsonController.sink.add(res.toJson()))
        .catchError((e) => print('AN ERROR HAS OCURRED IN ANALIZETEXT'));
  }

  dispose() {
    _client?.close();
    _jsonController?.close();
  }
}
