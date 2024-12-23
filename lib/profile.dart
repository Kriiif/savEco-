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
  File? _image;

  String formatCurrency(double value) {
    final format = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(value);
  }

  void onSave(List<Map<String, dynamic>> fixed,
      List<Map<String, dynamic>> additional) {
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

  Future<Map<String, dynamic>> getPemakaianHariIni() async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final allUsage = [
      ...widget.fixedUsage.where((item) => item['date'] == today),
      ...widget.additionalUsage.where((item) => item['date'] == today),
    ];

    allUsage.sort((a, b) =>
        (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime));

    int totalWatt = allUsage.fold(
        0, (sum, item) => sum + (item['usage'] as int? ?? 0));
    double totalCost = allUsage.fold(
        0.0, (sum, item) => sum + (item['cost'] as double? ?? 0.0));

    return {'totalWatt': totalWatt, 'totalCost': totalCost};
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan tanggal hari ini dan kemarin
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final yesterday = DateFormat('dd-MM-yyyy')
        .format(DateTime.now().subtract(const Duration(days: 1)));

    // Filter data untuk tanggal hari ini
    List<Map<String, dynamic>> todayData = [
      ...widget.fixedUsage.where((item) => item['date'] == today),
      ...widget.additionalUsage.where((item) => item['date'] == today),
    ];

    // Hitung total watt dan biaya untuk hari ini
    int todayTotalWatt = todayData.fold(
        0, (sum, item) => sum + (item['usage'] as int? ?? 0));
    double todayTotalCost = todayData.fold(
        0.0, (sum, item) => sum + (item['cost'] as double? ?? 0.0));

    // Filter data untuk tanggal kemarin
    List<Map<String, dynamic>> yesterdayData = [
      ...widget.fixedUsage.where((item) => item['date'] == yesterday),
      ...widget.additionalUsage.where((item) => item['date'] == yesterday),
    ];

    // Hitung total watt dan biaya untuk kemarin
    int yesterdayTotalWatt = yesterdayData.fold(
        0, (sum, item) => sum + (item['usage'] as int? ?? 0));
    double yesterdayTotalCost = yesterdayData.fold(
        0.0, (sum, item) => sum + (item['cost'] as double? ?? 0.0));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bagian Profil User
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
                // Foto Profil
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
                // Nama Pengguna
                Center(
                  child: Text(
                    widget.username,
                    style: const TextStyle(
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
          // Bagian Rekap Harian
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
                // Menampilkan Tanggal Hari Ini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      todayData.isNotEmpty ? today : 'No data available',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Menampilkan Pemakaian Hari Ini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pemakaian Hari Ini:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$todayTotalWatt Watt',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Menampilkan Total Biaya Hari Ini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Biaya:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatCurrency(todayTotalCost),
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // Bagian Rekap Kemarin
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
                  'Rekap Kemarin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Menampilkan Tanggal Kemarin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Date:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      yesterdayData.isNotEmpty
                          ? yesterday
                          : 'No data available',
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Menampilkan Pemakaian Kemarin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pemakaian Kemarin:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$yesterdayTotalWatt Watt',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Menampilkan Total Biaya Kemarin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Biaya:',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatCurrency(yesterdayTotalCost),
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}