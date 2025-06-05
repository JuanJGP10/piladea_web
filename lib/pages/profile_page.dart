import 'package:flutter/material.dart';
// import 'package:piladea_web/pages/profileEdit_page.dart';

import '../../Controller/perfil_CRUD.dart';
import '../../Model/perfil.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  Perfil p = rellenarPerfil() as Perfil;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Perfil',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
          // Positioned(
          //   bottom: 20.0, // Ajusta la posición vertical del botón
          //   right: 20.0, // Ajusta la posición horizontal del botón
          //   child: _buildEditButton(context),
          // ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: ClipOval(
          child: Image.asset('${p.rutaImagen}', fit: BoxFit.fitWidth, scale: 1),
        ),
      ),
    );
  }

  Widget _buildProfilDetails() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            '${p.nombre} ${p.apellidos}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text(
              "Nombre",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text('${p.nombre}', style: const TextStyle(fontSize: 16)),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Apellido",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text(
              '${p.apellidos}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Email",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text('${p.correo}', style: const TextStyle(fontSize: 16)),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              "Contraseña",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text("********", style: TextStyle(fontSize: 16)),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Fecha de Nacimiento",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text(
              '${p.fechaNacimiento!.day}/${p.fechaNacimiento!.month}/${p.fechaNacimiento!.year}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              "Género",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            subtitle: Text('${p.sexo}', style: const TextStyle(fontSize: 16)),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // Widget _buildEditButton(BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const EditProfileScreen()),
  //       ).then((perfilActualizado) {
  //         if (perfilActualizado != null) {
  //           setState(() {
  //             p = rellenarPerfil() as Perfil;
  //           });
  //         }
  //       });
  //     },
  //     backgroundColor: Colors.blue,
  //     child: Icon(Icons.edit, color: Colors.white),
  //   );
  // }

  static Perfil? rellenarPerfil() {
    print(PerfilCRUD.currentProfile);
    Perfil? p = PerfilCRUD.currentProfile;
    return p;
  }
}
