import 'dart:io';

import 'package:cbj_hub/utils.dart';
import 'package:cbj_integrations_controller/integrations_controller.dart';
import 'package:grpc/service_api.dart';

/// Server to get and send information to the app
class HubAppServer extends CbjHubServiceBase {
  @override
  Stream<RequestsAndStatusFromHub> clientTransferEntities(
    ServiceCall call,
    Stream<ClientStatusRequests> request,
  ) async* {
    try {
      logger.t('Got new Client');

      IAppCommunicationRepository.instance.getFromApp(
        request: request,
        requestUrl: 'Error, Hub does not suppose to have request URL',
        isRemotePipes: false,
      );

      yield* HubRequestsToApp.streamRequestsToApp
          .map(DeviceHelperMethods().dynamicToRequestsAndStatusFromHub)
          .handleError((error) => logger.e('Stream have error $error'));
    } catch (e) {
      logger.e('Hub server error $e');
    }
  }

  @override
  Future<CompHubInfo> getCompHubInfo(
    ServiceCall call,
    CompHubInfo request,
  ) async {
    logger.i('Hub info got requested');

    final CbjHubIno cbjHubIno = CbjHubIno(
      entityName: 'cbj Hub',
      protoLastGenDate: hubServerProtocGenDate,
      dartSdkVersion: Platform.version,
    );

    final CompHubSpecs compHubSpecs = CompHubSpecs(
      compOs: Platform.operatingSystem,
    );

    final CompHubInfo compHubInfo = CompHubInfo(
      cbjInfo: cbjHubIno,
      compSpecs: compHubSpecs,
    );
    return compHubInfo;
  }

  @override
  Stream<ClientStatusRequests> hubTransferEntities(
    ServiceCall call,
    Stream<RequestsAndStatusFromHub> request,
  ) async* {
    // TODO: implement registerHub
    throw UnimplementedError();
  }
}
