import 'package:cbj_hub/application/boot_up/boot_up.dart';
import 'package:cbj_integrations_controller/initialize_integrations_controller.dart';
import 'package:cbj_integrations_controller/injection.dart';
import 'package:network_tools/network_tools.dart' as network;

Future<void> main(List<String> arguments) async {
  // arguments[0] is the location of the project
  network.configureNetworkTools('network_tools_db');
  await initializeIntegrationsController(arguments: arguments, env: Env.prod);

  await BootUp.setup();
}
