import 'package:flutter/material.dart';

import 'package:appstt/src/models/language_model.dart';
import 'package:appstt/src/providers/speech_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //
  SpeechProvider speechProvider = SpeechProvider();
  // SpeechProvider speechProvider = SpeechProvider();
  Widget currentPage = Container();
  //
  @override
  void initState() {
    super.initState();
    speechProvider.initSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech to Text App'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<Language>(
            onSelected: _selectLang,
            itemBuilder: (context) => _buildLanguagesWidgets,
          ),
        ],
      ),
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

  _selectLang(Language lang) => setState(() => speechProvider.lang = lang);

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets =>
      Language.languages
          .map((l) => new CheckedPopupMenuItem<Language>(
                value: l,
                checked: speechProvider.language == l,
                child: new Text(l.name),
              ))
          .toList();

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
                _materialButton('Inicio', Icons.home,
                    () => setState(() => currentPage = Container())),
                _materialButton(
                    'Ayuda',
                    Icons.help,
                    () => setState(() =>
                        currentPage = Container(color: Colors.yellowAccent)))),
            _row(
              _materialButton(
                  'Perfil',
                  Icons.account_circle,
                  () => setState(() =>
                      currentPage = Container(color: Colors.greenAccent))),
              _materialButton(
                  'Ajustes',
                  Icons.settings,
                  () => setState(
                      () => currentPage = Container(color: Colors.cyanAccent))),
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
            title: Center(
                child: Text('Escuchando en ${speechProvider.language.name}')),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                width: double.maxFinite,
                height: 300.0,
                child: StreamBuilder(
                  stream: speechProvider.wordStream,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return snapshot.hasData
                        ? Center(child: Text(speechProvider.lastWords))
                        : Center(child: Text('Esperando Voz'));
                  },
                )),
            actions: <Widget>[
              FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  if (!speechProvider.isListening) {
                    speechProvider.cancelSpeech();
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
