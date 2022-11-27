import 'package:cbj_hub/infrastructure/devices/esphome/esphome_python_api/esphome_python_api.dart';
import 'package:injectable/injectable.dart';
import 'package:python_shell/python_shell.dart';

@singleton
class PythonIntegration {
  // Trying to solve https://github.com/CyBear-Jinni/cbj_hub/issues/275 by
  // setting python packages before mqtt

  PythonShell? _shell;
  List<String> requeiredPythonPackages = [];

  Future<void> asyncConstractor() async {
    requeiredPythonPackages.addAll(EspHomePythonApi.requeiredPythonPackages);
    await getShell();
  }

  Future<PythonShell> getShell() async {
    if (_shell != null) {
      return _shell!;
    }

    _shell = PythonShell(PythonShellConfig());
    await _shell!.initialize();
    final instance = ShellManager.getInstance("default");
    instance.installRequires(requeiredPythonPackages);
    return _shell!;
  }
}
