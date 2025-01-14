import 'dart:async';

import 'package:cbj_integrations_controller/domain/app_communication/i_app_communication_repository.dart';
import 'package:cbj_integrations_controller/infrastructure/devices/helper_methods/device_helper_methods.dart';
import 'package:cbj_integrations_controller/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_integrations_controller/infrastructure/hub_client/hub_client.dart';
import 'package:cbj_integrations_controller/utils.dart';
import 'package:grpc/grpc.dart';

// TODO: Replace with HubClient
class RemotePipesClient {
  static ClientChannel? channel;
  static CbjHubClient? stub;

  // createStreamWithRemotePipes
  ///  Turn smart device on
  static Future<void> createStreamWithHub(
    String addressToHub,
    int hubPort,
  ) async {
    channel = await _createCbjHubClient(addressToHub, hubPort);
    stub = CbjHubClient(channel!);

    ResponseStream<ClientStatusRequests> response;

    try {
      response = stub!.hubTransferEntities(
        /// Transfer all requests from hub to the remote pipes->app
        HubRequestsToApp.streamRequestsToApp
            .map(DeviceHelperMethods().dynamicToRequestsAndStatusFromHub)
            .handleError((error) {
          logger.e('Stream have error $error');
        }),
      );

      /// All responses from the app->remote pipes going int the hub
      IAppCommunicationRepository.instance.getFromApp(
        request: response,
        requestUrl: addressToHub,
        isRemotePipes: true,
      );
    } catch (e) {
      logger.e('Caught error: $e');
      await channel?.terminate();
    }
  }

  static Future<ClientChannel> _createCbjHubClient(
    String deviceIp,
    int hubPort,
  ) async {
    await channel?.terminate();
    return ClientChannel(
      deviceIp,
      port: hubPort,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
  }
}
