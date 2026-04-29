import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComputadorasList extends StatelessWidget {
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();
  final TextEditingController precioController = TextEditingController();
  final TextEditingController procesadorController = TextEditingController();
  final TextEditingController ramController = TextEditingController();

  // Función única para Crear o Editar
  void _showForm(BuildContext context, {DocumentSnapshot? ds}) {
    if (ds != null) {
      marcaController.text = ds['marca'];
      modeloController.text = ds['modelo'];
      precioController.text = ds['precio'].toString();
      procesadorController.text = ds['procesador'];
      ramController.text = ds['ram'].toString();
    } else {
      marcaController.clear(); modeloController.clear(); precioController.clear();
      procesadorController.clear(); ramController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ds == null ? "Nueva Computadora" : "Actualizar Datos"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: marcaController, decoration: const InputDecoration(labelText: "Marca")),
              TextField(controller: modeloController, decoration: const InputDecoration(labelText: "Modelo")),
              TextField(controller: precioController, decoration: const InputDecoration(labelText: "Precio"), keyboardType: TextInputType.number),
              TextField(controller: procesadorController, decoration: const InputDecoration(labelText: "Procesador")),
              TextField(controller: ramController, decoration: const InputDecoration(labelText: "RAM (GB)"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              Map<String, dynamic> data = {
                'marca': marcaController.text,
                'modelo': modeloController.text,
                'precio': int.tryParse(precioController.text) ?? 0,
                'procesador': procesadorController.text,
                'ram': int.tryParse(ramController.text) ?? 0,
              };

              if (ds == null) {
                FirebaseFirestore.instance.collection('computadoras').add(data);
              } else {
                ds.reference.update(data); // <--- AQUÍ ACTUALIZA
              }
              Navigator.pop(context);
            },
            child: Text(ds == null ? "Guardar" : "Actualizar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario"), backgroundColor: Colors.blueAccent),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('computadoras').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ds = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  onTap: () => _showForm(context, ds: ds), // Al tocar, EDITA
                  title: Text(ds['marca'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${ds['modelo']} | \$${ds['precio']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => ds.reference.delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}