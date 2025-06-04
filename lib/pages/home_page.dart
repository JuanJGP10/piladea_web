import 'package:flutter/material.dart';
// import 'package:piladea_web/Controller/perfil_CRUD.dart';
// import 'package:piladea_web/Pages/login_view.dart';
// import 'package:piladea_web/Authentication/services/auth_firebase_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _liked = false;
  Icon _corazon = const Icon(Icons.favorite, color: Colors.white);

  void likedCambioEstado() {
    setState(() {
      _liked = !_liked;
      _corazon = Icon(
        Icons.favorite,
        color: _liked ? Colors.red : Colors.white,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        actions: [IconButton(icon: _corazon, onPressed: likedCambioEstado)],
      ),
      body: Column(), // Aquí puedes agregar el contenido real del cuerpo
      backgroundColor: Colors.white24,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_stats, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: '',
          ),
        ],
      ),
    );
  }
}
