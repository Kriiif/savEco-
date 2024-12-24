import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saveco_project/controller/database_helper.dart';

class SumPage extends StatefulWidget {
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;
  final Function(List<Map<String, dynamic>>, List<Map<String, dynamic>>) onSave;
  final int userId;

  SumPage({
    required this.fixedUsage,
    required this.additionalUsage,
    required this.onSave,
    required this.userId,
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
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // Set default date to today
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  bool _isValidDate(String input) {
    try {
      DateFormat('dd-MM-yyyy').parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _clearForm() {
    nameController.clear();
    usageController.clear();
    durationController.clear();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  void _addUsage() async {
    // Validate input
    if (!_validateInput()) return;

    final name = nameController.text.trim();
    final usage = int.parse(usageController.text.trim());
    final duration = double.parse(durationController.text.trim());
    final dateInput = dateController.text.trim();

    // Calculate cost
    final cost = (usage / 1000) * duration * tariff;

    // Prepare data
    final newItem = {
      'name': name,
      'usage': usage,
      'duration': duration,
      'cost': cost,
      'date': dateInput,
      'category': type,
    };

    try {
      int id;
      if (type == 'Tetap') {
        id = await dbHelper.insertFixedUsage(newItem, widget.userId);
        newItem['id'] = id;
        setState(() {
          widget.fixedUsage.add(newItem);
        });
      } else {
        id = await dbHelper.insertAdditionalUsage(newItem, widget.userId);
        newItem['id'] = id;
        setState(() {
          widget.additionalUsage.add(newItem);
        });
      }

      widget.onSave(widget.fixedUsage, widget.additionalUsage);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan!')),
      );
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _validateInput() {
    if (nameController.text.trim().isEmpty) {
      _showError('Nama perangkat harus diisi');
      return false;
    }

    if (usageController.text.trim().isEmpty) {
      _showError('Penggunaan (Watt) harus diisi');
      return false;
    }

    if (durationController.text.trim().isEmpty) {
      _showError('Durasi pemakaian harus diisi');
      return false;
    }

    if (!_isValidDate(dateController.text.trim())) {
      _showError('Format tanggal tidak valid (DD-MM-YYYY)');
      return false;
    }

    try {
      int usage = int.parse(usageController.text.trim());
      if (usage <= 0) {
        _showError('Penggunaan harus lebih dari 0');
        return false;
      }
    } catch (e) {
      _showError('Penggunaan harus berupa angka');
      return false;
    }

    try {
      double duration = double.parse(durationController.text.trim());
      if (duration <= 0) {
        _showError('Durasi harus lebih dari 0');
        return false;
      }
    } catch (e) {
      _showError('Durasi harus berupa angka');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Pemakaian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: type,
                    decoration: const InputDecoration(
                      labelText: 'Jenis Pemakaian',
                      border: OutlineInputBorder(),
                    ),
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
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Perangkat',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: usageController,
                    decoration: const InputDecoration(
                      labelText: 'Penggunaan (Watt)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: durationController,
                    decoration: const InputDecoration(
                      labelText: 'Durasi Pemakaian (jam)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal (DD-MM-YYYY)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _addUsage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Tambah Data'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      widget.onSave(widget.fixedUsage, widget.additionalUsage);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usageController.dispose();
    durationController.dispose();
    dateController.dispose();
    super.dispose();
  }
}