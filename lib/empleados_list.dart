import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmpleadosList extends StatelessWidget {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController puestoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController numController = TextEditingController();

  void _showForm(BuildContext context, {DocumentSnapshot? ds}) {
    if (ds != null) {
      nombreController.text = ds['nombre'];
      puestoController.text = ds['puesto'];
      emailController.text = ds['email'];
      telController.text = ds['telefono'];
      numController.text = ds['num_emp'];
    } else {
      nombreController.clear(); puestoController.clear(); emailController.clear();
      telController.clear(); numController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ds == null ? "Nuevo Empleado" : "Editar Empleado"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nombreController, decoration: const InputDecoration(labelText: "Nombre")),
              TextField(controller: puestoController, decoration: const InputDecoration(labelText: "Puesto")),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: telController, decoration: const InputDecoration(labelText: "Teléfono")),
              TextField(controller: numController, decoration: const InputDecoration(labelText: "Núm. Empleado")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              Map<String, dynamic> data = {
                'nombre': nombreController.text,
                'puesto': puestoController.text,
                'email': emailController.text,
                'telefono': telController.text,
                'num_emp': numController.text,
              };

              if (ds == null) {
                FirebaseFirestore.instance.collection('empleados').add(data);
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
      appBar: AppBar(title: const Text("Personal"), backgroundColor: Colors.orangeAccent),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('empleados').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ds = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  onTap: () => _showForm(context, ds: ds), // Al tocar, EDITA
                  leading: CircleAvatar(child: Text(ds['num_emp'])),
                  title: Text(ds['nombre']),
                  subtitle: Text(ds['puesto']),
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
        child: const Icon(Icons.person_add),
      ),
    );
  }
}