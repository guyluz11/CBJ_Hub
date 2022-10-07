import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:mqtt_client/mqtt_client.dart';

abstract class IAppCommunicationRepository {
  Future<void> getFromApp({
    required Stream<ClientStatusRequests> request,
    required String requestUrl,
    required bool isRemotePipes,
  });

  void sendToApp(Stream<MqttPublishMessage> dataToSend);

  Future<void> startRemotePipesConnection(String remotePipesDomain);

  Future<void> startRemotePipesWhenThereIsConnectionToWww(
    String remotePipesDomain,
  );
}
