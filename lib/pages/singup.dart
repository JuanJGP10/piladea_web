import 'package:flutter/material.dart';
import 'package:piladea_web/Authentication/structures/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/imagen_aleatoria.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';

class SignupView extends StatefulWidget {
  static String id = 'signup_view';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignupView> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthController();

  String? selectedOption;
  DateTime? selectedDate;

  final List<String> opciones = ['Masculino', 'Femenino', 'Otro', 'No binario'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void register() async {
    try {
      await authService.registerwithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (passwordController.text.length > 6) {
        PerfilCRUD p = PerfilCRUD();

        Perfil? p1 = p.crearPerfil(
          ImagenesAleatorias().obtenerRutaImagenAleatoria(),
          nameController.text,
          lastNameController.text,
          emailController.text,
          selectedOption,
          selectedDate!,
        );

        await p.addPerfil(p1);
        await PerfilCRUD.instance.findPerfil(p1!.uID!);

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña no es válida (>6 caracteres)'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firebase Error: ${e.message}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.03,
            ),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Crear usuario',
                  style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(
                        blurRadius: 15.0,
                        color: Colors.purpleAccent,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildStyledTextField(nameController, 'Nombre'),
                const SizedBox(height: 15),
                _buildStyledTextField(lastNameController, 'Apellido'),
                const SizedBox(height: 15),
                _buildStyledTextField(emailController, 'Email'),
                const SizedBox(height: 15),
                _buildStyledTextField(
                  passwordController,
                  'Contraseña',
                  obscure: true,
                ),
                const SizedBox(height: 15),
                _buildDropdownField(),
                const SizedBox(height: 15),
                _buildDateField(),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return SizedBox(
      height: 60,
      width: 600,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return SizedBox(
      height: 60,
      width: 600,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Género',
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        dropdownColor: Colors.black87,
        value: selectedOption,
        items: opciones.map((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(op, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => selectedOption = value);
        },
      ),
    );
  }

  Widget _buildDateField() {
    return SizedBox(
      height: 60,
      width: 600,
      child: InkWell(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Fecha de Nacimiento',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            border: OutlineInputBorder(),
          ),
          child: Text(
            selectedDate == null
                ? 'Seleccionar fecha'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            style: TextStyle(
              color: selectedDate == null ? Colors.grey[600] : Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
