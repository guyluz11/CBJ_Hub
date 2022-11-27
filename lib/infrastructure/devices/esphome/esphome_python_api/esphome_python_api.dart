import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_python_api/esphome_python_json_objects_type.dart';
import 'package:cbj_hub/utils.dart';
import 'package:python_shell/python_shell.dart';

class EspHomePythonApi {
  static List<String> requeiredPythonPackages = ['aioesphomeapi'];

  static Future<List<DeviceEntityAbstract>> getAllEntities(
    HelperEspHomeDeviceInfo helperEspHomeDeviceInfo,
  ) async {
    const String devicePassword = 'MyPassword';
    final List<DeviceEntityAbstract> devicesList = [];

    try {
      final instance = ShellManager.getInstance("default");

      String? currentType;

      final ShellListener shellListener = ShellListener(
        onMessage: (String message) {
          if (currentType != null) {
            final DeviceEntityAbstract? convertedDevice =
                EsphomePythonJsonObjectsType.getDeviceAsAbstractIfExist(
              currentType: currentType!,
              deviceJson: message,
              address: helperEspHomeDeviceInfo.address,
              mDnsName: helperEspHomeDeviceInfo.mDnsName,
              port: helperEspHomeDeviceInfo.port,
            );
            if (convertedDevice != null) {
              devicesList.add(convertedDevice);
            }
            currentType = null;
          } else {
            currentType = message;
          }
        },
        onComplete: () {
          logger.v('EspHome device scan done');
        },
        onError: (object, stackTrace) {
          logger.v('EspHome device scan error $object\n$stackTrace');
        },
      );

      await instance.runFile(
        '${helperEspHomeDeviceInfo.getProjectFilesLocation}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/get_esphome_entities.py',
        listener: shellListener,
        arguments: [
          helperEspHomeDeviceInfo.address,
          helperEspHomeDeviceInfo.port,
          devicePassword,
        ],
        echo: false,
      );
    } catch (e) {
      logger.e('Error while getting all ESPHome entities\n$e');
    }
    return devicesList;
  }

  static Future<void> turnOnOffLightEntity(
    HelperEspHomeDeviceInfo helperEspHomeDeviceInfo,
  ) async {
    final instance = ShellManager.getInstance("default");

    final ShellListener shellListener = ShellListener(
      onMessage: (String message) {},
      onComplete: () {
        logger.v('EspHome device scan done');
      },
      onError: (object, stackTrace) {
        logger.v('EspHome device scan error $object\n$stackTrace');
      },
    );

    await instance.runFile(
      '${helperEspHomeDeviceInfo.getProjectFilesLocation}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/turn_on_off_light_entity_esphome_devices.py',
      listener: shellListener,
      arguments: [
        helperEspHomeDeviceInfo.address,
        helperEspHomeDeviceInfo.port,
        helperEspHomeDeviceInfo.devicePassword,
        helperEspHomeDeviceInfo.deviceKey,
        helperEspHomeDeviceInfo.newState,
      ],
      echo: false,
    );
  }

  static Future<void> turnOnOffSwitchEntity(
    HelperEspHomeDeviceInfo helperEspHomeDeviceInfo,
  ) async {
    final instance = ShellManager.getInstance("default");

    final ShellListener shellListener = ShellListener(
      onMessage: (String message) {},
      onComplete: () {
        logger.v('EspHome device scan done');
      },
      onError: (object, stackTrace) {
        logger.v('EspHome device scan error $object\n$stackTrace');
      },
    );

    await instance.runFile(
      '${helperEspHomeDeviceInfo.getProjectFilesLocation}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/turn_on_off_switch_entity_esphome_devices.py',
      listener: shellListener,
      arguments: [
        helperEspHomeDeviceInfo.address,
        helperEspHomeDeviceInfo.port,
        helperEspHomeDeviceInfo.devicePassword,
        helperEspHomeDeviceInfo.deviceKey,
        helperEspHomeDeviceInfo.newState,
      ],
      echo: false,
    );
  }
}

class HelperEspHomeDeviceInfo {
  HelperEspHomeDeviceInfo({
    required this.address,
    required this.port,
    required this.deviceKey,
    required this.newState,
    required this.mDnsName,
    required this.devicePassword,
    required this.getProjectFilesLocation,
  });

  String address;
  String port;
  String deviceKey;
  String newState;
  String mDnsName;
  String devicePassword;
  String getProjectFilesLocation;
}
