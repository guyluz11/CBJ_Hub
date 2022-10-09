import 'package:cbj_hub/domain/generic_devices/generic_smart_computer_device/generic_smart_computer_entity.dart';

class CbjSmartComputerEntity extends GenericSmartComputerDE {
  CbjSmartComputerEntity({
    required super.uniqueId,
    required super.vendorUniqueId,
    required super.deviceVendor,
    required super.defaultName,
    required super.deviceStateGRPC,
    required super.stateMassage,
    required super.senderDeviceOs,
    required super.senderDeviceModel,
    required super.senderId,
    required super.compUuid,
    required super.smartComputerSuspendState,
    required super.smartComputerShutDownState,
  }) {}
}
