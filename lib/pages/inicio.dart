import 'package:flutter/material.dart';
import 'package:piladea_web/pages/login_view.dart';

class Inicio extends StatelessWidget {
  static String id = 'inicio';
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Center(
              child: Text(
                'Piladea',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(
                      blurRadius: 30.0,
                      color: Colors.purpleAccent,
                      offset: Offset(0, 0),
                    ),
                    Shadow(
                      blurRadius: 60.0,
                      color: Colors.purpleAccent,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),

            /// Contenido dividido: texto a la izquierda, imagen a la derecha
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: texto
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '¿Qué es?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Aplicación web donde se puede ganar puntos (bicicoins) '
                              'haciendo recorridos en bici en el Pilar de la Horadada. '
                              'Dichos puntos se podrán canjear por distintos premios '
                              'de diferentes locales. Cuantos más km en bici, más puntos. '
                              '¿Te apuntas?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 30),

                  // Columna derecha: imagen o espacio
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      'assets/images/piladea_logo.png', // Asegúrate de que la imagen exista
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginView.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
