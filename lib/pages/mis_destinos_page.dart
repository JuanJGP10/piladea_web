import 'package:flutter/material.dart';
// import 'package:piladea_updated/Controlador/destino_CRUD.dart';
// import 'package:piladea_updated/Controlador/perfil_CRUD.dart';
// import 'package:piladea_updated/Modelo/destino.dart';
// import 'package:piladea_updated/auth/widgets/card_destino.dart';

class MisDestinosPage extends StatefulWidget {
  const MisDestinosPage({Key? key}) : super(key: key);

  @override
  State<MisDestinosPage> createState() => _MisDestinosPageState();
}

class _MisDestinosPageState extends State<MisDestinosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Mis Destinos'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Text('Contenido aquí', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
