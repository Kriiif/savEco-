import 'package:flutter/material.dart';
import 'package:saveco_project/dashboard_page.dart';

class SumPage extends StatefulWidget {
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;
  final Function(List<Map<String, dynamic>>, List<Map<String, dynamic>>) onSave;

  SumPage({
    required this.fixedUsage,
    required this.additionalUsage,
    required this.onSave,
  });

  @override
  _SumPageState createState() => _SumPageState();
}

class _SumPageState extends State<SumPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String type = 'Tetap';
  double tariff = 1444.70;

  void _addUsage() {
    final name = nameController.text.trim();
    final usage = int.tryParse(usageController.text.trim()) ?? 0;
    final duration = double.tryParse(durationController.text.trim()) ?? 0.0;

    if (name.isNotEmpty && usage > 0 && duration > 0.0) {
      final cost = (usage / 1000) * duration * tariff;
      final newItem = {
        'name': name,
        'usage': usage,
        'duration': duration,
        'cost': cost,
        'category': type,
        'timestamp': DateTime.now(), // Add timestamp
      };

      setState(() {
        if (type == 'Tetap') {
          widget.fixedUsage.add(newItem);
        } else {
          widget.additionalUsage.add(newItem);
        }
      });

      nameController.clear();
      usageController.clear();
      durationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Pemakaian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: type,
              items: ['Tetap', 'Tambahan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Perangkat'),
            ),
            TextField(
              controller: usageController,
              decoration: const InputDecoration(labelText: 'Penggunaan (Watt)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Durasi Pemakaian (jam)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUsage,
              child: const Text('Tambah'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSave(widget.fixedUsage, widget.additionalUsage);
              },
              child: const Text('Simpan dan Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}