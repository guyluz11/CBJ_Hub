import 'dart:async';
import 'dart:convert';

import 'package:cbj_hub/infrastructure/app_communication/hub_app_server.dart';
import 'package:cbj_hub/infrastructure/remote_pipes_client.dart';
import 'package:cbj_hub/utils.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';
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
    // dataToSend.listen((MqttPublishMessage event) async {
    // logger.i('Got hub requests to app');

    //   ISavedDevicesRepo.instance
    //       .getAllDevices()
    //       .forEach((String id, deviceEntityToSend) {
    //     final DeviceEntityDtoBase deviceDtoAbstract =
    //         DeviceHelper.convertDomainToDto(deviceEntityToSend);
    //     HubRequestsToApp.streamRequestsToApp.sink.add(deviceDtoAbstract);
    //   });

    //   (await ISceneCbjRepository.instance.getAllScenesAsMap())
    //       .forEach((key, value) {
    //     HubRequestsToApp.streamRequestsToApp.sink.add(value.toInfrastructure());
    //   });
    // });
  }

  @override
  Future<void> getFromApp({
    required Stream<ClientStatusRequests> request,
    required String requestUrl,
    required bool isRemotePipes,
  }) async {
    request
        .listen(DeviceHelperMethods().handleClientStatusRequests)
        .onError((error) {
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
            'Entity does not have network\n'
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

  /// Trigger to send all areas from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllAreasFromHubRequestsStream() async {
    final Map<String, AreaEntity> allAreas = await IcSynchronizer().getAreas();

    if (allAreas.isEmpty) {
      logger.w("Can't find areas in the local DB");

      return;
    }
    allAreas.map((String id, AreaEntity d) {
      HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
      return MapEntry(id, jsonEncode(d.toInfrastructure().toJson()));
    });
  }

  /// Trigger to send all devices from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllEntitiesFromHubRequestsStream() async {
    final Map<String, DeviceEntityBase> allDevices =
        await IcSynchronizer().getEntities();

    allDevices.map((String id, DeviceEntityBase d) {
      HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
      return MapEntry(id, DeviceHelper.convertDomainToJsonString(d));
    });
  }

  /// Trigger to send all scenes from hub to app using the
  /// HubRequestsToApp stream
  @override
  Future<void> sendAllScenesFromHubRequestsStream() async {
    final Map<String, SceneCbjEntity> allScenes = IcSynchronizer().getScenes();

    if (allScenes.isNotEmpty) {
      allScenes.map((String id, SceneCbjEntity d) {
        HubRequestsToApp.streamRequestsToApp.sink.add(d.toInfrastructure());
        return MapEntry(id, jsonEncode(d.toInfrastructure().toJson()));
      });
    } else {
      // logger.w("Can't find any scenes in the local DB, sending empty");
      // final SceneCbjEntity emptyScene = SceneCbjEntity(
      //   uniqueId: UniqueId(),
      //   name: SceneCbjName('Empty'),
      //   backgroundColor: SceneCbjBackgroundColor(000.toString()),
      //   image: SceneCbjBackgroundImage(null),
      //   iconCodePoint: SceneCbjIconCodePoint(null),
      //   automationString: SceneCbjAutomationString(null),
      //   nodeRedFlowId: SceneCbjNodeRedFlowId(null),
      //   firstNodeId: SceneCbjFirstNodeId(null),
      //   lastDateOfExecute: SceneCbjLastDateOfExecute(null),
      //   entityStateGRPC:
      //       SceneCbjDeviceStateGRPC(EntityStateGRPC.ack.toString()),
      //   senderDeviceModel: SceneCbjSenderDeviceModel(null),
      //   senderDeviceOs: SceneCbjSenderDeviceOs(null),
      //   senderId: SceneCbjSenderId(null),
      //   compUuid: SceneCbjCompUuid(null),
      //   stateMassage: SceneCbjStateMassage(null),
      //   actions: [],
      // );
      // HubRequestsToApp.streamRequestsToApp.sink
      // .add(emptyScene.toInfrastructure());
    }
  }
}
