import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_rgbw_light_device/generic_rgbw_light_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/yeelight/yeelight_1se/yeelight_1se_entity.dart';
import 'package:cbj_hub/infrastructure/devices/yeelight/yeelight_device_value_objects.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/utils.dart';
import 'package:yeedart/yeedart.dart';

class YeelightHelpers {
  static DeviceEntityAbstract? addDiscoverdDevice({
    required DiscoveryResponse yeelightDevice,
    required CoreUniqueId? uniqueDeviceId,
  }) {
    CoreUniqueId uniqueDeviceIdTemp;

    if (uniqueDeviceId != null) {
      uniqueDeviceIdTemp = uniqueDeviceId;
    } else {
      uniqueDeviceIdTemp = CoreUniqueId();
    }

    final Yeelight1SeEntity yeelightDE = Yeelight1SeEntity(
      uniqueId: uniqueDeviceIdTemp,
      vendorUniqueId:
          VendorUniqueId.fromUniqueString(yeelightDevice.id.toString()),
      defaultName: DeviceDefaultName(
        yeelightDevice.name != '' ? yeelightDevice.name : 'Yeelight test 2',
      ),
      deviceStateGRPC: DeviceState(DeviceStateGRPC.ack.toString()),
      senderDeviceOs: DeviceSenderDeviceOs('yeelight'),
      senderDeviceModel: DeviceSenderDeviceModel('1SE'),
      senderId: DeviceSenderId(),
      compUuid: DeviceCompUuid('34asdfrsd23gggg'),
      deviceMdnsName: DeviceMdnsName('yeelink-light-colora_miap9C52'),
      lastKnownIp: DeviceLastKnownIp(yeelightDevice.address.address),
      stateMassage: DeviceStateMassage('Hello World'),
      powerConsumption: DevicePowerConsumption('0'),
      yeelightPort: YeelightPort(yeelightDevice.port.toString()),
      lightSwitchState:
          GenericRgbwLightSwitchState(yeelightDevice.powered.toString()),
      lightColorTemperature: GenericRgbwLightColorTemperature(
        yeelightDevice.colorTemperature.toString(),
      ),
      lightBrightness:
          GenericRgbwLightBrightness(yeelightDevice.brightness.toString()),
      lightColorAlpha: GenericRgbwLightColorAlpha('1.0'),
      lightColorHue: GenericRgbwLightColorHue(yeelightDevice.hue.toString()),
      lightColorSaturation: GenericRgbwLightColorSaturation(
        yeelightDevice.sat.toString(),
      ),
      lightColorValue: GenericRgbwLightColorValue('1.0'),
    );

    return yeelightDE;

    // TODO: Add if device type does not supported return null
    logger.i(
      'Please add new Yeelight device type ${yeelightDevice.model}',
    );
    return null;
  }
}
