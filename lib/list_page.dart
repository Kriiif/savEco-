import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  ListPage({required this.items});

  String formatCurrency(dynamic cost) {
    return 'Rp${cost.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Perangkat Elektronik'),
      ),
      body: items.isEmpty
          ? Center(
        child: Text(
          'Belum ada perangkat yang diinput.',
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Icon(
                item['category'] == 'Tetap' ? Icons.lock : Icons.add_circle,
                size: 40,
                color: item['category'] == 'Tetap' ? Colors.blue : Colors.green,
              ),
              title: Text(item['name']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Penggunaan: ${item['usage']} watt'),
                  Text('Biaya: ${formatCurrency(item['cost'])}'),
                  Text('Kategori: ${item['category']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}