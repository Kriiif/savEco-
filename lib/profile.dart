import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  File? _image; // Variabel untuk menyimpan gambar

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Menyimpan gambar yang dipilih
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( 
        child: Container(
          width: MediaQuery.of(context).size.width * 1.0, 
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(16), 
          ),
          child: Column(
            children: [
            const SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width * 0.22, // Lebar 22% dari layar
              padding: const EdgeInsets.all(16), 
              child: Card(
                elevation: 5, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), 
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.22, // Lebar 22% dari layar
                  padding: const EdgeInsets.all(16), 
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      _image != null
                          ? Image.file(
                              _image!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover, // Menyesuaikan gambar dengan ukuran
                            )
                          : const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _pickImage, // Fungsi untuk memilih gambar
                        child: const Text('Select Image'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text("Penggunaan Listrik",   style: TextStyle(color: Colors.white)),
                      Text("2330 watt",   style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(width: 200),
                  Column(
                    children: const [
                      Text("Biaya Penggunaan",   style: TextStyle(color: Colors.white)),
                      Text("Rp3580000",   style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            )
          ],
          ),
        ),
      ),
    );
  }
}
