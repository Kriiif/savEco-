import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'sum_page.dart';
import 'dash.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _FooterState();
}

class _FooterState extends State<Home> {
  int _curidx = 0;
  final GlobalKey<DashboardPageState> dashboardPageKey = GlobalKey<DashboardPageState>();

  // Define a dummy user name
  String userName = 'User'; // You can replace this with a dynamic user name if needed

  List<Widget> bods = [];

  @override
  void initState() {
    super.initState();
    bods = [
      // Pass the required parameters to DashboardPage
      DashboardPage(
        key: dashboardPageKey,
        fixedUsage: [],
        additionalUsage: [],
      ),
      HomePage(),
      const Center(
        child: Text(
          'Under\nMaintenance...',
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      SumPage(
        fixedUsage: dashboardPageKey.currentState?.widget.fixedUsage ?? [],
        additionalUsage: dashboardPageKey.currentState?.widget.additionalUsage ?? [],
        onSave: onSave,
      ),
      const Center(
        child: Text(
          'Under\nMaintenance...',
          style: TextStyle(
              color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  void onSave(List<Map<String, dynamic>> fixed, List<Map<String, dynamic>> additional) {
    if (dashboardPageKey.currentState != null) {
      dashboardPageKey.currentState?.onSave(fixed, additional);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('saveEco!')),
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
            label: 'Akun',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}