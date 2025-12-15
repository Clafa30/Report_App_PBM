import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/auth/login_page.dart';
import '../screens/profile_page.dart';
import '../screens/history_page.dart';
import '../screens/manage_user_page.dart';
import '../screens/dashboard/dashboard_page.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  /// LOGOUT FUNCTION
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // HAPUS SEMUA DATA LOGIN

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false, // HAPUS SEMUA ROUTE
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 105,
                ),
              ],
            ),
          ),

          _tile(context, Icons.home, "Dashboard", DashboardPage()),
          _tile(context, Icons.person, "Profile", ProfilePage()),
          _tile(context, Icons.history, "Riwayat", HistoryPage()),
          _tile(context, Icons.group, "Manage User", ManageUserPage()),

          const Spacer(),

          /// LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // tutup drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }
}
