import 'dart:async';

import 'package:cbj_hub/utils.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';
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

    try {
      final ResponseStream<ClientStatusRequests> response =
          stub!.hubTransferEntities(
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
