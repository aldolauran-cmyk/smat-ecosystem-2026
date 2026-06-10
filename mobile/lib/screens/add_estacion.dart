import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddEstacionScreen extends StatefulWidget {
  const AddEstacionScreen({super.key});
  @override
  State<AddEstacionScreen> createState() => _AddEstacionScreenState();
}

class _AddEstacionScreenState extends State<AddEstacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _ubiController = TextEditingController();

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      bool ok = await ApiService().crearEstacion(_nomController.text, _ubiController.text);
      if (ok) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Estación')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(controller: _nomController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextFormField(controller: _ubiController, decoration: const InputDecoration(labelText: 'Ubicación')),
              ElevatedButton(onPressed: _guardar, child: const Text('Guardar'))
            ],
          ),
        ),
      ),
    );
  }
}
