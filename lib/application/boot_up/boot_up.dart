import 'package:cbj_hub/application/connector/connector.dart';
import 'package:cbj_hub/infrastructure/cbj_web_server/cbj_web_server_repository.dart';
import 'package:cbj_hub/infrastructure/mqtt_server/mqtt_server_repository.dart';
import 'package:cbj_hub/infrastructure/room/saved_rooms_repo.dart';
import 'package:cbj_integrations_controller/initialize_integrations_controller.dart';

class BootUp {
  BootUp() {
    setup();
  }

  static Future<void> setup() async {
    // Return all saved rooms
    // TODO: Fix after new cbj_integrations_controller
    // final ISavedRoomsRepo savedRoomsRepo = ISavedRoomsRepo.instance;
    // TODO: Fix after new cbj_integrations_controller
    // final ISceneCbjRepository savedScenesRepo = getItCbj<ISceneCbjRepository>();

    // await savedRoomsRepo.getAllRooms();
    //
    // await savedScenesRepo.getAllScenesAsMap();
    setInstancesOfRepos();

    await setupIntegrationsController();

    Connector.startConnector();
  }

  /// All instances of Repos
  static void setInstancesOfRepos() {
    MqttServerRepository();
    CbjWebServerRepository();
    SavedRoomsRepo();
  }
}
