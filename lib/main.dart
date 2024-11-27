import 'package:flutter/material.dart';
import 'dashboard_page.dart';

void main() {
  runApp(SavECOApp());
}

class SavECOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavECO!',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}