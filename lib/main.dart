import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Importamos tus pantallas (asegúrate de que los nombres de archivo coincidan)
import 'home_screen.dart';
import 'computadoras_list.dart';
import 'empleados_list.dart';

void main() async {
  // 1. Configuración obligatoria para Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicialización de Firebase con TUS datos reales
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDcvlW2aRG1HPzk8nVQ9Cf6cjfklGPNAY0",
      authDomain: "bdcrudelectronicos.firebaseapp.com",
      projectId: "bdcrudelectronicos",
      storageBucket: "bdcrudelectronicos.firebasestorage.app",
      messagingSenderId: "937481081101",
      appId: "1:937481081101:web:877effb5f66db1788ea044",
    ),
  );
  
  runApp(const MiTiendaApp());
}

class MiTiendaApp extends StatelessWidget {
  const MiTiendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Electrónicos',
      debugShowCheckedModeBanner: false,
      
      // 3. El tema moderno que pediste
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      
      // 4. Abrimos directamente el Home con el diseño atractivo
      home: HomeScreen(), 
    );
  }
}