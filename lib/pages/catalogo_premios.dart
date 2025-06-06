import 'package:flutter/material.dart';
// import 'package:piladea_updated/Controlador/destino_CRUD.dart';
// import 'package:piladea_updated/Controlador/perfil_CRUD.dart';
// import 'package:piladea_updated/Modelo/destino.dart';
// import 'package:piladea_updated/auth/widgets/card_destino.dart';

class CatalogoPremiosPage extends StatefulWidget {
  const CatalogoPremiosPage({Key? key}) : super(key: key);

  @override
  State<CatalogoPremiosPage> createState() => _CatalogoPremiosPageState();
}

class _CatalogoPremiosPageState extends State<CatalogoPremiosPage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, String>> items = [
    {'image': 'assets/images/piladea_logo.png', 'text': 'Elemento 1'},
    {'image': 'assets/images/piladea_logo.png', 'text': 'Elemento 2'},
    {'image': 'assets/images/piladea_logo.png', 'text': 'Elemento 3'},
    {'image': 'assets/images/piladea_logo.png', 'text': 'Elemento 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Catálogo de premios',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purpleAccent,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 179, 188, 196),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.asset(item['image']!, width: 60, height: 60),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['text']!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
