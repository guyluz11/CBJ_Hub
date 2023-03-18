import 'package:cbj_hub/domain/core/value_objects.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_light_device/generic_light_value_objects.dart';
import 'package:cbj_hub/domain/generic_devices/generic_switch_device/generic_switch_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_light/esphome_light_entity.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_node_red_api/esphome_node_red_api.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_node_red_api/esphome_node_red_server_api_calls.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_switch/esphome_switch_entity.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';

class EspHomeHelpers {
  static Future<List<DeviceEntityAbstract>> addDiscoverdEntities({
    required String address,
    required String mDnsName,
    String port = '6053',
  }) async {
    final String espHomeNodeDeviceId = UniqueId().getOrCrash();

    final String flowId = await EspHomeNodeRedApi.setNewEspHomeDeviceNode(
      deviceMdnsName: mDnsName,
      password: 'MyPassword',
      espHomeDeviceId: espHomeNodeDeviceId,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    final List<EspHomeDeviceEntityObject> entitiesList =
        await EspHomeNodeRedServerApiCalls.getEspHomeDeviceEntites(
      espHomeNodeDeviceId,
    );

    if (entitiesList.isEmpty) {
      return [];
    }

    final List<DeviceEntityAbstract> deviceEntityList = [];

    for (final EspHomeDeviceEntityObject espHomeDeviceEntityObject
        in entitiesList) {
      final String deviceKey =
          (espHomeDeviceEntityObject.config['key'] as int).toString();
      await EspHomeNodeRedApi.setNewStateNodes(
        espHomeDeviceId: espHomeNodeDeviceId,
        flowId: flowId,
        entityId: deviceKey,
      );

      if (espHomeDeviceEntityObject.type == 'Light') {
        deviceEntityList.add(
          EspHomeLightEntity(
            uniqueId: CoreUniqueId(),
            vendorUniqueId: VendorUniqueId.fromUniqueString(
              espHomeDeviceEntityObject.config['uniqueId'] as String,
            ),
            defaultName: DeviceDefaultName(espHomeDeviceEntityObject.name),
            deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
            stateMassage: DeviceStateMassage('Test'),
            senderDeviceOs: DeviceSenderDeviceOs('EspHome'),
            senderDeviceModel: DeviceSenderDeviceModel('Probably esp8266'),
            senderId: DeviceSenderId.fromUniqueString('Test'),
            compUuid: DeviceCompUuid('test'),
            powerConsumption: DevicePowerConsumption('0'),
            lightSwitchState: GenericLightSwitchState('on'),
            deviceMdnsName: DeviceMdnsName(mDnsName),
            devicePort: DevicePort(port),
            espHomeKey: EspHomeKey(deviceKey),
            lastKnownIp: DeviceLastKnownIp(address),
          ),
        );
      } else if (espHomeDeviceEntityObject.type == 'Switch') {
        deviceEntityList.add(
          EspHomeSwitchEntity(
            uniqueId: CoreUniqueId(),
            vendorUniqueId: VendorUniqueId.fromUniqueString(
              espHomeDeviceEntityObject.config['uniqueId'] as String,
            ),
            defaultName: DeviceDefaultName(espHomeDeviceEntityObject.name),
            deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
            stateMassage: DeviceStateMassage('Test'),
            senderDeviceOs: DeviceSenderDeviceOs('EspHome'),
            senderDeviceModel: DeviceSenderDeviceModel('Probably esp8266'),
            senderId: DeviceSenderId.fromUniqueString('Test'),
            compUuid: DeviceCompUuid('test'),
            powerConsumption: DevicePowerConsumption('0'),
            deviceMdnsName: DeviceMdnsName(mDnsName),
            devicePort: DevicePort(port),
            espHomeKey: EspHomeKey(deviceKey),
            lastKnownIp: DeviceLastKnownIp(address),
            switchState: GenericSwitchSwitchState('on'),
          ),
        );
      }
    }

    return deviceEntityList;
  }
}
