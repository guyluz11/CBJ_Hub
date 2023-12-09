import 'dart:io';

import 'package:cbj_hub/application/boot_up/boot_up.dart';
import 'package:cbj_hub/infrastructure/cbj_web_server/cbj_web_server_repository.dart';
import 'package:cbj_hub/infrastructure/mqtt_server/mqtt_server_repository.dart';
import 'package:cbj_integrations_controller/infrastructure/core/initialize_integrations_controller.dart';
import 'package:cbj_integrations_controller/infrastructure/core/injection.dart';
import 'package:cbj_integrations_controller/infrastructure/node_red/node_red_repository.dart';
import 'package:cbj_integrations_controller/infrastructure/shared_variables.dart';
import 'package:network_tools/network_tools.dart';

Future<void> main(List<String> arguments) async {
  configureNetworkTools('network_tools_db');

  setInstancesOfRepos(arguments.firstOrNull ?? Directory.current.path);
  // arguments[0] is the location of the project
  await initializeIntegrationsController(
    projectRootDirectoryPath: arguments.firstOrNull ?? Directory.current.path,
    env: Env.devPc,
  );

  BootUp();
}

/// All instances of Repos
void setInstancesOfRepos(String projectRootDirectoryPath) {
  MqttServerRepository();
  CbjWebServerRepository();
  NodeRedRepository();
  SharedVariables().asyncConstructor(projectRootDirectoryPath);
}
