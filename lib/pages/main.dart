import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:piladea_web/Pages/login_view.dart';
import 'package:piladea_web/Pages/singup.dart';
import 'package:piladea_web/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      routes: {
        LoginView.id: (context) => LoginView(),
        SignupView.id: (context) => SignupView(),
        //HomePage.id: (context) => const HomePage(),
      },
      //routes: customRoutes,
      //home: const MyHomePage(title: 'Inicio de Sesión'),
    );
  }
}
