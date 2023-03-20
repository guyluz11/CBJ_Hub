import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_printer_device/generic_printer_value_objects.dart';
import 'package:cbj_hub/infrastructure/devices/hp/hp_printer/hp_printer_entity.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';

class HpHelpers {
  static List<DeviceEntityAbstract> addDiscoverdDevice({
    required String mDnsName,
    required String ip,
    required String port,
    required CoreUniqueId? uniqueDeviceId,
  }) {
    CoreUniqueId uniqueDeviceIdTemp;

    if (uniqueDeviceId != null) {
      uniqueDeviceIdTemp = uniqueDeviceId;
    } else {
      uniqueDeviceIdTemp = CoreUniqueId();
    }
    final HpPrinterEntity lgDE = HpPrinterEntity(
      uniqueId: uniqueDeviceIdTemp,
      vendorUniqueId: VendorUniqueId.fromUniqueString(mDnsName),
      defaultName: DeviceDefaultName(mDnsName),
      entityStateGRPC: EntityState(DeviceStateGRPC.ack.toString()),
      senderDeviceOs: DeviceSenderDeviceOs('HP'),
      senderDeviceModel: DeviceSenderDeviceModel('UP7550PVG'),
      senderId: DeviceSenderId(),
      compUuid: DeviceCompUuid('34asdfrsd23gggg'),
      deviceMdnsName: DeviceMdnsName(mDnsName),
      lastKnownIp: DeviceLastKnownIp(ip),
      stateMassage: DeviceStateMassage('Hello World'),
      powerConsumption: DevicePowerConsumption('0'),
      printerSwitchState: GenericPrinterSwitchState(
        DeviceActions.actionNotSupported.toString(),
      ),
      devicePort: DevicePort(port),
    );

    return [lgDE];
  }
}
