import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/helpers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final nameC = TextEditingController();
  final phoneC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();
  bool isLoading = false;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    if (passC.text != confirmC.text) {
      showError(context, "Password tidak sama");
      return;
    }

    setState(() => isLoading = true);
    try {
      final res = await ApiService.register(
        nameC.text.trim(),
        phoneC.text.trim(),
        passC.text.trim(),
      );

      if (res['status'] == 'success') {
        showSuccess(context, "Registrasi berhasil");
        Navigator.pop(context);
      } else {
        showError(context, res['message']);
      }
    } catch (e) {
      showError(context, "Terjadi kesalahan server");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF020617), Color(0xFF0F172A)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [

                        const SizedBox(height: 40),
                        const Text(
                          "Daftar Akun",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                        const SizedBox(height: 40),

                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF020617),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [

                                _field(nameC, "Nama Lengkap"),
                                _gap(),
                                _field(phoneC, "Nomor HP"),
                                _gap(),
                                _field(passC, "Password", true),
                                _gap(),
                                _field(confirmC, "Konfirmasi Password", true),

                                const SizedBox(height: 24),

                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed:
                                        isLoading ? null : register,
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text("Daftar"),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "Kembali ke Login",
                                    style:
                                        TextStyle(color: Colors.white70),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _field(TextEditingController c, String h,
      [bool obs = false]) {
    return TextFormField(
      controller: c,
      obscureText: obs,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: h,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (v) =>
          v == null || v.isEmpty ? "$h wajib" : null,
    );
  }

  Widget _gap() => const SizedBox(height: 14);
}
