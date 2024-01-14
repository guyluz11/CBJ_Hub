import 'package:cbj_hub/infrastructure/hub_server/hub_server_controller.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';

class BootUp {
  BootUp() {
    setup();
  }

  Future setup() async {
    await setupIntegrationsController();
    // Connector().startConnector();
    Future.delayed(const Duration(milliseconds: 3000)).whenComplete(() {
      HubServerController();
    });
  }
}
