import 'package:appstt/src/providers/speech_provider.dart';
import 'package:appstt/src/views/pages/dashboard.dart';
import 'package:appstt/src/views/pages/language.dart';
import 'package:appstt/src/views/pages/profile.dart';
import 'package:appstt/src/views/pages/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // 
  SpeechProvider speechProvider = SpeechProvider();
  
  static int currentTab = 0;
  Widget currentScreen = Dashboard();

  // 
  @override
  void initState() {
    super.initState();
    speechProvider.initSpeechState(mounted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(), 
        child: currentScreen
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.mic),
          onPressed: () => speechProvider.speechToText()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomAppBar(),
    );
  }

  Widget _bottomAppBar() {
    return BottomAppBar(
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
                _materialButton('Home', Icons.dashboard),
                _materialButton('Chat', Icons.chat)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _materialButton('Perfil', Icons.account_box),
                _materialButton('Ajustes', Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _materialButton(String textButton, IconData icon) {
    return MaterialButton(
        minWidth: 69,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.blue,
            ),
            Text(
              textButton,
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        onPressed: () {});
  }

  @override
  void dispose() {
    speechProvider.dispose();
    super.dispose();
  }
}

class Chat {
}
