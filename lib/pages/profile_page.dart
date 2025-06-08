import 'package:flutter/material.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:piladea_web/pages/profileEdit_page.dart';

// import 'package:piladea_web/pages/profileEdit_page.dart';
import '../../Model/perfil.dart';

class ProfilePage extends StatefulWidget {
  final Perfil perfil;
  ProfilePage({Key? key, required this.perfil}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Perfil perfilLLave;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 251, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF74d4ff),
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(perfil: perfilLLave),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                _buildProfileImage(),
                _buildProfilDetails(),
                const SizedBox(
                  height: 100,
                ), // Espacio adicional para separar el botón del contenido
              ],
            ),
          ),
          Positioned(
            bottom: 20.0, // Ajusta la posición vertical del botón
            right: 20.0, // Ajusta la posición horizontal del botón
            child: _buildEditButton(context),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    perfilLLave = widget.perfil;
  }

  Widget _buildEditButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(perfil: perfilLLave),
          ),
        );
      },
      backgroundColor: Colors.blue,
      child: Icon(Icons.edit, color: Colors.black),
    );
  }

  Widget _buildInfoTile(String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }

  Widget _buildProfilDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${perfilLLave.nombre} ${perfilLLave.apellidos}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              _buildInfoTile("Nombre", perfilLLave.nombre!),
              _buildInfoTile("Apellido", perfilLLave.apellidos!),
              _buildInfoTile("Email", perfilLLave.correo!),
              _buildInfoTile("Contraseña", "********"),
              _buildInfoTile(
                "Fecha de Nacimiento",
                '${perfilLLave.fechaNacimiento.day}/${perfilLLave.fechaNacimiento.month}/${perfilLLave.fechaNacimiento.year}',
              ),
              _buildInfoTile("Género", perfilLLave.sexo!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: SizedBox(
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
    );
  }
}
