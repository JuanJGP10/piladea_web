import 'package:flutter/material.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/pages/profile_page.dart';

import '../../Controller/perfil_CRUD.dart';

class EditProfileScreen extends StatefulWidget {
  final Perfil perfil;
  EditProfileScreen({Key? key, required this.perfil}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Perfil perfilLLave;
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtLastName = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? selectedGender;

  @override
  void initState() {
    super.initState();
    perfilLLave = widget.perfil;
    txtFirstName.text = perfilLLave.nombre!;
    txtLastName.text = perfilLLave.apellidos!;
    selectedDate = perfilLLave.fechaNacimiento;
    selectedGender = perfilLLave.sexo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 251, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF74d4ff),
        title: const Text(
          'Editar Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [const SizedBox(height: 10), _buildProfileDetailsForm()],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: () {
        // Implementar lógica para cambiar la foto de perfil
      },
      child: Center(
        child: Stack(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: ClipOval(
                child: Image.asset(
                  '${perfilLLave.rutaImagen}',
                  fit: BoxFit.fitWidth,
                  scale: 1,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF74d4ff),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.camera_alt, color: Colors.black, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildProfileDetailsForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildProfileImage(), // Imagen centrada como en la vista de perfil
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  controller: txtFirstName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Apellido',
                    labelStyle: TextStyle(fontSize: 16),
                  ),
                  controller: txtLastName,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: perfilLLave.correo,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: '********',
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    enabled: false,
                    labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText:
                          '${perfilLLave.fechaNacimiento.day}/${perfilLLave.fechaNacimiento.month}/${perfilLLave.fechaNacimiento.year}',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Género: ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: selectedGender,
                        icon: selectedGender != null
                            ? null
                            : const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        items:
                            <String>[
                              'Masculino',
                              'Femenino',
                              'No binario',
                              'Prefiero no decirlo',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF74d4ff),
                  ),
                  onPressed: () async {
                    Perfil p1 = Perfil.sinFechaCreacion(
                      admin: false,
                      nombre: txtFirstName.text,
                      apellidos: txtLastName.text,
                      correo: perfilLLave.correo,
                      fechaNacimiento: selectedDate,
                      sexo: selectedGender,
                      rutaImagen: perfilLLave.rutaImagen,
                      uID: perfilLLave.uID,
                    );
                    await PerfilCRUD.instance.updatePerfil(
                      perfilLLave.docID,
                      p1,
                    );
                    perfilLLave = p1;
                    PerfilCRUD.currentProfile = p1;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(perfil: perfilLLave),
                      ),
                    );
                  },
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
