import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../utils/helpers.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? currentUser;
  bool loading = true;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

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
      nameController.text = currentUser!.name;
      phoneController.text = currentUser!.phone;
    }

    setState(() => loading = false);
  }

  Future<void> updateProfile() async {
    if (currentUser == null) return;

    try {
      final res = await ApiService.updateProfile(
        userId: currentUser!.id.toString(),
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (res['status'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        currentUser = UserModel.fromJson(res['user']);
        prefs.setString('user', jsonEncode(currentUser!.toJson()));

        showSuccess(context, "Profil berhasil diperbarui");
      } else {
        showError(context, res['message'] ?? 'Gagal update profil');
      }
    } catch (e) {
      showError(context, "Terjadi kesalahan");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Profil")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // === AVATAR ===
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            SizedBox(height: 12),
            Text(
              currentUser?.name ?? "",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              currentUser?.phone ?? "",
              style: TextStyle(color: Colors.grey),
            ),

            SizedBox(height: 30),

            // === FORM CARD ===
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Nomor HP",
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      child: Text("Simpan Perubahan"),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // === LOGOUT ===
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: logout,
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
