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
  Widget currentPage = RadioWidgetDemo();
  //
  @override
  void initState() {
    super.initState();
    speechProvider.initSpeechState(mounted);
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _materialButton('Home', Icons.home, onPressed: () {
                  setState(() => currentPage = Dashboard());
                }),
                _materialButton('Chat', Icons.chat, onPressed: () {
                  setState(() => currentPage = Profile());
                })
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _materialButton('Idioma', Icons.language, onPressed: () {
                  setState(() => currentPage = RadioWidgetDemo());
                }),
                _materialButton('Ajustes', Icons.settings, onPressed: () {
                  setState(() => currentPage = Settings());
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('ListView in Dialog'),
            content: Container(
              width: double.maxFinite,
              height: 300.0,
              child: StreamBuilder(
                stream: speechProvider.wordStream,
                builder: (_, snapshot){
                  return snapshot.hasData
                    ? Text(speechProvider.lastWords)
                    : Text('Test Speech to Text');
                },
              )
            ),
          );
        });
  }

  Widget _materialButton(String textButton, IconData icon,
      {Function onPressed}) {
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
