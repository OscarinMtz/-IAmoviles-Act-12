import 'dart:io';

void main() async {
  print('\x1B[32m======================================\x1B[0m');
  print('\x1B[32m      AGENTE INTERACTIVO GITHUB       \x1B[0m');
  print('\x1B[32m======================================\x1B[0m');

  // 1. Preguntar por el link del nuevo repositorio
  stdout.write('\x1B[33m1. Introduce el link del repositorio de GitHub: \x1B[0m');
  String? repoUrl = stdin.readLineSync()?.trim();
  if (repoUrl == null || repoUrl.isEmpty) {
    print('\x1B[31mError: El link del repositorio es obligatorio.\x1B[0m');
    return;
  }

  // 2. Preguntar por el commit
  stdout.write('\x1B[33m2. Introduce el mensaje del commit: \x1B[0m');
  String? commitMessage = stdin.readLineSync()?.trim();
  if (commitMessage == null || commitMessage.isEmpty) {
    print('\x1B[31mError: El mensaje del commit es obligatorio.\x1B[0m');
    return;
  }

  // 3. Preguntar por el nombre de la rama (main por default)
  stdout.write('\x1B[33m3. Introduce el nombre de la rama [\x1B[36mdefault: main\x1B[33m]: \x1B[0m');
  String? branchName = stdin.readLineSync()?.trim();
  if (branchName == null || branchName.isEmpty) {
    branchName = 'main';
  }

  print('\n\x1B[34m--- Iniciando proceso de envío a GitHub ---\x1B[0m\n');

  try {
    // Verificar si git está inicializado
    if (!Directory('.git').existsSync()) {
      print('\x1B[36m> Inicializando repositorio Git...\x1B[0m');
      await runCommand('git', ['init']);
    }

    print('\x1B[36m> Agregando archivos...\x1B[0m');
    await runCommand('git', ['add', '.']);

    print('\x1B[36m> Realizando commit...\x1B[0m');
    await runCommand('git', ['commit', '-m', commitMessage]);

    print('\x1B[36m> Estableciendo rama $branchName...\x1B[0m');
    await runCommand('git', ['branch', '-M', branchName]);

    print('\x1B[36m> Configurando remote origin...\x1B[0m');
    var resultRemote = await Process.run('git', ['remote', 'add', 'origin', repoUrl]);
    if (resultRemote.exitCode != 0) {
      print('\x1B[33mEl remote origin ya existe, actualizando URL...\x1B[0m');
      await runCommand('git', ['remote', 'set-url', 'origin', repoUrl]);
    }

    print('\x1B[36m> Subiendo cambios a GitHub (push)...\x1B[0m');
    // Usamos inherit para que el usuario pueda ver el progreso o ingresar credenciales si es necesario
    var process = await Process.start('git', ['push', '-u', 'origin', branchName], mode: ProcessStartMode.inheritStdio);
    var exitCode = await process.exitCode;

    if (exitCode == 0) {
      print('\n\x1B[32m======================================\x1B[0m');
      print('\x1B[32m   ¡REPOSIORIO ENVIADO CON ÉXITO!     \x1B[0m');
      print('\x1B[32m======================================\x1B[0m');
    } else {
      print('\x1B[31mError al realizar el push. Código de salida: $exitCode\x1B[0m');
    }
  } catch (e) {
    print('\n\x1B[31mOcurrió un error inesperado: $e\x1B[0m');
  }
}

Future<void> runCommand(String command, List<String> arguments) async {
  var result = await Process.run(command, arguments);
  if (result.stdout.toString().trim().isNotEmpty) {
    print(result.stdout);
  }
  if (result.stderr.toString().trim().isNotEmpty) {
    print('\x1B[33m${result.stderr}\x1B[0m');
  }
  if (result.exitCode != 0 && !result.stderr.toString().contains('already exists')) {
    throw Exception('Error ejecutando $command ${arguments.join(' ')}');
  }
}
