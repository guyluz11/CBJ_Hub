import 'dart:io';

import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_python_api/esphome_python_json_objects_type.dart';
import 'package:cbj_hub/utils.dart';
import 'package:python_shell/python_shell.dart';

class EspHomePythonApi {
  static List<String> requeiredPythonPackages = ['aioesphomeapi'];

  static Future<List<DeviceEntityAbstract>> getAllDevices({
    required String address,
    required String mDnsName,
    required String port,
  }) async {
    const String devicePassword = 'MyPassword';

    final shell = PythonShell(PythonShellConfig());
    await shell.initialize();

    final instance = ShellManager.getInstance("default");
    instance.installRequires(requeiredPythonPackages);

    String? currentType;

    final List<DeviceEntityAbstract> devicesList = [];

    final ShellListener shellListener = ShellListener(
      onMessage: (String message) {
        if (currentType != null) {
          final DeviceEntityAbstract? convertedDevice =
              EsphomePythonJsonObjectsType.getDeviceAsAbstractIfExist(
            currentType: currentType!,
            deviceJson: message,
            address: address,
            mDnsName: mDnsName,
            port: port,
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

    logger.i('Path: ${Directory.current.path}');

    await instance.runFile(
      '${Directory.current.path}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/get_esphome_devices.py',
      listener: shellListener,
      arguments: [
        address,
        port,
        devicePassword,
      ],
      echo: false,
    );
    return devicesList;
  }

  static Future<void> turnOnOffDevice({
    required String address,
    required String port,
    required String deviceKey,
    required String newState,
  }) async {
    const String devicePassword = 'MyPassword';

    final shell = PythonShell(PythonShellConfig());
    await shell.initialize();

    final instance = ShellManager.getInstance("default");
    instance.installRequires(requeiredPythonPackages);

    final ShellListener shellListener = ShellListener(
      onMessage: (String message) {},
      onComplete: () {
        logger.v('EspHome device scan done');
      },
      onError: (object, stackTrace) {
        logger.v('EspHome device scan error $object\n$stackTrace');
      },
    );

    logger.i('Path: ${Directory.current.path}');

    await instance.runFile(
      '${Directory.current.path}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/turn_on_off_device_esphome_devices.py',
      listener: shellListener,
      arguments: [
        address,
        port,
        devicePassword,
      ],
      echo: false,
    );
  }
}
