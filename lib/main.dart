import 'package:flutter/material.dart';
import 'package:Todo_App2/screens/sign_in.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
          const Locale('en', 'US'), // English
    ],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignIn(),
      ),
    );
  }
}
