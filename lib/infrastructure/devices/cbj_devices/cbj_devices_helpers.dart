// import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
// import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
// import 'package:cbj_hub/domain/generic_devices/generic_blinds_device/generic_blinds_value_objects.dart';
// import 'package:cbj_hub/domain/generic_devices/generic_boiler_device/generic_boiler_value_objects.dart';
// import 'package:cbj_hub/infrastructure/devices/cbjDevices/cbjDevices_api/cbjDevices_api_object.dart';
// import 'package:cbj_hub/infrastructure/devices/cbjDevices/cbjDevices_device_value_objects.dart';
// import 'package:cbj_hub/infrastructure/devices/cbjDevices/cbjDevices_runner/cbjDevices_runner_entity.dart';
// import 'package:cbj_hub/infrastructure/devices/cbjDevices/cbjDevices_v2/cbjDevices_v2_entity.dart';
// import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
// import 'package:cbj_hub/utils.dart';
//
// class CbjDevicesHelpers {
//   static DeviceEntityAbstract? addDiscoverdDevice({
//     required CbjDevicesApiObject cbjDevicesDevice,
//     required CoreUniqueId? uniqueDeviceId,
//   }) {
//     CoreUniqueId uniqueDeviceIdTemp;
//
//     if (uniqueDeviceId != null) {
//       uniqueDeviceIdTemp = uniqueDeviceId;
//     } else {
//       uniqueDeviceIdTemp = CoreUniqueId();
//     }
//
//     if (cbjDevicesDevice.deviceType ==
//             CbjDevicesDevicesTypes.cbjDevicesRunner ||
//         cbjDevicesDevice.deviceType ==
//             CbjDevicesDevicesTypes.cbjDevicesRunnerMini) {
//       DeviceActions deviceActions = DeviceActions.actionNotSupported;
//
//       if (cbjDevicesDevice.deviceDirection == CbjDevicesDeviceDirection.up) {
//         deviceActions = DeviceActions.moveUp;
//       } else if (cbjDevicesDevice.deviceDirection ==
//           CbjDevicesDeviceDirection.stop) {
//         deviceActions = DeviceActions.stop;
//       } else if (cbjDevicesDevice.deviceDirection ==
//           CbjDevicesDeviceDirection.down) {
//         deviceActions = DeviceActions.moveDown;
//       }
//
//       final CbjDevicesRunnerEntity cbjDevicesRunnerDe = CbjDevicesRunnerEntity(
//         uniqueId: uniqueDeviceIdTemp,
//         vendorUniqueId:
//             VendorUniqueId.fromUniqueString(cbjDevicesDevice.deviceId),
//         defaultName: DeviceDefaultName(cbjDevicesDevice.cbjDevicesName),
//         deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
//         senderDeviceOs: DeviceSenderDeviceOs('cbjDevices'),
//         senderDeviceModel:
//             DeviceSenderDeviceModel(cbjDevicesDevice.deviceType.toString()),
//         senderId: DeviceSenderId(),
//         compUuid: DeviceCompUuid('34asdfrsd23gggg'),
//         lastKnownIp: DeviceLastKnownIp(cbjDevicesDevice.cbjDevicesIp),
//         stateMassage: DeviceStateMassage('Hello World'),
//         powerConsumption:
//             DevicePowerConsumption(cbjDevicesDevice.powerConsumption),
//         cbjDevicesPort: CbjDevicesPort(cbjDevicesDevice.port.toString()),
//         cbjDevicesMacAddress: CbjDevicesMacAddress(cbjDevicesDevice.macAddress),
//         blindsSwitchState: GenericBlindsSwitchState(
//           deviceActions.toString(),
//         ),
//       );
//
//       return cbjDevicesRunnerDe;
//     } else if (cbjDevicesDevice.deviceType ==
//             CbjDevicesDevicesTypes.cbjDevicesMini ||
//         cbjDevicesDevice.deviceType == CbjDevicesDevicesTypes.cbjDevicesTouch ||
//         cbjDevicesDevice.deviceType == CbjDevicesDevicesTypes.cbjDevicesV2Esp ||
//         cbjDevicesDevice.deviceType ==
//             CbjDevicesDevicesTypes.cbjDevicesV2qualcomm ||
//         cbjDevicesDevice.deviceType == CbjDevicesDevicesTypes.cbjDevicesV4) {
//       DeviceActions deviceActions = DeviceActions.actionNotSupported;
//       if (cbjDevicesDevice.deviceState == CbjDevicesDeviceState.on) {
//         deviceActions = DeviceActions.on;
//       } else if (cbjDevicesDevice.deviceState == CbjDevicesDeviceState.off) {
//         deviceActions = DeviceActions.off;
//       }
//       final CbjDevicesV2Entity cbjDevicesV2De = CbjDevicesV2Entity(
//         uniqueId: uniqueDeviceIdTemp,
//         vendorUniqueId:
//             VendorUniqueId.fromUniqueString(cbjDevicesDevice.deviceId),
//         defaultName: DeviceDefaultName(cbjDevicesDevice.cbjDevicesName),
//         deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
//         senderDeviceOs: DeviceSenderDeviceOs('cbjDevices'),
//         senderDeviceModel:
//             DeviceSenderDeviceModel(cbjDevicesDevice.deviceType.toString()),
//         senderId: DeviceSenderId(),
//         compUuid: DeviceCompUuid('34asdfrsd23gggg'),
//         lastKnownIp: DeviceLastKnownIp(cbjDevicesDevice.cbjDevicesIp),
//         stateMassage: DeviceStateMassage('Hello World'),
//         powerConsumption:
//             DevicePowerConsumption(cbjDevicesDevice.powerConsumption),
//         boilerSwitchState: GenericBoilerSwitchState(deviceActions.toString()),
//         cbjDevicesPort: CbjDevicesPort(cbjDevicesDevice.port.toString()),
//         cbjDevicesMacAddress: CbjDevicesMacAddress(cbjDevicesDevice.macAddress),
//       );
//
//       return cbjDevicesV2De;
//     }
//
//     logger.i(
//       'Please add new CbjDevices device type ${cbjDevicesDevice.deviceType}',
//     );
//     return null;
//   }
// }
