import 'dart:async';

import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/vendors/ewelink_login/generic_ewelink_login_entity.dart';
import 'package:cbj_hub/infrastructure/devices/ewelink/ewelink_helpers.dart';
import 'package:cbj_hub/infrastructure/generic_devices/abstract_device/abstract_company_connector_conjector.dart';
import 'package:cbj_hub/utils.dart';
import 'package:dart_ewelink_api/dart_ewelink_api.dart';
import 'package:injectable/injectable.dart';
import 'package:network_tools/network_tools.dart';

@singleton
class EwelinkConnectorConjector implements AbstractCompanyConnectorConjector {
  static const List<String> mdnsTypes = ['_ewelink._tcp'];

  Ewelink? ewelink;

  @override
  Map<String, DeviceEntityAbstract> companyDevices = {};

  Future<String> accountLogin(
    GenericEwelinkLoginDE loginDE,
  ) async {
    try {
      ewelink = Ewelink(
        email: '',
        password: '',
        region: 'us',
      );

      await ewelink!.getCredentials();
      discoverNewDevices(activeHost: null);
    } on EwelinkInvalidAccessToken {
      logger.e('invalid access token');
    } on EwelinkOfflineDeviceException {
      logger.e('device is offline');
    } catch (e) {
      logger.e('error: ${e.toString()}');
    }
    return 'Success';
  }

  Future<void> discoverNewDevices({
    required ActiveHost? activeHost,
  }) async {
    if (ewelink == null) {
      await accountLogin(GenericEwelinkLoginDE.empty());
      logger.w(
          'eWeLink device got found but missing a email and password, please add '
          'it in the app');
      // return;
    }
    final List<EwelinkDevice> devices = await ewelink!.getDevices();

    for (EwelinkDevice ewelinkDevice in devices) {
      EwelinkHelpers.addDiscoverdDevice(ewelinkDevice);
    }
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
