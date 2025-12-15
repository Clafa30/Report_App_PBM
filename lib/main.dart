import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override Widget build(BuildContext context) {
    return MaterialApp(
      title: "Re-App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LoginPage(),
    );
  }
}
