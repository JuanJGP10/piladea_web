import 'package:flutter/material.dart';

class LoginView extends StatelessWidget{
  static String id='login_view';
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(

          //centramos automáticamente
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login',style: TextStyle(color: Colors.purpleAccent, fontSize: 40.0),),
            SizedBox(height: 85),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:size.width*0.1,
                  vertical: size.height*0.05,
              ),
              //email
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'email',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
           onChanged:(value){},
              ),
            ),


            Padding(
              padding:  EdgeInsets.only(
                  left: size.width*0.1,
                  right: size.width*0.1,
                bottom: size.height*0.05,
              ),

              child: TextField(
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration:  InputDecoration(
                  labelText: 'contraseña',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                  ),
                ),
                onChanged:(value){},
              ),
            ),
            //botón
            ElevatedButton(
              onPressed: ()=>{},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color:Colors.white
                ),
              ),
            ),
            SizedBox(height: 15),//espacio entre el botón y el texto

            const Text('o continúa con ',style: TextStyle(color:Colors.white,fontSize: 15.0),),
            SizedBox(height: 30),
            //logo de google

          ],
        ),
      ),
    );
  }
}