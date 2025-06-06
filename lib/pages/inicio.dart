import 'package:flutter/material.dart';
import 'package:piladea_web/pages/login_view.dart';
import 'dart:async';

class Inicio extends StatefulWidget {
  static String id = 'inicio';
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final List<String> _imagePaths = [
    'assets/images/piladea_logo.png',
    'assets/images/img1.png',
    'assets/images/img2.png',
    'assets/images/img3.png',
  ];
  int _currentImageIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF2FBFF),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Piladea',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Texto a la izquierda
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tu bici es tu tarjeta de puntos. ¡A rodar que hay premios!',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Aplicación web donde se puede ganar puntos (bicicoins) '
                              'haciendo recorridos en bici en el Pilar de la Horadada. '
                              '\nDichos puntos se podrán canjear por distintos premios '
                              'de diferentes locales.\nCuantos más km en bici, más puntos. '
                              '¿Te apuntas?',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18.0,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      // Imagen a la derecha
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _imagePaths[_currentImageIndex],
                            height: size.width * 0.25,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginView.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF74D4FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 60),

              // Sección opcional de pasos o beneficios
              const Text(
                '¿Cómo funciona?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. Regístrate o inicia sesión\n'
                '2. Usa tu bici para recorrer el municipio\n'
                '3. Gana bicicoins por cada trayecto\n'
                '4. Canjea puntos por recompensas',
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
