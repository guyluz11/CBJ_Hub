import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_python_api/esphome_python_api.dart';
import 'package:cbj_hub/utils.dart';

class EspHomeHelpers {
  static Future<List<DeviceEntityAbstract>> addDiscoverdDevice({
    required String address,
    required String mDnsName,
    required CoreUniqueId? uniqueDeviceId,
    String port = '6053',
  }) async {
    CoreUniqueId uniqueDeviceIdTemp;

    if (uniqueDeviceId != null) {
      uniqueDeviceIdTemp = uniqueDeviceId;
    } else {
      uniqueDeviceIdTemp = CoreUniqueId();
    }

    final List<DeviceEntityAbstract> deviceEntityList =
        await EspHomePythonApi.getAllDevices(
      address: address,
      mDnsName: mDnsName,
      port: port,
    );
    logger.i(deviceEntityList);

    return deviceEntityList;
  }
}
