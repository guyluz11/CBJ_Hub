import 'dart:async';

import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/vendors/ewelink_login/generic_ewelink_login_entity.dart';
import 'package:cbj_hub/infrastructure/generic_devices/abstract_device/abstract_company_connector_conjector.dart';
import 'package:cbj_hub/utils.dart';
import 'package:injectable/injectable.dart';
import 'package:network_tools/network_tools.dart';

@singleton
class EwelinkConnectorConjector implements AbstractCompanyConnectorConjector {
  @override
  Map<String, DeviceEntityAbstract> companyDevices = {};

  Future<String> accountLogin(
    GenericEwelinkLoginDE loginDE,
  ) async {
    logger.w('Ewelink login Not implemented yet');
    return '';
  }

  Future<void> discoverNewDevices({
    required ActiveHost activeHost,
  }) async {
    logger.w('Ewelink discover Not implemented yet');
  }

  @override
  Future<void> manageHubRequestsForDevice(
    DeviceEntityAbstract ewelinkDE,
  ) async {
    // final DeviceEntityAbstract? device =
    //     companyDevices[ewelinkDE.entityUniqueId.getOrCrash()];
    //
    // if (false) {
    //   // device.executeDeviceAction(newEntity: ewelinkDE);
    // } else {
    logger.w('Ewelink device type does not exist');
    // }
  }

  @override
  Future<void> setUpDeviceFromDb(DeviceEntityAbstract deviceEntity) async {
    DeviceEntityAbstract? nonGenericDevice;

    // if (deviceEntity is GenericRgbwLightDE) {
    //   nonGenericDevice = EwelinkGpx4021GlEntity.fromGeneric(deviceEntity);
    // }

    if (nonGenericDevice == null) {
      logger.w('Xiaomi mi device could not get loaded from the server');
      return;
    }

    companyDevices.addEntries([
      MapEntry(nonGenericDevice.entityUniqueId.getOrCrash(), nonGenericDevice),
    ]);
  }
}
