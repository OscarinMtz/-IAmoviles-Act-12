import 'dart:io';

void main() async {
  print('--- Agente interactivo para enviar a GitHub ---');

  // 1. Preguntar por el link del nuevo repositorio
  stdout.write('1. Ingresa el link del nuevo repositorio de GitHub: ');
  String? repoLink = stdin.readLineSync();
  if (repoLink == null || repoLink.trim().isEmpty) {
    print('Error: El link del repositorio es obligatorio.');
    return;
  }

  // 2. Preguntar por el mensaje de commit
  stdout.write('2. Ingresa el mensaje para el commit: ');
  String? commitMessage = stdin.readLineSync();
  if (commitMessage == null || commitMessage.trim().isEmpty) {
    print('Error: El mensaje de commit es obligatorio.');
    return;
  }

  // 3. Preguntar por el nombre de la rama (default: main)
  stdout.write('3. Ingresa el nombre de la rama (presiona Enter para usar "main" por defecto): ');
  String? branch = stdin.readLineSync();
  if (branch == null || branch.trim().isEmpty) {
    branch = 'main';
  }

  print('\n----------------------------------------');
  print('Resumen de la operación:');
  print('Repositorio remoto: ${repoLink.trim()}');
  print('Mensaje del commit: "$commitMessage"');
  print('Rama destino:       $branch');
  print('----------------------------------------\n');

  try {
    // Añadir todos los cambios
    await ejecutarComando('git', ['add', '.']);

    // Realizar el commit
    await ejecutarComando('git', ['commit', '-m', commitMessage]);

    // Cambiar el nombre de la rama principal
    await ejecutarComando('git', ['branch', '-M', branch]);

    // Configurar el repositorio remoto
    // Intentamos añadirlo primero. Si ya existe, lo actualizamos.
    var remoteResult = await Process.run('git', ['remote', 'add', 'origin', repoLink.trim()], runInShell: true);
    if (remoteResult.exitCode != 0) {
      print('Actualizando la URL del remote "origin"...');
      await ejecutarComando('git', ['remote', 'set-url', 'origin', repoLink.trim()]);
    }

    // Enviar los cambios (push)
    await ejecutarComando('git', ['push', '-u', 'origin', branch]);

    print('\n✅ ¡Repositorio enviado a GitHub con éxito!');
  } catch (e) {
    print('\n❌ Ocurrió un error durante el proceso:');
    print(e);
  }
}

// Función auxiliar para ejecutar comandos en la terminal
Future<void> ejecutarComando(String comando, List<String> argumentos) async {
  print('> \$ $comando ${argumentos.join(" ")}');
  var resultado = await Process.run(comando, argumentos, runInShell: true);
  
  if (resultado.stdout.toString().isNotEmpty) {
    print(resultado.stdout.toString().trim());
  }
  
  if (resultado.exitCode != 0) {
    if (resultado.stderr.toString().isNotEmpty) {
      print('Error output: ${resultado.stderr.toString().trim()}');
    }
    throw Exception('Falló la ejecución del comando: $comando ${argumentos.join(" ")}');
  }
}
