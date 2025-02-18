import 'package:cbj_hub/domain/i_hub_server_controller.dart';
import 'package:cbj_hub/infrastructure/hub_vendors_connector_conjecture.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';

class BootUp {
  BootUp() {
    setup();
  }

  Future setup() async {
    HubVendorsConnectorConjecture();
    SearchDevices()
        .startSearchIsolate(networkUtilitiesType: NetworkUtilities());

    await Future.delayed(const Duration(milliseconds: 3000));
    IHubServerController.instance;
    // RemotePipesClient().startRemotePipesWhenThereIsConnectionToWww(
    //   // '127.0.0.1',
    //   'guypodservicename.cbjinni.com',
    // );
  }
}
