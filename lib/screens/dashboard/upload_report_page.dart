import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';

class UploadReportPage extends StatefulWidget {
  final VoidCallback onUploaded;

  const UploadReportPage({Key? key, required this.onUploaded}) : super(key: key);

  @override
  State<UploadReportPage> createState() => _UploadReportPageState();
}

class _UploadReportPageState extends State<UploadReportPage> {
  final descController = TextEditingController();
  final picker = ImagePicker();

  File? beforeFile;
  File? afterFile;

  bool loading = false;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user');
    if (raw != null) {
      currentUser = UserModel.fromJson(jsonDecode(raw));
    }
  }

  Future<void> pickImage(bool isBefore) async {
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );

    if (picked != null) {
      setState(() {
        if (isBefore) {
          beforeFile = File(picked.path);
        } else {
          afterFile = File(picked.path);
        }
      });
    }
  }

  Future<void> submit() async {
    if (currentUser == null) {
      showError(context, "User belum login");
      return;
    }

    if (descController.text.trim().isEmpty) {
      showError(context, "Deskripsi wajib diisi");
      return;
    }

    setState(() => loading = true);

    try {
      final res = await ApiService.uploadReport(
        userId: currentUser!.id.toString(),
        description: descController.text.trim(),
        beforeFile: beforeFile,
        afterFile: afterFile,
      );

      setState(() => loading = false);

      if (res['status'] == 'success') {
        showSuccess(context, res['message']);
        widget.onUploaded();
        Navigator.pop(context);
      } else {
        showError(context, res['message'] ?? "Gagal upload");
      }
    } catch (e) {
      setState(() => loading = false);
      showError(context, "Terjadi kesalahan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Laporan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DESKRIPSI
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Deskripsikan masalah...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BEFORE IMAGE
            const Text("Foto Sebelum (opsional)"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => pickImage(true),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: beforeFile == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          beforeFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            /// AFTER IMAGE
            const Text("Foto Sesudah (opsional)"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => pickImage(false),
              child: Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: afterFile == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          afterFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            /// SUBMIT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: loading ? null : submit,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Laporan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
