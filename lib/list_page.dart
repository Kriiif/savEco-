import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListPage extends StatelessWidget {
  final List<Map<String, dynamic>> fixedItems;
  final List<Map<String, dynamic>> additionalItems;

  ListPage({required this.fixedItems, required this.additionalItems});

  String formatCurrency(dynamic cost) {
    return 'Rp${cost.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Perangkat Elektronik'),
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blue,
            tabs: <Widget>[
              Tab(
                text: 'Tetap',
                icon: Icon(Icons.lock),
              ),
              Tab(
                text: 'Tambahan',
                icon: Icon(Icons.add_circle),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Fixed usage list
            buildUsageList(fixedItems, Icons.lock, Colors.blue),
            // Additional usage list
            buildUsageList(additionalItems, Icons.add_circle, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget buildUsageList(List<Map<String, dynamic>> items, IconData icon, Color iconColor) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada perangkat dalam kategori ini.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
            title: Text(item['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penggunaan: ${item['usage']} watt'),

                Text('Biaya: '+ NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(item['cost']))
              ],
            ),
          ),
        );
      },
    );
  }
}