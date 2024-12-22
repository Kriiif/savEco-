import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class ProfileUser extends StatefulWidget {
  ProfileUser({super.key, required this.fixedUsage, required this.additionalUsage, required this.username});
  final List<Map<String, dynamic>> fixedUsage;
  final List<Map<String, dynamic>> additionalUsage;
  final String username;

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? _image; // Variabel untuk menyimpan gambar
  String formatCurrency(double value) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(value);
  }

  void onSave(List<Map<String, dynamic>> fixed, List<Map<String, dynamic>> additional) {
    setState(() {
      widget.fixedUsage.addAll(fixed);
      widget.additionalUsage.addAll(additional);
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allUsage = [
      ...widget.fixedUsage,
      ...widget.additionalUsage,
    ];

    allUsage.sort((a, b) => (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    List<Map<String, dynamic>> recentlyAdded = allUsage.take(2).toList();

    int totalWatt = widget.fixedUsage.fold(0, (sum, item) {
      final usage = item['usage'] is int ? item['usage'] as int : 0;
      return sum + usage;
    }) + widget.additionalUsage.fold(0, (sum, item) {
      final usage = item['usage'] is int ? item['usage'] as int : 0;
      return sum + usage;
    });

    double totalCost = widget.fixedUsage.fold(0.0, (sum, item) {
      final cost = item['cost'] is double ? item['cost'] as double : 0.0;
      return sum + cost;
    }) + widget.additionalUsage.fold(0.0, (sum, item) {
      final cost = item['cost'] is double ? item['cost'] as double : 0.0;
      return sum + cost;
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: _image != null
                        ? Image.file(
                      _image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                        : const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    '${widget.username}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Select Image'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  'Rekap Harian',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      recentlyAdded.isNotEmpty
                          ? recentlyAdded.first['date']
                          : 'No data available',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pemakaian Hari Ini:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$totalWatt Watt',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Biaya:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatCurrency(totalCost),
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}