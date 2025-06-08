import 'package:flutter/material.dart';
import 'package:piladea_web/Authentication/structures/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:piladea_web/Controller/imagen_aleatoria.dart';
import 'package:piladea_web/Controller/perfil_crud.dart';
import 'package:piladea_web/Model/perfil.dart';
import 'package:piladea_web/Pages/home_page.dart';
import 'package:table_calendar/table_calendar.dart';

class SignupView extends StatefulWidget {
  static String id = 'signup_view';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignupView> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthController();
  late Perfil perfil;
  String? selectedOption;
  DateTime? selectedDate;

  final List<String> opciones = ['Masculino', 'Femenino', 'Otro', 'No binario'];

  void _showCalendarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color.fromARGB(255, 223, 246, 255),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        DateTime _focusedDay = selectedDate ?? DateTime.now();
        DateTime? _tempSelectedDay = selectedDate;
        final TextEditingController
        _manualDateController = TextEditingController(
          text: selectedDate != null
              ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
              : '',
        );

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Añadir listener
            _manualDateController.addListener(() {
              final value = _manualDateController.text;
              if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                try {
                  final parts = value.split('/');
                  final day = int.parse(parts[0]);
                  final month = int.parse(parts[1]);
                  final year = int.parse(parts[2]);
                  final manualDate = DateTime(year, month, day);

                  if (manualDate.isBefore(DateTime.now()) &&
                      manualDate.isAfter(DateTime(1900))) {
                    setModalState(() {
                      _tempSelectedDay = manualDate;
                      _focusedDay = manualDate;
                    });
                  }
                } catch (_) {
                  // Ignorar errores silenciosamente
                }
              }
            });

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _manualDateController,
                    style: const TextStyle(color: Colors.black),
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      hintStyle: TextStyle(color: Colors.black),
                      labelText: 'Ingresar fecha manualmente',
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TableCalendar(
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    firstDay: DateTime(1900),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) =>
                        isSameDay(_tempSelectedDay, day),
                    onDaySelected: (selected, focused) {
                      setModalState(() {
                        _tempSelectedDay = selected;
                        _focusedDay = focused;
                        _manualDateController.text =
                            '${selected.day.toString().padLeft(2, '0')}/${selected.month.toString().padLeft(2, '0')}/${selected.year}';
                      });
                    },
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      selectedDecoration: BoxDecoration(
                        color: Color(0xFF74d4ff),
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xFF74d4ff),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: TextStyle(color: Colors.black),
                    ),
                    headerStyle: const HeaderStyle(
                      titleCentered: true,
                      formatButtonVisible: false,
                      titleTextStyle: TextStyle(color: Colors.black),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.black,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.black,
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.black),
                      weekdayStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF74d4ff),
                    ),
                    onPressed: () {
                      if (_tempSelectedDay != null) {
                        setState(() {
                          selectedDate = _tempSelectedDay;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'Seleccionar Fecha',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /*Future<void> _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.dark(
            primary: Colors.Color(0xFF2b7fff), // Color de encabezado y botón OK
            onPrimary: Colors.black, // Color del texto en encabezado
            surface: Colors.grey[800]!, // Fondo del calendario
            onSurface: Colors.black, // Color de texto
          ),
          dialogBackgroundColor: Colors.black87,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.deepPurpleAccent, // Botones Cancelar/OK
            ),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != selectedDate) {
    setState(() {
      selectedDate = picked;
    });
  }
}*/

  void register() async {
    try {
      await authService.registerwithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (passwordController.text.length > 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario registrado exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );

        PerfilCRUD p = PerfilCRUD.instance;
        //ImagenesAleatorias i = ImagenesAleatorias();
        final String? userUid = FirebaseAuth.instance.currentUser?.uid;

        Perfil? p1 = Perfil(
          admin: false,
          nombre: nameController.text,
          apellidos: lastNameController.text,
          correo: emailController.text,
          sexo: selectedOption,
          fechaNacimiento: selectedDate!,
          fechaCreacion:
              DateTime.now(), // Marca temporal al momento de creación
          uID: userUid,
          rutaImagen: ImagenesAleatorias().obtenerRutaImagenAleatoria(),
          bicicoins: 0,
          cupones: [],
          trayectos: [],
          destinos: [],
        );
        await p.addPerfil(p1);

        Perfil? perfilEncontrado = await PerfilCRUD.instance.findPerfil(
          p1.uID!,
        );

        if (perfilEncontrado == null) {
          throw Exception("No se pudo encontrar el perfil");
        }

        perfil = perfilEncontrado; // ahora Dart sabe que no es null

        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(perfil: perfil)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La contraseña no es válida (>6 caracteres)'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Firebase Error: ${e.message}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error inesperado: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 251, 255),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.03,
            ),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  'Crear usuario',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(height: 40),
                _buildStyledTextField(nameController, 'Nombre'),
                const SizedBox(height: 15),
                _buildStyledTextField(lastNameController, 'Apellido'),
                const SizedBox(height: 15),
                _buildStyledTextField(emailController, 'Email'),
                const SizedBox(height: 15),
                _buildStyledTextField(
                  passwordController,
                  'Contraseña',
                  obscure: true,
                ),
                const SizedBox(height: 15),
                _buildDropdownField(),
                const SizedBox(height: 15),
                _buildDateField(),
                const SizedBox(height: 35),
                ElevatedButton(
                  onPressed: register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF74d4ff),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
  }) {
    return SizedBox(
      height: 60,
      width: 600,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.black, fontSize: 20.0),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return SizedBox(
      height: 60,
      width: 600,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Género',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        dropdownColor: Colors.black87,
        value: selectedOption,
        items: opciones.map((op) {
          return DropdownMenuItem(
            value: op,
            child: Text(op, style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() => selectedOption = value);
        },
      ),
    );
  }

  Widget _buildDateField() {
    return SizedBox(
      height: 60,
      width: 600,
      child: InkWell(
        onTap: () => _showCalendarPicker(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Fecha de Nacimiento',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
            ),
            border: OutlineInputBorder(),
          ),
          child: Text(
            selectedDate == null
                ? 'Seleccionar fecha'
                : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            style: TextStyle(
              color: selectedDate == null ? Colors.grey[600] : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
