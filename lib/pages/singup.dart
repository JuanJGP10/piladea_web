import 'package:flutter/material.dart';
import 'package:C/'
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupView extends StatefulWidget {
  static String id= 'signup_view';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignupView> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  String? selectedOption;
  DateTime? selectedDate;

  // Lista para el ComboBox
  final List<String> opciones = ['Masculino', 'Femenino', 'Otro', 'No binario'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void register() async {
    try {
      await authService.registerWithEmailPassword(
        name: nameController.text.trim(),
        apellido: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        Gender: selectedOption.toString().trim(),
        fechaNacimiento:  selectedDate.toString().trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario registrado exitosamente')),
      );
    } on FirebaseException catch (e) {
      // Manejo específico para Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firebase Error: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear usuario'), titleTextStyle: TextStyle(color: Colors.purple,fontSize: 30,),centerTitle: true, backgroundColor: Colors.black12,),

      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: nameController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Nombre',labelStyle: TextStyle(color: Colors.white)),),
            TextField(controller: lastNameController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Apellido',labelStyle: TextStyle(color: Colors.white))),
            TextField(controller: emailController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.white))),
            TextField(controller: passwordController,style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: 'Contraseña',labelStyle: TextStyle(color: Colors.white)), obscureText: true),
            // ComboBox
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Genero', filled: true, fillColor: Colors.black12),
              value: selectedOption,
              dropdownColor: Colors.black87,
              items: opciones
                  .map((op) => DropdownMenuItem(

                value: op,

                child: Text(op,style: TextStyle(color: Colors.white)),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),

            // Date Picker
            SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedDate == null
                      ? 'Seleccionar fecha'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  style: TextStyle(
                      color: selectedDate == null
                          ? Colors.grey[600]
                          : Colors.black87),
                ),
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(onPressed: register, child: Text('Registrarse')),
          ],
        ),
      ),
    );
  }
}
