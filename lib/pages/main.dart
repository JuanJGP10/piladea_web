import 'package:flutter/material.dart';
import 'package:piladea_web/Pages/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio De Sesión',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: LoginView.id,
      routes: {LoginView.id: (context) => LoginView()},
      //routes: customRoutes,
      //home: const MyHomePage(title: 'Inicio de Sesión'),
    );
  }
}
