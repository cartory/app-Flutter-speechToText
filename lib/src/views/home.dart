import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:appstt/src/providers/speech_provider.dart';
import 'package:appstt/src/views/pages/dashboard.dart';
import 'package:appstt/src/views/pages/settings.dart';
import 'package:appstt/src/views/pages/language.dart';
import 'package:appstt/src/views/pages/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //
  SpeechProvider speechProvider = SpeechProvider();
  // SpeechProvider speechProvider = SpeechProvider();
  Widget currentPage = RadioWidgetDemo();
  //
  @override
  void initState() {
    super.initState();
    speechProvider.initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.cyan,
          child: Icon(Icons.mic),
          onPressed: () {
            speechProvider.speechToText();
            _displayDialog(context);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomAppBar(),
    );
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
      color: Colors.deepPurpleAccent,
      shape: CircularNotchedRectangle(),
      notchMargin: 3,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _row(
                _materialButton('Home', Icons.home,
                    () => setState(() => currentPage = Dashboard())),
                _materialButton('Chat', Icons.chat,
                    () => setState(() => currentPage = Profile()))),
            _row(
              _materialButton('Idioma', Icons.language,
                  () => setState(() => currentPage = RadioWidgetDemo())),
              _materialButton('Ajustes', Icons.settings,
                  () => setState(() => currentPage = Settings())),
            ),
          ],
        ),
      ),
    );
  }

  Row _row(Widget a, Widget b) => Row(children: <Widget>[a, b]);

  _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(speechProvider.isListening.toString()),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                width: double.maxFinite,
                height: 300.0,
                child: StreamBuilder(
                  stream: speechProvider.wordStream,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return snapshot.hasData
                        ? Text(speechProvider.lastWords)
                        : Text('Test Speech to Text');
                  },
                )),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  if (!speechProvider.isListening) {
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  Widget _materialButton(String textButton, IconData icon, Function onPressed) {
    return MaterialButton(
        minWidth: 69,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              textButton,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        onPressed: onPressed);
  }

  @override
  void dispose() {
    speechProvider.dispose();
    super.dispose();
  }
}
