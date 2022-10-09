import 'dart:async';

import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/infrastructure/generic_devices/abstract_device/abstract_company_connector_conjector.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@singleton
class CbjDevicesConnectorConjector
    implements AbstractCompanyConnectorConjector {
  CbjDevicesConnectorConjector() {
    // _discoverNewDevices();
  }

  static Map<String, DeviceEntityAbstract> companyDevices = {};

  // Future<void> _discoverNewDevices() async {
  //   CbjDevicesDiscover.discover20002Devices().listen((cbjDevicesApiObject) {
  //     addOnlyNewCbjDevicesDevice(cbjDevicesApiObject);
  //   });
  //   CbjDevicesDiscover.discover20003Devices().listen((cbjDevicesApiObject) {
  //     addOnlyNewCbjDevicesDevice(cbjDevicesApiObject);
  //   });
  // }
  //
  // Future<void> addOnlyNewCbjDevicesDevice(
  //   CbjDevicesApiObject cbjDevicesApiObject,
  // ) async {
  //   CoreUniqueId? tempCoreUniqueId;
  //
  //   for (final DeviceEntityAbstract savedDevice in companyDevices.values) {
  //     if ((savedDevice is CbjDevicesV2Entity ||
  //             savedDevice is CbjDevicesRunnerEntity) &&
  //         cbjDevicesApiObject.deviceId ==
  //             savedDevice.vendorUniqueId.getOrCrash()) {
  //       return;
  //     } else if (savedDevice is GenericBoilerDE ||
  //         savedDevice is GenericBlindsDE &&
  //             cbjDevicesApiObject.deviceId ==
  //                 savedDevice.vendorUniqueId.getOrCrash()) {
  //       /// Device exist as generic and needs to get converted to non generic type for this vendor
  //       tempCoreUniqueId = savedDevice.uniqueId;
  //       break;
  //     } else if (cbjDevicesApiObject.deviceId ==
  //         savedDevice.vendorUniqueId.getOrCrash()) {
  //       logger.w(
  //         'CbjDevices device type supported but implementation is missing here',
  //       );
  //       break;
  //     }
  //   }
  //
  //   final DeviceEntityAbstract? addDevice =
  //       CbjDevicesHelpers.addDiscoverdDevice(
  //     cbjDevicesDevice: cbjDevicesApiObject,
  //     uniqueDeviceId: tempCoreUniqueId,
  //   );
  //   if (addDevice == null) {
  //     return;
  //   }
  //
  //   final DeviceEntityAbstract deviceToAdd =
  //       CompaniesConnectorConjector.addDiscoverdDeviceToHub(addDevice);
  //
  //   final MapEntry<String, DeviceEntityAbstract> deviceAsEntry =
  //       MapEntry(deviceToAdd.uniqueId.getOrCrash(), deviceToAdd);
  //
  //   companyDevices.addEntries([deviceAsEntry]);
  //
  //   logger
  //       .v('New cbjDevices devices name:${cbjDevicesApiObject.cbjDevicesName}');
  // }
  //
  // Future<Either<CoreFailure, Unit>> create(DeviceEntityAbstract cbjDevices) {
  //   // TODO: implement create
  //   throw UnimplementedError();
  // }
  //
  // Future<Either<CoreFailure, Unit>> delete(DeviceEntityAbstract cbjDevices) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }
  //
  // Future<void> initiateHubConnection() {
  //   // TODO: implement initiateHubConnection
  //   throw UnimplementedError();
  // }
  //
  // Future<void> manageHubRequestsForDevice(
  //   DeviceEntityAbstract cbjDevicesDE,
  // ) async {
  //   final DeviceEntityAbstract? device =
  //       companyDevices[cbjDevicesDE.getDeviceId()];
  //
  //   // if (device == null) {
  //   //   setTheSameDeviceFromAllDevices(cbjDevicesDE);
  //   //   device =
  //   //   companyDevices[cbjDevicesDE.getDeviceId()];
  //   // }
  //
  //   if (device != null &&
  //       (device is CbjDevicesV2Entity || device is CbjDevicesRunnerEntity)) {
  //     device.executeDeviceAction(newEntity: cbjDevicesDE);
  //   } else {
  //     logger.w('CbjDevices device type ${device.runtimeType} does not exist');
  //   }
  // }
  //
  // // Future<void> setTheSameDeviceFromAllDevices(
  // //   DeviceEntityAbstract cbjDevicesDE,
  // // ) async {
  // //   final String deviceVendorUniqueId = cbjDevicesDE.vendorUniqueId.getOrCrash();
  // //   for(a)
  // // }

  Future<Either<CoreFailure, Unit>> updateDatabase({
    required String pathOfField,
    required Map<String, dynamic> fieldsToUpdate,
    String? forceUpdateLocation,
  }) async {
    // TODO: implement updateDatabase
    throw UnimplementedError();
  }
}
