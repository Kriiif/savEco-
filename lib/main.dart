import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'app.dart';
import './login/login.dart';
import './welcome/welcome.dart';

void main() {
  runApp(SavECOApp());
}

class SavECOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}