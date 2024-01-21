import 'package:cbj_hub/domain/i_hub_server_controller.dart';
import 'package:cbj_hub/infrastructure/remote_pipes/remote_pipes_client.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';


class BootUp {
  BootUp() {
    setup();
  }

  Future setup() async {
    VendorsConnectorConjecture();
    SearchDevices().startSearchIsolate(NetworkUtilities());

    await Future.delayed(const Duration(milliseconds: 3000));
    IHubServerController.instance;
    RemotePipesClient().startRemotePipesWhenThereIsConnectionToWww(
      // '127.0.0.1',
      'guypodservicename.cbjinni.com',
    );
  }
}
