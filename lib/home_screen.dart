import 'package:flutter/material.dart';
import 'computadoras_list.dart';
import 'empleados_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo con un degradado ligero
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade500],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_mall_directory, size: 80, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Sistema de Inventario",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),
                
                // Botón Computadoras
                _buildMenuCard(
                  context,
                  title: "Computadoras",
                  subtitle: "Stock y Precios",
                  icon: Icons.computer,
                  color: Colors.blueAccent,
                  page: ComputadorasList(),
                ),
                
                SizedBox(height: 20),
                
                // Botón Empleados
                _buildMenuCard(
                  context,
                  title: "Empleados",
                  subtitle: "Gestión de Personal",
                  icon: Icons.badge,
                  color: Colors.orangeAccent,
                  page: EmpleadosList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget personalizado para que los botones parezcan tarjetas modernas
  Widget _buildMenuCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required Widget page}) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => page)),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 40),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[300]),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}