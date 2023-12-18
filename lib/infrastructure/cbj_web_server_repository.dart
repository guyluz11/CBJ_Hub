import 'dart:io';

import 'package:cbj_hub/domain/i_cbj_web_server_repository.dart';
import 'package:cbj_hub/utils.dart';
import 'package:cbj_integrations_controller/domain/i_saved_devices_repo.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_entities/abstract_entity/device_entity_base.dart';
import 'package:cbj_integrations_controller/infrastructure/generic_entities/abstract_entity/device_entity_dto_base.dart';

/// A cbj web server to interact with get current state requests from mqtt as
/// well as website to change devices state locally on the network without
/// the need of installing any app.
class CbjWebServerRepository extends ICbjWebServerRepository {
  CbjWebServerRepository() {
    ICbjWebServerRepository.instance = this;
    startWebServer();
  }

  int portNumber = 5058;

  @override
  Future<void> startWebServer() async {
    HttpServer.bind('127.0.0.1', portNumber).then((HttpServer server) {
      server.listen((HttpRequest request) async {
        final List<String> pathArgs = request.uri.pathSegments;
        if (pathArgs.length >= 3) {
          if (pathArgs[0] == 'Devices') {
            final String deviceId = pathArgs[1];

            final ISavedDevicesRepo savedDevicesRepo =
                ISavedDevicesRepo.instance;

            final Map<String, DeviceEntityBase> allDevices =
                savedDevicesRepo.getAllDevices();

            DeviceEntityBase? deviceObjectOfDeviceId;

            for (final DeviceEntityBase d in allDevices.values) {
              if (d.getDeviceId() == deviceId) {
                deviceObjectOfDeviceId = d;
                break;
              }
            }
            if (deviceObjectOfDeviceId != null) {
              final String requestedDeviceProperty = pathArgs[2];
              final DeviceEntityDtoBase deviceEntityDtoAbstract =
                  deviceObjectOfDeviceId.toInfrastructure();
              final Map<String, dynamic> deviceEntityJson =
                  deviceEntityDtoAbstract.toJson();
              String? requestedFielAction;
              for (final MapEntry<String, dynamic> filedAndValue
                  in deviceEntityJson.entries) {
                if (filedAndValue.key == requestedDeviceProperty) {
                  requestedFielAction = filedAndValue.value.toString();
                  break;
                }
              }
              if (requestedFielAction != null) {
                logger.i(
                  'Web server response of device id $deviceId with property $requestedDeviceProperty is action $requestedFielAction',
                );
                request.response.write(requestedFielAction);
              } else {
                logger.w(
                  'Device id $deviceId exist but requested property could not be found',
                );
                request.response.write('null');
              }
            } else {
              logger.w('Device id $deviceId does not exist');
              request.response.write('null');
            }
          } else {
            logger.w('pathArgs[0] is not supported ${pathArgs[0]}');
            request.response.write('null');
          }
        } else {
          logger.w('pathArgs.length  is lower that 3 ${pathArgs.length}');
        }
        request.response.close();
      });
    });
    return;
  }

  /// Get device state
  @override
  void getDeviceState(String id) {}
}
