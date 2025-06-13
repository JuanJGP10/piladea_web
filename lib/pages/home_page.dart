import 'package:flutter/material.dart';
import 'package:piladea_web/Authentication/Services/auth_firebase_repository.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/Pages/catalogo_premios.dart';
import 'package:piladea_web/Pages/cupones_page.dart';
import 'package:piladea_web/Pages/login_view.dart';
import 'package:piladea_web/Pages/mis_destinos_page.dart';
import 'package:piladea_web/Pages/profile_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:piladea_web/Controller/perfil_CRUD.dart';
// import 'package:piladea_web/Pages/login_view.dart';
// import 'package:piladea_web/Authentication/services/auth_firebase_repository.dart';

class HomePage extends StatefulWidget {
  final Perfil perfil;
  const HomePage({Key? key, required this.perfil}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Perfil perfilLLave;

  LatLng _origen = LatLng(
    37.857149364541726,
    -0.7886004260761562,
  ); // Pilar de la Horadada
  LatLng? _destino;
  List<LatLng> _ruta = [];
  final MapController _mapController = MapController();

  Future<void> obtenerUbicacionYActualizarMapa() async {
    try {
      bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
      if (!servicioHabilitado) {
        throw Exception('Servicio de ubicación no está habilitado.');
      }

      LocationPermission permiso = await Geolocator.checkPermission();

      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
        if (permiso == LocationPermission.denied) {
          throw Exception('Permiso de ubicación denegado por el usuario.');
        }
      }

      if (permiso == LocationPermission.deniedForever) {
        throw Exception('Permiso de ubicación denegado permanentemente.');
      }

      // Este método es el que debe lanzar la petición real al navegador
      Position posicion = await Geolocator.getCurrentPosition();

      print('Ubicación actual: ${posicion.latitude}, ${posicion.longitude}');

      setState(() {
        _origen = LatLng(posicion.latitude, posicion.longitude);
      });

      // Centrar el mapa si ya está listo
      _mapController.move(_origen, 14.0);
    } catch (e) {
      print('Error al obtener ubicación: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    perfilLLave = widget.perfil;
    obtenerUbicacionYActualizarMapa();
  }

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
                    builder: (_) => ProfilePage(perfil: perfilLLave),
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => LoginView()),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _origen,
          initialZoom: 14,
          onTap: (tapPosition, point) async {
            setState(() {
              _destino = point;
            });

            final openrouteservice = OpenRouteService(
              apiKey:
                  '5b3ce3597851110001cf6248e217dad80f7d43c3a76b920a5528ce8f',
            );

            final coords = await openrouteservice.directionsRouteCoordsGet(
              startCoordinate: ORSCoordinate(
                latitude: _origen.latitude,
                longitude: _origen.longitude,
              ),
              endCoordinate: ORSCoordinate(
                latitude: point.latitude,
                longitude: point.longitude,
              ),
            );

            setState(() {
              _ruta = coords
                  .map((c) => LatLng(c.latitude, c.longitude))
                  .toList();
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _origen,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 40,
                ),
              ),
              if (_destino != null)
                Marker(
                  point: _destino!,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.flag, color: Colors.red, size: 40),
                ),
            ],
          ),
          if (_ruta.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(points: _ruta, color: Colors.blue, strokeWidth: 4.0),
              ],
            ),
        ],
      ),
    );
  }
}
