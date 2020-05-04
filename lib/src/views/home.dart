import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_json_widget/flutter_json_widget.dart';

import 'package:appstt/src/providers/speech_provider.dart';
import 'package:appstt/src/providers/natural_language_provider.dart';

final snackBar = SnackBar(
  backgroundColor: Colors.white70,
  duration: Duration(seconds: 30),
  content: StreamBuilder(
      stream: SpeechProvider.instance.dataStream,
      builder: (_, AsyncSnapshot<SpeechData> snapshot) {
        return Text(
          snapshot.data?.text ?? 'Esperando voz...',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        );
      }),
);

final json = {
  "title": "SpeechToText and NaturalLanguage",
  "info": "Tap mic button to analyze text",
};

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SpeechProvider.instance.init();
    NaturalLanguageProvider.instance.init();
    requestPermission(Permission.microphone);
    SpeechProvider.instance.dataStream.listen((data) {
      print(data.text);
      if (!data.status) {
        NaturalLanguageProvider.instance.analizeEntities(data.text);
        data.status = true;
        SpeechProvider.instance.dataSink(data);
        scaffoldKey.currentState.removeCurrentSnackBar();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Speech to Text App'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: NaturalLanguageProvider.instance.jsonStream,
          builder: (_, AsyncSnapshot<Map<String, Object>> snapshot) {
            ErrorWidget.builder = (errorDetails) => Container();
            return displayJson(snapshot.data ?? json);
          }),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.all(3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              FloatingActionButton(
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(Icons.mic),
                onPressed: () {
                  SpeechProvider.instance.speechToText();
                  scaffoldKey.currentState.showSnackBar(snackBar);
                },
              ),
              IconButton(
                icon: Icon(Icons.account_box),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayJson(Map<String, Object> json) {
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
  }

  requestPermission(Permission permission) async => await permission.request();

  @override
  void dispose() {
    NaturalLanguageProvider.instance.dispose();
    SpeechProvider.instance.dispose();
    super.dispose();
  }
}
