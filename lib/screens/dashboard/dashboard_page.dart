import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/report_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../widgets/report_card.dart';
import '../../widgets/sidebar_drawer.dart';
import 'upload_report_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserModel? currentUser;
  List<ReportModel> reports = [];
  bool loading = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('user');

    if (raw == null) {
      setState(() => loading = false);
      return;
    }

    currentUser = UserModel.fromJson(jsonDecode(raw));

    final res = await ApiService.getReports(currentUser!.id);

    if (res['status'] == 'success') {
      reports = (res['reports'] as List)
          .map((e) => ReportModel.fromJson(e))
          .toList();
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,

      /// DRAWER
      endDrawer: const SidebarDrawer(),

      /// APP BAR
        appBar: AppBar(
          backgroundColor: const Color(0xFF020617),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Dashboard",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

      /// FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadReportPage(onUploaded: loadReports),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      /// BODY
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF020617), Color(0xFF0F172A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : RefreshIndicator(
                onRefresh: loadReports,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: reports.isEmpty
                      ? const [
                          SizedBox(height: 80),
                          Center(
                            child: Text(
                              "Belum ada laporan",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]
                      : reports
                          .map<Widget>(
                              (r) => ReportCard(report: r))
                          .toList(),
                ),
              ),
      ),
    );
  }
}
