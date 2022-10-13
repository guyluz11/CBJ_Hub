import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/device_type_enums.dart';
import 'package:cbj_hub/domain/generic_devices/generic_smart_computer_device/generic_smart_computer_entity.dart';
import 'package:cbj_hub/domain/generic_devices/generic_smart_computer_device/generic_smart_computer_value_objects.dart';
import 'package:cbj_hub/infrastructure/cbj_smart_device_client/cbj_smart_device_client.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/utils.dart';
import 'package:dartz/dartz.dart';

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
    required this.lastKnownIp,
  });

  DeviceLastKnownIp lastKnownIp;

  @override
  Future<Either<CoreFailure, Unit>> executeDeviceAction({
    required DeviceEntityAbstract newEntity,
  }) async {
    if (newEntity is! GenericSmartComputerDE) {
      return left(
        const CoreFailure.actionExcecuter(
          failedValue: 'Not the correct type',
        ),
      );
    }

    try {
      if (newEntity.smartComputerSuspendState!.getOrCrash() !=
          smartComputerSuspendState!.getOrCrash()) {
        final DeviceActions? actionToPreform =
            EnumHelperCbj.stringToDeviceAction(
          newEntity.smartComputerSuspendState!.getOrCrash(),
        );

        if (actionToPreform == DeviceActions.suspend) {
          (await suspendSmartComputer()).fold((l) {
            logger.e('Error suspending Cbj Computer');
            throw l;
          }, (r) {
            logger.i('Cbj Computer suspended success');
          });
        } else {
          logger.e('actionToPreform is not set correctly Cbj Computer');
        }
      }

      smartComputerSuspendState =
          GenericSmartComputerSuspendState(DeviceActions.itIsFalse.toString());

      return right(unit);
    } catch (e) {
      deviceStateGRPC = DeviceState(DeviceStateGRPC.newStateFailed.toString());
      return left(const CoreFailure.unexpected());
    }
  }

  /// Please override the following methods
  @override
  Future<Either<CoreFailure, Unit>> suspendSmartComputer() async {
    smartComputerSuspendState =
        GenericSmartComputerSuspendState(DeviceActions.itIsFalse.toString());

    await CbjSmartDeviceClient.suspendCbjSmartDeviceHostDevice(
      lastKnownIp.getOrCrash(),
      vendorUniqueId.getOrCrash(),
    );

    return left(
      const CoreFailure.actionExcecuter(
        failedValue: 'Action does not exist',
      ),
    );
  }
}