import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_light_device/generic_light_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/esphome/esphome_light/esphome_light_entity.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pb.dart';

class EspHomeHelpers {
  static Future<List<DeviceEntityAbstract>> addDiscoverdEntities({
    required String address,
    required String mDnsName,
    String port = '6053',
  }) async {
    // final HelperEspHomeDeviceInfo helperEspHomeDeviceInfo =
    //     HelperEspHomeDeviceInfo(
    //   address: address,
    //   port: port,
    //   deviceKey: 'null',
    //   newState: 'null',
    //   mDnsName: mDnsName,
    //   devicePassword: 'MyPassword',
    //   getProjectFilesLocation:
    //       await getIt<SystemCommandsManager>().getProjectFilesLocation(),
    // );
    // final List<DeviceEntityAbstract> deviceEntityList =
    //     await compute(EspHomePythonApi.getAllEntities, helperEspHomeDeviceInfo);

    final List<DeviceEntityAbstract> deviceEntityList = [
      EspHomeLightEntity(
        uniqueId: CoreUniqueId(),
        vendorUniqueId: VendorUniqueId.fromUniqueString('mac address'),
        defaultName: DeviceDefaultName('EspDevice Light'),
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
        espHomeKey: EspHomeKey(''),
        lastKnownIp: DeviceLastKnownIp(address),
      ),
    ];

    return deviceEntityList;
  }
}
