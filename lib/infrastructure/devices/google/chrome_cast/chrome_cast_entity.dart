import 'dart:async';

import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/generic_devices/generic_smart_tv/generic_smart_tv_entity.dart';
import 'package:cbj_hub/domain/generic_devices/generic_smart_tv/generic_smart_tv_value_objects.dart';
import 'package:cbj_hub/domain/mqtt_server/i_mqtt_server_repository.dart';
import 'package:cbj_hub/infrastructure/devices/google/chromecast_api_node_red/chromecast_api_node_red.dart';
import 'package:cbj_hub/infrastructure/devices/google/google_device_value_objects.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/injection.dart';
import 'package:cbj_hub/utils.dart';
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
        ) {
    setUpNodeRedApi();
  }

  /// Google communication port 8009 for chromecast
  GooglePort? googlePort;

  DeviceLastKnownIp? lastKnownIp;

  DeviceMdnsName? deviceMdnsName;

  late ChromecastApiNodeRed chromecastApiNodeRed;

  void setUpNodeRedApi() async {
    // TODO: add check to add  uniqueId + action as flow in node read only if missing
    chromecastApiNodeRed = ChromecastApiNodeRed();
    chromecastApiNodeRed.setNewYoutubeVideoNodes(
      uniqueId.getOrCrash(),
      lastKnownIp!.getOrCrash(),
    );
  }

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
      if (newEntity.openUrl?.getOrCrash() != null &&
          (newEntity.openUrl?.getOrCrash() != openUrl?.getOrCrash() ||
              deviceStateGRPC.getOrCrash() != DeviceStateGRPC.ack.toString())) {
        (await sendUrlToDevice(newEntity.openUrl!.getOrCrash())).fold((l) {
          logger.e('Error opening url on ChromeCast');
          throw l;
        }, (r) {
          logger.i('ChromeCast opening url success');
        });
      }

      if (newEntity.pausePlayState?.getOrCrash() != null &&
          (newEntity.pausePlayState?.getOrCrash() !=
                  pausePlayState?.getOrCrash() ||
              deviceStateGRPC.getOrCrash() != DeviceStateGRPC.ack.toString())) {
        (await togglePause(newEntity.pausePlayState!.getOrCrash())).fold((l) {
          logger.e('Error toggle pause on ChromeCast');
          throw l;
        }, (r) {
          logger.i('ChromeCast toggle pause success');
        });
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
  Future<Either<CoreFailure, Unit>> sendUrlToDevice(String newUrl) async {
    try {
      openUrl = GenericSmartTvOpenUrl(newUrl);
      final String nodeRedApiBaseTopic =
          getIt<IMqttServerRepository>().getNodeRedApiBaseTopic();

      final String nodeRedDevicesTopic =
          getIt<IMqttServerRepository>().getNodeRedDevicesTopicTypeName();

      final String topic =
          '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/${uniqueId.getOrCrash()}/${chromecastApiNodeRed.youtubeVideoProperty}/${chromecastApiNodeRed.playingVideoProperty}';

      String validYoutubeVidId = openUrl!.getOrCrash();
      if (validYoutubeVidId.contains('?v=')) {
        validYoutubeVidId =
            validYoutubeVidId.substring(validYoutubeVidId.indexOf('?v=') + 3);
      }
      if (validYoutubeVidId.contains('&index=')) {
        final int valueOfAndIndexEqual = validYoutubeVidId.indexOf('&index=');
        validYoutubeVidId = validYoutubeVidId.substring(
          0,
          valueOfAndIndexEqual,
        );
      }
      if (validYoutubeVidId.contains('&list=')) {
        final int valueOfAndIndexEqual = validYoutubeVidId.indexOf('&list=');
        validYoutubeVidId = validYoutubeVidId.substring(
          0,
          valueOfAndIndexEqual,
        );
      }
      getIt<IMqttServerRepository>().publishMessage(topic, validYoutubeVidId);
    } catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return right(unit);
  }

  @override
  Future<Either<CoreFailure, Unit>> togglePause(String toggleNewState) async {
    try {
      pausePlayState = GenericSmartTvPausePlayState(toggleNewState);

      final String nodeRedApiBaseTopic =
          getIt<IMqttServerRepository>().getNodeRedApiBaseTopic();

      final String nodeRedDevicesTopic =
          getIt<IMqttServerRepository>().getNodeRedDevicesTopicTypeName();

      final String topic =
          '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/${uniqueId.getOrCrash()}/${chromecastApiNodeRed.youtubeVideoProperty}/${chromecastApiNodeRed.pauseVideoProperty}';

      getIt<IMqttServerRepository>()
          .publishMessage(topic, 'Media Command PAUSE');
    } catch (e) {
      return left(const CoreFailure.unexpected());
    }
    return right(unit);
  }
}
