import 'package:flutter/material.dart';
import 'dashboard_page.dart';

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
  late List<Map<String, dynamic>> fixedUsage;
  late List<Map<String, dynamic>> additionalUsage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String type = 'Tetap';
  double tariff = 1444.70; // Tarif listrik per kWh (Rp)

  @override
  void initState() {
    super.initState();
    fixedUsage = List.from(widget.fixedUsage);
    additionalUsage = List.from(widget.additionalUsage);
  }

  void _addUsage() {
    final name = nameController.text.trim();
    final usage = int.tryParse(usageController.text.trim()) ?? 0; // Watt
    final duration = double.tryParse(durationController.text.trim()) ?? 0.0; // Jam

    if (name.isNotEmpty && usage > 0 && duration > 0.0) {
      final cost = (usage / 1000) * duration * tariff; // Hitung biaya listrik
      final newItem = {
        'name': name,
        'usage': usage,
        'duration': duration,
        'cost': cost,
        'category': type,
      };

      setState(() {
        if (type == 'Tetap') {
          fixedUsage.add(newItem);
        } else {
          additionalUsage.add(newItem);
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
              decoration: InputDecoration(labelText: 'Nama Perangkat'),
            ),
            TextField(
              controller: usageController,
              decoration: InputDecoration(labelText: 'Penggunaan (Watt)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Durasi Pemakaian (jam)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUsage,
              child: Text('Tambah'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSave(fixedUsage, additionalUsage);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage(fixedUsage: fixedUsage, additionalUsage: additionalUsage)),
                );// Correct navigation to return to DashboardPage
              },
              child: Text('Simpan dan Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}