import 'package:cbj_hub/infrastructure/app_communication/app_communication_repository.dart';
import 'package:cbj_integrations_controller/domain/connector.dart';
import 'package:cbj_integrations_controller/infrastructure/core/initialize_integrations_controller.dart';

class BootUp {
  BootUp() {
    setup();
  }

  Future<void> setup() async {
    await setupIntegrationsController();
    Connector().startConnector();
    Future.delayed(const Duration(milliseconds: 3000)).whenComplete(() {
      AppCommunicationRepository();
    });
  }
}
