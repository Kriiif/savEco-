import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'insight.dart';
import 'sum_page.dart';
import 'list_page.dart';
import 'profile.dart';
import 'package:saveco_project/controller/database_helper.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.username, required this.userId}) : super(key: key);
  final String username;
  final int userId;

  @override
  State<Home> createState() => _FooterState();
}

class _FooterState extends State<Home> {
  int _curidx = 0;
  final GlobalKey<DashboardPageState> dashboardPageKey = GlobalKey<DashboardPageState>();

  // Define a dummy user name
  String userName = 'User'; // You can replace this with a dynamic user name if needed

  List<Map<String, dynamic>> fixedUsage = [];
  List<Map<String, dynamic>> additionalUsage = [];

  List<Widget> bods = [];

  @override
  void initState() {
    super.initState();
    bods = [
      // Pass the required parameters to DashboardPage
      DashboardPage(
        key: dashboardPageKey,
        fixedUsage: fixedUsage,
        additionalUsage: additionalUsage,
        username: widget.username,
        userId: widget.userId,
      ),
      ListPage(
        fixedItems: fixedUsage,
        additionalItems: additionalUsage,
      ),
      const InsightSection(

      ),
      SumPage(
        fixedUsage: fixedUsage,
        additionalUsage: additionalUsage,
        onSave: onSave,
        userId: widget.userId,
      ),
      ProfileUser(
        fixedUsage: fixedUsage,
        additionalUsage: additionalUsage,
        username: widget.username,
      ),
    ];
  }

  void onSave(List<Map<String, dynamic>> fixed, List<Map<String, dynamic>> additional) {
    setState(() {
      fixedUsage = fixed;
      additionalUsage = additional;
      _curidx = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/savecooo.png', // Replace with your image's path
          height: 40, // Adjust height as needed
        ), // Optional: Centers the image
      ),
      body: bods[_curidx],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int newidx) {
          setState(() {
            _curidx = newidx;
          });
        },
        currentIndex: _curidx,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insight',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Sum',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}