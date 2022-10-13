import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_blinds_device/generic_blinds_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_boiler_device/generic_boiler_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_light_device/generic_light_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_rgbw_light_device/generic_rgbw_light_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_smart_computer_device/generic_smart_computer_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_smart_plug_device/generic_smart_plug_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_smart_tv_device/generic_smart_tv_device_dtos.dart';
import 'package:cbj_hub/infrastructure/generic_devices/generic_switch_device/generic_switch_device_dtos.dart';
import 'package:cbj_hub/utils.dart';

class DeviceEntityDtoAbstract {
  DeviceEntityDtoAbstract();

  factory DeviceEntityDtoAbstract.fromDomain() {
    logger.v('DeviceEntityDtoAbstract.fromDomain');
    return DeviceEntityDtoAbstract();
  }

  factory DeviceEntityDtoAbstract.fromJson(Map<String, dynamic> json) {
    DeviceEntityDtoAbstract deviceEntityDtoAbstract = DeviceEntityDtoAbstract();
    final String jsonDeviceDtoClass = json['deviceDtoClass'].toString();

    if (jsonDeviceDtoClass == (GenericLightDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.light.toString()) {
      deviceEntityDtoAbstract = GenericLightDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericRgbwLightDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.rgbwLights.toString()) {
      deviceEntityDtoAbstract = GenericRgbwLightDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericBlindsDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.blinds.toString()) {
      deviceEntityDtoAbstract = GenericBlindsDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericBoilerDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.boiler.toString()) {
      deviceEntityDtoAbstract = GenericBoilerDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericSmartTvDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.smartTV.toString()) {
      deviceEntityDtoAbstract = GenericSmartTvDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericSwitchDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.switch_.toString()) {
      deviceEntityDtoAbstract = GenericSwitchDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericSmartPlugDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.smartPlug.toString()) {
      deviceEntityDtoAbstract = GenericSmartPlugDeviceDtos.fromJson(json);
    } else if (jsonDeviceDtoClass == (GenericSmartPlugDeviceDtos).toString() ||
        json['deviceTypes'] == DeviceTypes.smartComputer.toString()) {
      deviceEntityDtoAbstract = GenericSmartComputerDeviceDtos.fromJson(json);
    } else {
      throw 'DtoClassTypeDoesNotExist';
    }
    return deviceEntityDtoAbstract;
  }

  final String deviceDtoClassInstance = (DeviceEntityDtoAbstract).toString();

  Map<String, dynamic> toJson() {
    logger.v('DeviceEntityDtoAbstract to Json');
    return {};
  }

  DeviceEntityAbstract toDomain() {
    logger.v('ToDomain');
    return DeviceEntityNotAbstract();
  }
}
