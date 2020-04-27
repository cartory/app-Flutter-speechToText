import 'package:flutter/material.dart';

import 'package:flutter_json_widget/flutter_json_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:appstt/src/providers/natural_language_provider.dart';
import 'package:appstt/src/providers/speech_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NaturalLanguageProvider naturalProvider = NaturalLanguageProvider();
  SpeechProvider speechProvider = SpeechProvider();

  @override
  void initState() {
    super.initState();
    naturalProvider.init();
    speechProvider.init(mounted);
    requestPermission(Permission.microphone);
    speechProvider.wordStream
        .listen((words) => naturalProvider.analizeText(words));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text App'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: naturalProvider.jsonStream,
          builder: (_, AsyncSnapshot<Map<String, Object>> snapshot) {
            return snapshot.hasData
                ? displayJson(snapshot.data)
                : Center(child: Text('Esperando voz...'));
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        child: Icon(Icons.mic),
        onPressed: () => speechProvider.speechToText(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget displayJson(Map<String, Object> json) {
    try {
      return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Container(
            child: SingleChildScrollView(child: JsonViewerWidget(json)),
            padding: EdgeInsets.fromLTRB(20, 20, 15, 15),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        ),
      );
    } catch (e) {
      return Container(child: Center(child: Text('Repita de nuevo, por favor')));
    }
  }

  requestPermission(Permission permission) async => await permission.request();

  @override
  void dispose() {
    naturalProvider.dispose();
    speechProvider.dispose();
    super.dispose();
  }
}
