import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/generic_rgbw_light_device/generic_rgbw_light_entity.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_converter.dart';

class CommonDevicesScenesPresetsForDevices {
  static MapEntry<String, String> rgbLightOnPreset(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) {
    final String property =
        GenericRgbwLightDE.empty().getListOfPropertiesToChange()[0];
    final String action = DeviceActions.on.toString();

    return NodeRedConverter.convertToNodeString(
      device: deviceEntity,
      brokerNodeId: brokerNodeId,
      property: property,
      action: action,
    );
  }

  static MapEntry<String, String> rgbwLightOffPreset(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) {
    final String property =
        GenericRgbwLightDE.empty().getListOfPropertiesToChange()[0];
    final String action = DeviceActions.off.toString();

    return NodeRedConverter.convertToNodeString(
      device: deviceEntity,
      brokerNodeId: brokerNodeId,
      property: property,
      action: action,
    );
  }
  //
  // static MapEntry<String, String> rgbLightOrangePreset() {
  //   return 'Orange';
  // }
  //
  // static MapEntry<String, String> rgbLightWhitePreset() {
  //   return 'White';
  // }

  // static MapEntry<String, String> rgbLightBluePreset(
  //   DeviceEntityAbstract deviceEntity,
  //   String firstNodeId,
  // ) {
  // }

  // static MapEntry<String, String> blindsUpPreset() {
  //   return 'BlindsUp';
  // }
  //
  // static MapEntry<String, String> blindsStopPreset() {
  //   return 'BlindsStop';
  // }
  //
  // static MapEntry<String, String> blindsDownPreset() {
  //   return 'BlindsDown';
  // }
}
