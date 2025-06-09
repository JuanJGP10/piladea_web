import 'package:flutter/material.dart';
// import 'package:piladea_updated/Controlador/destino_CRUD.dart';
// import 'package:piladea_updated/Controlador/perfil_CRUD.dart';
// import 'package:piladea_updated/Modelo/destino.dart';
// import 'package:piladea_updated/auth/widgets/card_destino.dart';

enum Categoria {
  Comida,
  Ocio,
  Salud,
  Belleza;

  @override
  String toString() => name;
}

class CatalogoPremiosPage extends StatefulWidget {
  const CatalogoPremiosPage({Key? key}) : super(key: key);

  @override
  State<CatalogoPremiosPage> createState() => _CatalogoPremiosPageState();
}

class _CatalogoPremiosPageState extends State<CatalogoPremiosPage> {
  Categoria? categoriaSeleccionada;

  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/piladea_logo.png',
      'text': 'Pizza Gratis',
      'categoria': Categoria.Comida
    },
    {
      'image': 'assets/images/piladea_logo.png',
      'text': 'Entrada Cine',
      'categoria': Categoria.Ocio
    },
    {
      'image': 'assets/images/piladea_logo.png',
      'text': 'Chequeo Médico',
      'categoria': Categoria.Salud
    },
    {
      'image': 'assets/images/piladea_logo.png',
      'text': 'Masaje Relajante',
      'categoria': Categoria.Belleza
    },
    {
      'image': 'assets/images/piladea_logo.png',
      'text': 'Hamburguesa Doble',
      'categoria': Categoria.Comida
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> itemsFiltrados = categoriaSeleccionada == null
        ? items
        : items.where((item) => item['categoria'] == categoriaSeleccionada).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Catálogo de premios',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF74d4ff),
        leading: Navigator.of(context).canPop()
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<Categoria?>(
              decoration: InputDecoration(
                labelText: 'Filtrar por categoría',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              value: categoriaSeleccionada,
              onChanged: (Categoria? nuevaCategoria) {
                setState(() {
                  categoriaSeleccionada = nuevaCategoria;
                });
              },
              items: [
                DropdownMenuItem<Categoria?>(
                  value: null,
                  child: Text('Todas las categorías'),
                ),
                /**
                 * ...(spread operator)
                 * se utiliza para insertar los elementos de una lista dentro de otra lista
                 * ...Categoria.values.map((categoria) => DropdownMenuItem(
                    value: categoria,
                    child: Text(categoria.name),
                    )
                 */
                DropdownMenuItem<Categoria?>(
                  value: Categoria.Belleza,
                  child: Text('Belleza'),
                ),
                DropdownMenuItem<Categoria?>(
                  value: Categoria.Ocio,
                  child: Text('Ocio'),
                ),
                DropdownMenuItem<Categoria?>(
                  value: Categoria.Comida,
                  child: Text('Comida'),
                ),
                DropdownMenuItem<Categoria?>(
                  value: Categoria.Salud,
                  child: Text('Salud'),
                ),

              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itemsFiltrados.length,
              itemBuilder: (context, index) {
                final item = itemsFiltrados[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFb8e6fe),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(item['image'], width: 60, height: 60),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['text'],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
