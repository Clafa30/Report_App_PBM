import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/comment_model.dart';
import '../models/report_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class CommentSheet extends StatefulWidget {
  final ReportModel report;

  const CommentSheet({super.key, required this.report});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  final TextEditingController controller = TextEditingController();

  List<CommentModel> comments = [];
  UserModel? currentUser;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// ================= INIT =================
  Future<void> _init() async {
    await loadUser();
    await loadComments();
  }

  /// ================= LOAD USER =================
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user');

    if (raw != null) {
      currentUser = UserModel.fromJson(jsonDecode(raw));
    }
  }

  /// ================= LOAD COMMENTS =================
  Future<void> loadComments() async {
    try {
      setState(() => loading = true);

      final res = await ApiService.getComments(widget.report.id);

      if (res['status'] == 'success') {
        comments = (res['comments'] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();
      } else {
        comments = [];
      }
    } catch (e) {
      debugPrint("ERROR LOAD COMMENTS: $e");
      comments = [];
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  /// ================= SEND COMMENT =================
  Future<void> send() async {
    if (controller.text.trim().isEmpty || currentUser == null) return;

    final res = await ApiService.sendComment(
      reportId: widget.report.id,
      userId: currentUser!.id,
      comment: controller.text.trim(),
    );

    if (res['status'] == 'success') {
      controller.clear();
      await loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF020617),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [

            /// HANDLE DRAG
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const Text(
              "Komentar",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 16),

            /// ================= LIST KOMENTAR =================
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : comments.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada komentar",
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (_, i) {
                            final c = comments[i];
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child:
                                    Icon(Icons.person, color: Colors.white),
                              ),
                              title: Text(
                                c.userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                c.comment,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            );
                          },
                        ),
            ),

            /// ================= INPUT KOMENTAR =================
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Tulis komentar...",
                      hintStyle:
                          const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0F172A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: send,
                  icon: const Icon(Icons.send,
                      color: Colors.indigoAccent),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

