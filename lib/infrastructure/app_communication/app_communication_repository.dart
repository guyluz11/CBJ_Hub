import 'dart:async';
import 'dart:convert';

import 'package:cbj_hub/infrastructure/app_communication/hub_app_server.dart';
import 'package:cbj_hub/infrastructure/remote_pipes/remote_pipes_client.dart';
import 'package:cbj_hub/utils.dart';
import 'package:cbj_integrations_controller/domain/core/value_objects.dart';
import 'package:cbj_integrations_controller/domain/i_app_communication_repository.dart';
import 'package:cbj_integrations_controller/domain/i_saved_devices_repo.dart';
import 'package:cbj_integrations_controller/domain/i_saved_rooms_repo.dart';
import 'package:cbj_integrations_controller/domain/room/room_entity.dart';
import 'package:cbj_integrations_controller/domain/scene/i_scene_cbj_repository.dart';
import 'package:cbj_integrations_controller/domain/scene/scene_cbj_entity.dart';
import 'package:cbj_integrations_controller/domain/scene/value_objects_scene_cbj.dart';
import 'package:cbj_integrations_controller/infrastructure/core/injection.dart';
import 'package:cbj_integrations_controller/infrastructure/devices/device_helper/device_helper.dart';
import 'package:cbj_integrations_controller/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_devices/abstract_device/device_entity_dto_abstract.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_devices/generic_empty_device/generic_empty_entity.dart';
import 'package:cbj_integrations_controller/infrastructure/hub_client/hub_client.dart';
import 'package:grpc/grpc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mqtt_client/mqtt_client.dart';

class AppCommunicationRepository extends IAppCommunicationRepository {
  AppCommunicationRepository() {
    IAppCommunicationRepository.instance = this;
    if (currentEnv == Env.prod) {
      hubPort = 50055;
    } else {
      hubPort = 60055;
    }
    startLocalServer();
  }

  /// Port to connect to the cbj hub, will change according to the current
  /// running environment
  late int hubPort;

  Future startLocalServer() async {
    final server = Server.create(services: [HubAppServer()]);
    await server.serve(port: hubPort);
    logger.i('Hub Server listening for apps clients on port ${server.port}...');
  }

  @override
  Future<void> startRemotePipesConnection(String remotePipesDomain) async {
    const int remotePipesPort = 50056;
    RemotePipesClient.createStreamWithHub(
      remotePipesDomain,
      // 'homeservice-one-service.default.g.com',
      remotePipesPort,
    );
    await Future.delayed(const Duration(minutes: 1));
    RemotePipesClient.createStreamWithHub(
      remotePipesDomain,
      // 'homeservice-one-service.default.g.com',
      remotePipesPort,
    );

    // Here for easy find and local testing
    // RemotePipesClient.createStreamWithHub('127.0.0.1', 50056);
    logger.i(
      'Creating connection with remote pipes to the domain $remotePipesDomain'
      ' on port $remotePipesPort',
    );
  }

  @override
  Future<void> startRemotePipesWhenThereIsConnectionToWww(
    String remotePipesDomain,
  ) async {
    while (true) {
      final bool result = await InternetConnectionChecker().hasConnection;
      if (result) {
        break;
      }
      await Future.delayed(const Duration(minutes: 2));
    }
    logger.i('Internet detected, will try to reconnect to Remote Pipes');
    startRemotePipesConnection(remotePipesDomain);
  }

  void sendToApp(Stream<MqttPublishMessage> dataToSend) {
    dataToSend.listen((MqttPublishMessage event) async {
      logger.i('Got hub requests to app');

      ISavedDevicesRepo.instance
          .getAllDevices()
          .forEach((String id, deviceEntityToSend) {
        final DeviceEntityDtoAbstract deviceDtoAbstract =
            DeviceHelper.convertDomainToDto(deviceEntityToSend);
        HubRequestsToApp.streamRequestsToApp.sink.add(deviceDtoAbstract);
      });

      (await ISceneCbjRepository.instance.getAllScenesAsMap())
          .forEach((key, value) {
        HubRequestsToApp.streamRequestsToApp.sink.add(value.toInfrastructure());
      });
    });
  }

  @override
  Future<void> getFromApp({
    required Stream<ClientStatusRequests> request,
    required String requestUrl,
    required bool isRemotePipes,
  }) async {
    request.listen((event) async {}).onError((error) {
      if (error is GrpcError && error.code == 1) {
        logger.t('Client have disconnected');
      } else if (error is GrpcError && error.code == 14) {
        final String errorMessage = error.message!;

        if (error.message == null || !isRemotePipes) {
          logger.e('Client stream error without message\n$error');
        } else if (!errorMessage.contains('errorCode: 0')) {
          logger.i('Closing last stream\n$error');
        }

        /// Request reached the internet but the didn't arrive to remote pipes
        /// service
        else if (!errorMessage.contains('errno = -2')) {
          logger.e(
            'Remote Pipes service does not exist, check URL\n'
            '$error',
          );
        }

        /// Request didn't reached the internet
        else if (!errorMessage.contains('errno = -3')) {
          logger.w(
            'Device does not have network\n'
            '$error',
          );
          startRemotePipesWhenThereIsConnectionToWww(requestUrl);
          return;
        }
        logger.e(
          'Un none errno number\n'
          '$error',
        );
      } else {
        if (error is GrpcError &&
            isRemotePipes &&
            error.message != null &&
            !error.message!.contains('errorCode: 0')) {
          logger.i('Client stream got terminated to create new one\n$error');
          startRemotePipesWhenThereIsConnectionToWww(requestUrl);
          return;
        }
        logger.e('Client stream error\n$error');
      }
    });
  }

  /// Trigger to send all rooms from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllRoomsFromHubRequestsStream() async {
    final Map<String, RoomEntity> allRooms =
        ISavedRoomsRepo.instance.getAllRooms();

    if (allRooms.isEmpty) {
      logger.w("Can't find rooms in the local DB");

      return;
    }
    allRooms.map((String id, RoomEntity d) {
      HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
      return MapEntry(id, jsonEncode(d.toInfrastructure().toJson()));
    });
  }

  /// Trigger to send all devices from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllDevicesFromHubRequestsStream() async {
    final Map<String, DeviceEntityAbstract> allDevices =
        ISavedDevicesRepo.instance.getAllDevices();

    final Map<String, RoomEntity> allRooms =
        ISavedRoomsRepo.instance.getAllRooms();

    if (allRooms.isEmpty) {
      logger.w("Can't find smart devices in the local DB, sending empty");
      final DeviceEntityAbstract emptyEntity = GenericEmptyDE.empty();
      HubRequestsToApp.streamRequestsToApp.sink
          .add(emptyEntity.toInfrastructure());
      return;
    }

    /// The delay fix this issue in gRPC for some reason
    /// https://github.com/grpc/grpc-dart/issues/558
    allRooms.map((String id, RoomEntity d) {
      HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
      return MapEntry(id, jsonEncode(d.toInfrastructure().toJson()));
    });

    allDevices.map((String id, DeviceEntityAbstract d) {
      HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
      return MapEntry(id, DeviceHelper.convertDomainToJsonString(d));
    });
  }

  /// Trigger to send all scenes from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllScenesFromHubRequestsStream() async {
    final Map<String, SceneCbjEntity> allScenes =
        await ISceneCbjRepository.instance.getAllScenesAsMap();

    if (allScenes.isNotEmpty) {
      allScenes.map((String id, SceneCbjEntity d) {
        HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
        return MapEntry(id, jsonEncode(d.toInfrastructure().toJson()));
      });
    } else {
      logger.w("Can't find any scenes in the local DB, sending empty");
      final SceneCbjEntity emptyScene = SceneCbjEntity(
        uniqueId: UniqueId(),
        name: SceneCbjName('Empty'),
        backgroundColor: SceneCbjBackgroundColor(000.toString()),
        image: SceneCbjBackgroundImage(null),
        iconCodePoint: SceneCbjIconCodePoint(null),
        automationString: SceneCbjAutomationString(null),
        nodeRedFlowId: SceneCbjNodeRedFlowId(null),
        firstNodeId: SceneCbjFirstNodeId(null),
        lastDateOfExecute: SceneCbjLastDateOfExecute(null),
        entityStateGRPC:
            SceneCbjDeviceStateGRPC(EntityStateGRPC.ack.toString()),
        senderDeviceModel: SceneCbjSenderDeviceModel(null),
        senderDeviceOs: SceneCbjSenderDeviceOs(null),
        senderId: SceneCbjSenderId(null),
        compUuid: SceneCbjCompUuid(null),
        stateMassage: SceneCbjStateMassage(null),
      );
      HubRequestsToApp.streamRequestsToApp.sink
          .add(emptyScene.toInfrastructure());
    }
  }
}
