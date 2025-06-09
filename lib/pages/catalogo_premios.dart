import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:piladea_web/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CatalogoPremiosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Categoria {
  Comida,
  Ocio,
  Salud,
  Belleza,
  Otros;

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

  Future<List<Map<String, dynamic>>> fetchCatalogo() async {
    final snapshot = await FirebaseFirestore.instance.collection('cupones').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        ...data,
        'categoria': _parseCategoria(data['Categoria'] as String?), // Asegúrate que la clave coincide con Firestore
      };
    }).toList();
  }

  Categoria _parseCategoria(String? value) {
    if (value == null) return Categoria.Otros;

    return Categoria.values.firstWhere(
          (c) => c.name.toLowerCase() == value.toLowerCase(),
      orElse: () => Categoria.Otros,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 251, 255),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Catálogo de premios',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFF74d4ff),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<Categoria?>(
              decoration: InputDecoration(
                labelText: 'Filtrar por categoría',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                const DropdownMenuItem<Categoria?>(
                  value: null,
                  child: Text('Todas las categorías'),
                ),
                ...Categoria.values.map(
                      (categoria) => DropdownMenuItem<Categoria?>(
                    value: categoria,
                    child: Text(categoria.name),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCatalogo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final items = (snapshot.data ?? []).where((item) {
                  final cat = item['categoria'] as Categoria?;
                  return categoriaSeleccionada == null || categoriaSeleccionada == cat;
                }).toList();

                if (items.isEmpty) {
                  return const Center(
                    child: Text('No hay premios disponibles.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final image = item['img'] ?? 'assets/images/piladea_logo.png';
                    final text = item['Nombre'] ?? '';
                    final descripcion = item['Descripcion'] ?? 'Producto x';
                    final canBicicois = item['cantBicicoins'] ?? 500;
                    final categoria = item['categoria'] as Categoria? ?? Categoria.Otros;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFb8e6fe),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          image.toString().startsWith('http')
                              ? Image.network(image, width: 60, height: 60)
                              : Image.asset(image, width: 60, height: 60),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nombre: $text",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Descripción: $descripcion",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "BiciCoins: $canBicicois",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text("Categoría: ${categoria.name}"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}