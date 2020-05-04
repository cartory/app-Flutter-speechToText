import 'package:flutter/material.dart';

import 'package:appstt/src/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speech To Text',
      home: Home(),
      theme: ThemeData(  
        primaryColor: Colors.deepPurpleAccent
      ),
    );
  }
}
/**
 * StreamBuilder(
          stream: NaturalLanguageProvider.instance.jsonStream,
          builder: (_, AsyncSnapshot<Map<String, Object>> snapshot) {
            return snapshot.hasData
                ? displayJson(snapshot.data)
                : Center(child: Text('Esperando voz...'));
          }),
 */