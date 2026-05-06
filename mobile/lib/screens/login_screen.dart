import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  void _entrar() async {
    bool success = await AuthService().login(_userController.text, _passController.text);
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error de acceso")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login SMAT")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _userController, decoration: InputDecoration(labelText: "Usuario")),
            TextField(controller: _passController, decoration: InputDecoration(labelText: "Clave"), obscureText: true),
            ElevatedButton(onPressed: _entrar, child: Text("Ingresar"))
          ],
        ),
      ),
    );
  }
}
