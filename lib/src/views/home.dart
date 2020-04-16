import 'package:flutter/material.dart';

import 'package:appstt/src/models/language_model.dart';
import 'package:appstt/src/providers/speech_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SpeechProvider speechProvider = SpeechProvider();
  Widget currentPage = Container();
  int currentIndex = 0;

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
          backgroundColor: Colors.deepPurpleAccent,
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
          .map((l) => CheckedPopupMenuItem<Language>(
                value: l,
                checked: speechProvider.language == l,
                child: Text(l.name),
              ))
          .toList();

  Widget _bottomAppBar() {
    return BottomAppBar(
      color: Colors.white70,
      shape: CircularNotchedRectangle(),
      notchMargin: 3,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _row(
                _materialButton(
                    'Inicio',
                    Icons.home,
                    currentIndex == 0,
                    () => setState(() {
                          currentIndex = 0;
                          currentPage = Container();
                        })),
                _materialButton(
                    'Ayuda',
                    Icons.help,
                    currentIndex == 1,
                    () => setState(() {
                          currentIndex = 1;
                          currentPage = Container(color: Colors.yellowAccent);
                        }))),
            _row(
              _materialButton(
                  'Perfil',
                  Icons.account_circle,
                  currentIndex == 2,
                  () => setState(() {
                        currentIndex = 2;
                        currentPage = Container(color: Colors.greenAccent);
                      })),
              _materialButton(
                  'Ajustes',
                  Icons.settings,
                  currentIndex == 3,
                  () => setState(() {
                        currentIndex = 3;
                        currentPage = Container(color: Colors.cyanAccent);
                      })),
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
                height: 250,
                child: StreamBuilder(
                  stream: speechProvider.wordStream,
                  builder: (_, snapshot) {
                    return snapshot.hasData
                        ? Center(child: Text(speechProvider.lastWords))
                        : Center(child: Text('Esperando Voz...'));
                  },
                )),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
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

  Widget _materialButton(String textButton, IconData icon, bool selected, Function onPressed) {
    
    final color = selected ? Colors.deepPurpleAccent : Colors.black45;
    return MaterialButton(
        minWidth: 69,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: color
            ),
            Text(
              textButton,
              style: TextStyle(
                  color: color),
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
