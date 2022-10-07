import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_blinds_device/generic_blinds_value_objects.dart';
import 'package:cbj_hub/domain/generic_devices/generic_boiler_device/generic_boiler_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/switcher/switcher_api/switcher_api_object.dart';
import 'package:cbj_hub/infrastructure/devices/switcher/switcher_device_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/switcher/switcher_runner/switcher_runner_entity.dart';
import 'package:cbj_hub/infrastructure/devices/switcher/switcher_v2/switcher_v2_entity.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/utils.dart';

class SwitcherHelpers {
  static DeviceEntityAbstract? addDiscoverdDevice({
    required SwitcherApiObject switcherDevice,
    required CoreUniqueId? uniqueDeviceId,
  }) {
    CoreUniqueId uniqueDeviceIdTemp;

    if (uniqueDeviceId != null) {
      uniqueDeviceIdTemp = uniqueDeviceId;
    } else {
      uniqueDeviceIdTemp = CoreUniqueId();
    }

    if (switcherDevice.deviceType == SwitcherDevicesTypes.switcherRunner ||
        switcherDevice.deviceType == SwitcherDevicesTypes.switcherRunnerMini) {
      DeviceActions deviceActions = DeviceActions.actionNotSupported;

      if (switcherDevice.deviceDirection == SwitcherDeviceDirection.up) {
        deviceActions = DeviceActions.moveUp;
      } else if (switcherDevice.deviceDirection ==
          SwitcherDeviceDirection.stop) {
        deviceActions = DeviceActions.stop;
      } else if (switcherDevice.deviceDirection ==
          SwitcherDeviceDirection.down) {
        deviceActions = DeviceActions.moveDown;
      }

      final SwitcherRunnerEntity switcherRunnerDe = SwitcherRunnerEntity(
        uniqueId: uniqueDeviceIdTemp,
        vendorUniqueId:
            VendorUniqueId.fromUniqueString(switcherDevice.deviceId),
        defaultName: DeviceDefaultName(switcherDevice.switcherName),
        deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
        senderDeviceOs: DeviceSenderDeviceOs('switcher'),
        senderDeviceModel:
            DeviceSenderDeviceModel(switcherDevice.deviceType.toString()),
        senderId: DeviceSenderId(),
        compUuid: DeviceCompUuid('34asdfrsd23gggg'),
        lastKnownIp: DeviceLastKnownIp(switcherDevice.switcherIp),
        stateMassage: DeviceStateMassage('Hello World'),
        powerConsumption:
            DevicePowerConsumption(switcherDevice.powerConsumption),
        switcherPort: SwitcherPort(switcherDevice.port.toString()),
        switcherMacAddress: SwitcherMacAddress(switcherDevice.macAddress),
        blindsSwitchState: GenericBlindsSwitchState(
          deviceActions.toString(),
        ),
      );

      return switcherRunnerDe;
    } else if (switcherDevice.deviceType == SwitcherDevicesTypes.switcherMini ||
        switcherDevice.deviceType == SwitcherDevicesTypes.switcherTouch ||
        switcherDevice.deviceType == SwitcherDevicesTypes.switcherV2Esp ||
        switcherDevice.deviceType == SwitcherDevicesTypes.switcherV2qualcomm ||
        switcherDevice.deviceType == SwitcherDevicesTypes.switcherV4) {
      DeviceActions deviceActions = DeviceActions.actionNotSupported;
      if (switcherDevice.deviceState == SwitcherDeviceState.on) {
        deviceActions = DeviceActions.on;
      } else if (switcherDevice.deviceState == SwitcherDeviceState.off) {
        deviceActions = DeviceActions.off;
      }
      final SwitcherV2Entity switcherV2De = SwitcherV2Entity(
        uniqueId: uniqueDeviceIdTemp,
        vendorUniqueId:
            VendorUniqueId.fromUniqueString(switcherDevice.deviceId),
        defaultName: DeviceDefaultName(switcherDevice.switcherName),
        deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
        senderDeviceOs: DeviceSenderDeviceOs('switcher'),
        senderDeviceModel:
            DeviceSenderDeviceModel(switcherDevice.deviceType.toString()),
        senderId: DeviceSenderId(),
        compUuid: DeviceCompUuid('34asdfrsd23gggg'),
        lastKnownIp: DeviceLastKnownIp(switcherDevice.switcherIp),
        stateMassage: DeviceStateMassage('Hello World'),
        powerConsumption:
            DevicePowerConsumption(switcherDevice.powerConsumption),
        boilerSwitchState: GenericBoilerSwitchState(deviceActions.toString()),
        switcherPort: SwitcherPort(switcherDevice.port.toString()),
        switcherMacAddress: SwitcherMacAddress(switcherDevice.macAddress),
      );

      return switcherV2De;
    }

    logger.i(
      'Please add new Switcher device type ${switcherDevice.deviceType}',
    );
    return null;
  }
}
