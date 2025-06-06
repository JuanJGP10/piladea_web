import 'package:flutter/material.dart';
// import 'package:piladea_updated/Controlador/destino_CRUD.dart';
// import 'package:piladea_updated/Controlador/perfil_CRUD.dart';
// import 'package:piladea_updated/Modelo/destino.dart';
// import 'package:piladea_updated/auth/widgets/card_destino.dart';

class CatalogoPremiosPage extends StatefulWidget {
  const CatalogoPremiosPage({Key? key}) : super(key: key);

  @override
  State<CatalogoPremiosPage> createState() => _MisDestinosPageState();
}

class _MisDestinosPageState extends State<CatalogoPremiosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          'Catalogo de premios',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Text('Contenido aquí', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
