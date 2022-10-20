import 'dart:async';

import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_smart_tv/generic_smart_tv_entity.dart';
import 'package:cbj_hub/infrastructure/devices/google/chrome_cast_api/chrome_cast_api.dart';
import 'package:cbj_hub/infrastructure/devices/google/google_device_value_objects.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/utils.dart';
import 'package:dart_chromecast/casting/cast.dart';
import 'package:dartz/dartz.dart';

class ChromeCastEntity extends GenericSmartTvDE {
  ChromeCastEntity({
    required super.uniqueId,
    required super.vendorUniqueId,
    required super.defaultName,
    required super.deviceStateGRPC,
    required super.stateMassage,
    required super.senderDeviceOs,
    required super.senderDeviceModel,
    required super.senderId,
    required super.compUuid,
    required super.powerConsumption,
    required super.smartTvSwitchState,
    super.openUrl,
    super.pausePlayState,
    super.skip,
    super.volume,
    required this.googlePort,
    this.deviceMdnsName,
    this.lastKnownIp,
  }) : super(
          deviceVendor: DeviceVendor(VendorsAndServices.google.toString()),
        );

  /// Google communication port 8009 for chromecast
  GooglePort? googlePort;

  DeviceLastKnownIp? lastKnownIp;

  DeviceMdnsName? deviceMdnsName;

  /// Please override the following methods
  @override
  Future<Either<CoreFailure, Unit>> executeDeviceAction({
    required DeviceEntityAbstract newEntity,
  }) async {
    if (newEntity is! GenericSmartTvDE) {
      return left(
        const CoreFailure.actionExcecuter(
          failedValue: 'Not the correct type',
        ),
      );
    }

    try {
      if (newEntity.openUrl!.getOrCrash() != openUrl!.getOrCrash() ||
          deviceStateGRPC.getOrCrash() != DeviceStateGRPC.ack.toString()) {
        (await sendUrlToDevice()).fold((l) {
          logger.e('Error opening url on ChromeCast');
          throw l;
        }, (r) {
          logger.i('ChromeCast opening url success');
        });
      } else {
        openUrl = null;
      }
      if (newEntity.pausePlayState!.getOrCrash() !=
              pausePlayState!.getOrCrash() ||
          deviceStateGRPC.getOrCrash() != DeviceStateGRPC.ack.toString()) {
        (await togglePause()).fold((l) {
          logger.e('Error toggle pause on ChromeCast');
          throw l;
        }, (r) {
          logger.i('ChromeCast toggle pause success');
        });
      } else {
        openUrl = null;
      }
      deviceStateGRPC = DeviceState(DeviceStateGRPC.ack.toString());
      return right(unit);
    } catch (e) {
      deviceStateGRPC = DeviceState(DeviceStateGRPC.newStateFailed.toString());
      return left(const CoreFailure.unexpected());
    }
  }

  @override
  Future<Either<CoreFailure, Unit>> turnOnSmartTv() async {
    try {} catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return left(const CoreFailure.unexpected());
  }

  @override
  Future<Either<CoreFailure, Unit>> turnOffSmartTv() async {
    try {} catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return left(const CoreFailure.unexpected());
  }

  @override
  Future<Either<CoreFailure, Unit>> sendUrlToDevice() async {
    try {
      final CastMedia castMedia = CastMedia(
        contentId: openUrl!.getOrCrash(),
        images: [],
      );

      startCasting(
        [castMedia],
        lastKnownIp!.getOrCrash(),
        8009,
        false,
      );
    } catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return right(unit);
  }

  @override
  Future<Either<CoreFailure, Unit>> togglePause() async {
    try {
      // create the chromecast device with the passed in host and port
      final CastDevice device = CastDevice(
        host: lastKnownIp!.getOrCrash(),
        port: 8009,
        // port: int.parse(googlePort!.getOrCrash()),
        type: '_googlecast._tcp',
      );
      // instantiate the chromecast sender class
      final CastSender castSender = CastSender(
        device,
      );

      castSender.togglePause();
    } catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return right(unit);
  }
}
