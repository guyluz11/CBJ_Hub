import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/utils.dart';
import 'package:dart_ewelink_api/dart_ewelink_api.dart';

class EwelinkHelpers {
  static DeviceEntityAbstract? addDiscoverdDevice(EwelinkDevice ewelinkDevice) {
    logger.i(ewelinkDevice.name);
    logger.i(ewelinkDevice.type);
    if (ewelinkDevice.type == 'a9') {}
    if (ewelinkDevice.type == '10') {}
    return null;
  }
}
