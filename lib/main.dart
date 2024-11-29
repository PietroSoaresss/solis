import 'package:flutter/material.dart';
import 'tela_login.dart';
import 'caixinhas.dart';
import 'tela_principal.dart';

void main() {
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Meu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: TelaLogin(),
      debugShowCheckedModeBanner: false,
    );
  }
}
