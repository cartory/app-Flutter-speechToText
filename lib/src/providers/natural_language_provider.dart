import 'dart:async';

import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/language/v1.dart';

import 'package:appstt/src/providers/auth_credentials.dart';

class NaturalLanguageProvider {
  final _scopes = [LanguageApi.CloudLanguageScope];
  final _jsonController = StreamController<Map<String, Object>>.broadcast();

  AutoRefreshingAuthClient _client;
  LanguageApi _api;

  Stream<Map<String, Object>> get jsonStream => _jsonController.stream;

  init() {
    clientViaServiceAccount(accountCredentials, _scopes).then((client) {
      _client = client;
      _api = LanguageApi(_client);
    }).catchError((e) {
      print('AN ERROR HAS OCURRED WHILE SIGNING IN');
    });
  }

  analizeText(String text) {
    if (text == null) return;
    print(text);
    var req = AnalyzeEntitiesRequest.fromJson({
      "document": {
        "type": "PLAIN_TEXT", 
        "language": "ES", 
        "content": text
      },
      "encodingType": "UTF8"
    });

    _api.documents.analyzeEntities(req).then((res) {
      _jsonController.sink.add(res.toJson());
    }).catchError((e) {
      print('AN ERROR HAS OCURRED IN ANALIZETEXT');
    });
  }

  dispose() {
    _client?.close();
    _jsonController?.close();
  }
}
