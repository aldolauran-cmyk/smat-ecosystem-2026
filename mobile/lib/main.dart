import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await AuthService().getToken();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: token != null ? HomePage() : LoginScreen(),
  ));
}
