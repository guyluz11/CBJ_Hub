import 'package:cbj_hub/application/connector/connector.dart';
import 'package:cbj_integrations_controller/initialize_integrations_controller.dart';

class BootUp {
  BootUp() {
    setup();
  }

  Future<void> setup() async {
    await setupIntegrationsController();
    Connector.startConnector();
  }
}
