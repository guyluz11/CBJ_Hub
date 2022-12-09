// import 'dart:io';
//
// import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
// import 'package:cbj_hub/infrastructure/devices/esphome/esphome_python_api/esphome_python_api.dart';
//
// class EspHomeRunPythonExecutables {
//   static Future<List<DeviceEntityAbstract>> getAllEntities(
//     HelperEspHomeDeviceInfo helperEspHomeDeviceInfo,
//   ) async {
//     const String devicePassword = 'MyPassword';
//
//     final String output = await Process.run(
//         '${helperEspHomeDeviceInfo.getProjectFilesLocation}/lib/infrastructure/devices/esphome/esphome_python_api/esphome_python_files/esphome_python_executables/get_esphome_entities',
//         <String>[
//           helperEspHomeDeviceInfo.address,
//           helperEspHomeDeviceInfo.port,
//           devicePassword,
//         ]).then((ProcessResult result) {
//       return result.stdout.toString();
//     });
//     print(output);
//
//     return [];
//   }
// }
