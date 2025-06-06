import 'package:flutter/material.dart';
import 'package:piladea_web/Authentication/Services/auth_firebase_repository.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/Pages/catalogo_premios.dart';
import 'package:piladea_web/Pages/cupones_page.dart';
import 'package:piladea_web/Pages/login_view.dart';
import 'package:piladea_web/Pages/mis_destinos_page.dart';
import 'package:piladea_web/Pages/profile_page.dart';
// import 'package:piladea_web/Controller/perfil_CRUD.dart';
// import 'package:piladea_web/Pages/login_view.dart';
// import 'package:piladea_web/Authentication/services/auth_firebase_repository.dart';

class HomePage extends StatefulWidget {
  static String id = '/home';
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 242, 251, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF74d4ff),
        title: const Text(
          'Piladea',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 242, 251, 255),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF74d4ff)),
              child: Text(
                'Menú',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text(
                'Mis Destinos',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Acción para la opción 1
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const MisDestinosPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Catálogo de premios',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => CatalogoPremiosPage()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Mis cupones',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const CuponesPage()));
              },
            ),
            ListTile(
              title: const Text(
                'Perfil',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Navegar a la página de perfil

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ProfilePage(perfil: PerfilCRUD.currentProfile!),
                  ),
                );
              },
            ),
            // if (PerfilCRUD.currentProfile!.admin)
            //   ListTile(
            //     title: const Text('Estadísticas'),
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(builder: (_) => const EstadisticasPage()),
            //       );
            //     },
            //   ),
            ListTile(
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Cerrar sesión'),
                      content: const Text(
                        '¿Estás seguro de que deseas cerrar sesión?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Acción para el botón "Sí"
                            Navigator.of(context).pop(
                              true,
                            ); // Cierra el AlertDialog y devuelve true
                          },
                          child: const Text('Sí'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Acción para el botón "No"
                            Navigator.of(context).pop(
                              false,
                            ); // Cierra el AlertDialog y devuelve false
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  },
                ).then((value) {
                  // value es el valor devuelto por Navigator.pop en los botones Sí o No
                  if (value != null && value) {
                    AuthFirebaseRepository authFirebaseRepository =
                        AuthFirebaseRepository();
                    authFirebaseRepository.logOut();
                    PerfilCRUD.currentProfile = null;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginView()),
                    );
                  } else {
                    print(PerfilCRUD.currentProfile);
                  }
                });
              },
            ),
          ],
        ),
      ),
      // body: Stack(
      //   children: [
      //     if (!_showSecondMap) // Mostrar MapScreen primero
      //       MapPage(
      //         circleLayer: CircleLayer(
      //           circles: [
      //             CircleMarker(
      //               point: LatLng(37.87604842629718, -0.8064902376526171),
      //               color: Colors.blue.withOpacity(0.1),
      //               borderStrokeWidth: 3.0,
      //               borderColor: Colors.blue,
      //               radius: 5800, // radio en metros
      //               useRadiusInMeter: true,
      //             ),
      //           ],
      //         ),
      //         onStartRoute: _onStartRoute,
      //         selectedLocation: widget.ubicacion != null
      //             ? LatLng(
      //                 double.parse(
      //                   widget.ubicacion!.split(',')[0].trim(),
      //                 ), // Latitud
      //                 double.parse(
      //                   widget.ubicacion!.split(',')[1].trim(),
      //                 ), // Longitud
      //               )
      //             : _selectedLocation,
      //       )
      //     else
      //       OpenStreetMapSearchAndPick(
      //         onPicked: (pickedData) {
      //           _selectedLocation = LatLng(
      //             pickedData.latLong.latitude,
      //             pickedData.latLong.longitude,
      //           );
      //           print(pickedData.address);
      //         },
      //         onStartRoute: () {
      //           widget.ubicacion = null;
      //           _previousMap = OpenStreetMapSearchAndPick(
      //             onPicked: (pickedData) {
      //               _selectedLocation = LatLng(
      //                 pickedData.latLong.latitude,
      //                 pickedData.latLong.longitude,
      //               );
      //               print(pickedData.address);
      //             },
      //             onStartRoute: _toggleMap,
      //           );
      //           _toggleMap();
      //         },
      //       ),
      //   ],
      // ),
      /*labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              setState(() {
                _showSecondMap = true; // Mostrar OpenStreetMapSearchAndPick
              });*/
    );
  }
}
