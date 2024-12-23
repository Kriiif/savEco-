import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting and parsing

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
  final TextEditingController dateController = TextEditingController();

  String type = 'Tetap';
  double tariff = 1444.70;

  void _addUsage() {
    final name = nameController.text.trim();
    final usage = int.tryParse(usageController.text.trim()) ?? 0;
    final duration = double.tryParse(durationController.text.trim()) ?? 0.0;
    final dateInput = dateController.text.trim();

    // Parse dan validasi input tanggal
    DateTime? date;
    if (dateInput.isNotEmpty) {
      try {
        date = DateFormat('dd-MM-yyyy').parseStrict(dateInput);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Format tanggal salah. Gunakan DD-MM-YYYY.')),
        );
        return;
      }
    }

    // Ambil tanggal hari ini
    final today = DateTime.now();
    final todayString = DateFormat('dd-MM-yyyy').format(today);

    // Validasi tanggal harus hari ini
    if (date != null && DateFormat('dd-MM-yyyy').format(date) != todayString) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tanggal harus sesuai dengan hari ini.')),
      );
      return;
    }

    // Validasi data lainnya sebelum input
    if (name.isNotEmpty && usage > 0 && duration > 0.0 && date != null) {
      final cost = (usage / 1000) * duration * tariff; // Kalkulasi biaya
      final newItem = {
        'name': name,
        'usage': usage,
        'duration': duration,
        'cost': cost,
        'category': type,
        'timestamp': DateTime.now(),
        'date': todayString, // Simpan tanggal hari ini
      };

      setState(() {
        if (type == 'Tetap') {
          widget.fixedUsage.add(newItem);
        } else {
          widget.additionalUsage.add(newItem);
        }
      });

      // Reset input form
      nameController.clear();
      usageController.clear();
      durationController.clear();
      dateController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua data harus diisi dengan benar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Pemakaian')),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(labelText: 'Tanggal (DD-MM-YYYY)'),
                    keyboardType: TextInputType.datetime,
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
          ),
        ),
      ),
    );
  }
}