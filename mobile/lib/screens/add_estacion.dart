import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Importante para que conecte con la lógica

class AddEstacionScreen extends StatefulWidget {
  @override
  _AddEstacionScreenState createState() => _AddEstacionScreenState();
}

class _AddEstacionScreenState extends State<AddEstacionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _ubicacionController = TextEditingController();

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      // Llamamos al servicio que creamos antes
      bool success = await ApiService().crearEstacion(
        _nombreController.text,
        _ubicacionController.text
      );

      if (success) {
        Navigator.pop(context, true); // Regresa al Dashboard si todo salió bien
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: No autorizado o Servidor caído')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Estación')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre de la Estación'),
                validator: (v) => v!.isEmpty ? 'El nombre es requerido' : null,
              ),
              TextFormField(
                controller: _ubicacionController,
                decoration: InputDecoration(labelText: 'Ubicación / Ciudad'),
                validator: (v) => v!.isEmpty ? 'La ubicación es requerida' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardar, 
                child: Text('Guardar Estación')
              )
            ],
          ),
        ),
      ),
    );
  }
}
