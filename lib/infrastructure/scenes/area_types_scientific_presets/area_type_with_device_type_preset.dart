import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/local_db/local_db_failures.dart';
import 'package:cbj_hub/domain/saved_devices/i_saved_devices_repo.dart';
import 'package:cbj_hub/domain/scene/scene_cbj_failures.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/infrastructure/scenes/area_types_scientific_presets/common_devices_scenes_presets_for_devices.dart';
import 'package:cbj_hub/injection.dart';
import 'package:dartz/dartz.dart';

/// Pre define actions for each device in each area
class AreaTypeWithDeviceTypePreset {
  static Future<Either<SceneCbjFailure, Map<String, String>>>
      getPreDefineActionForDeviceInArea({
    required String deviceId,
    required AreaPurposesTypes areaPurposeType,
    required String brokerNodeId,
  }) async {
    final Either<LocalDbFailures, DeviceEntityAbstract> dTemp =
        await getIt<ISavedDevicesRepo>().getDeviceById(deviceId);
    if (dTemp.isLeft()) {
      return left(const SceneCbjFailure.unexpected());
    }
    late DeviceEntityAbstract deviceEntity;

    dTemp.fold((l) => null, (r) {
      deviceEntity = r;
    });

    switch (areaPurposeType) {
      case AreaPurposesTypes.attic:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.bathtub:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.bedroom:
        return bedRoomDeviceAction(deviceEntity, brokerNodeId);
        break;
      case AreaPurposesTypes.boardGames:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.childrensRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.cinemaRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.diningRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.holidayCabin:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.kitchen:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.laundryRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.livingRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.meditation:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.outside:
        return outsideOffDeviceAction(deviceEntity, brokerNodeId);
      case AreaPurposesTypes.outsideNotPrimary:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.outsidePrimary:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.protectedSpace:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.romantic:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.safeRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.shower:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.stairsInside:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.stairsOutside:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.studyRoom:
        return studyRoomDeviceAction(deviceEntity, brokerNodeId);
      case AreaPurposesTypes.toiletRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.trainingRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.tvRoom:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.videoGames:
        // TODO: Handle this case.
        break;
      case AreaPurposesTypes.workRoom:
        return workRoomDeviceAction(deviceEntity, brokerNodeId);
    }
    return left(const SceneCbjFailure.unexpected());
  }

  static Future<Either<SceneCbjFailure, Map<String, String>>>
      studyRoomDeviceAction(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) async {
    final DeviceTypes deviceType = DeviceTypes.values.firstWhere(
      (element) => element.name == deviceEntity.deviceTypes.getOrCrash(),
    );

    final Map<String, String> actionsList = {};

    switch (deviceType) {
      case DeviceTypes.AirConditioner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.babyMonitor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.bed:
        // TODO: Handle this case.
        break;
      case DeviceTypes.blinds:
        // TODO: Handle this case.
        break;
      case DeviceTypes.boiler:
        // TODO: Handle this case.
        break;
      case DeviceTypes.browserApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.button:
        // TODO: Handle this case.
        break;
      case DeviceTypes.buttonWithLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.cctLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.coffeeMachine:
        // TODO: Handle this case.
        break;
      case DeviceTypes.computerApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dimmableLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dishwasher:
        // TODO: Handle this case.
        break;
      case DeviceTypes.hub:
        // TODO: Handle this case.
        break;
      case DeviceTypes.humiditySensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.kettle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.light:
        // TODO: Handle this case.
        break;
      case DeviceTypes.lightSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.microphone:
        // TODO: Handle this case.
        break;
      case DeviceTypes.motionSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oven:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oxygenSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.phoneApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printer:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printerWithScanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.refrigerator:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbcctLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbwLights:
        actionsList.addEntries([
          CommonDevicesScenesPresetsForDevices.rgbLightOnPreset(
            deviceEntity,
            brokerNodeId,
          ),
        ]);
        // TODO: add light color change to blue
        return right(actionsList);
        break;
      case DeviceTypes.scanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.securityCamera:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartPlug:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartSpeakers:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartTV:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWatch:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWaterBottle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeDetector:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.soundSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.switch_:
        // TODO: Handle this case.
        break;
      case DeviceTypes.teapot:
        // TODO: Handle this case.
        break;
      case DeviceTypes.temperatureSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.toaster:
        // TODO: Handle this case.
        break;
      case DeviceTypes.typeNotSupported:
        // TODO: Handle this case.
        break;
      case DeviceTypes.vacuumCleaner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.washingMachine:
        // TODO: Handle this case.
        break;
    }
    return right(<String, String>{});
  }

  static Future<Either<SceneCbjFailure, Map<String, String>>>
      workRoomDeviceAction(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) async {
    final DeviceTypes deviceType = DeviceTypes.values.firstWhere(
      (element) => element.name == deviceEntity.deviceTypes.getOrCrash(),
    );

    final Map<String, String> actionsList = {};

    switch (deviceType) {
      case DeviceTypes.AirConditioner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.babyMonitor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.bed:
        // TODO: Handle this case.
        break;
      case DeviceTypes.blinds:
        // TODO: Handle this case.
        break;
      case DeviceTypes.boiler:
        // TODO: Handle this case.
        break;
      case DeviceTypes.browserApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.button:
        // TODO: Handle this case.
        break;
      case DeviceTypes.buttonWithLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.cctLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.coffeeMachine:
        // TODO: Handle this case.
        break;
      case DeviceTypes.computerApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dimmableLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dishwasher:
        // TODO: Handle this case.
        break;
      case DeviceTypes.hub:
        // TODO: Handle this case.
        break;
      case DeviceTypes.humiditySensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.kettle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.light:
        // TODO: Handle this case.
        break;
      case DeviceTypes.lightSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.microphone:
        // TODO: Handle this case.
        break;
      case DeviceTypes.motionSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oven:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oxygenSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.phoneApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printer:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printerWithScanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.refrigerator:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbcctLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbwLights:
        actionsList.addEntries([
          CommonDevicesScenesPresetsForDevices.rgbLightOnPreset(
            deviceEntity,
            brokerNodeId,
          ),
        ]);
        // TODO: add light color change to blue
        return right(actionsList);
        break;
      case DeviceTypes.scanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.securityCamera:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartPlug:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartSpeakers:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartTV:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWatch:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWaterBottle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeDetector:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.soundSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.switch_:
        // TODO: Handle this case.
        break;
      case DeviceTypes.teapot:
        // TODO: Handle this case.
        break;
      case DeviceTypes.temperatureSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.toaster:
        // TODO: Handle this case.
        break;
      case DeviceTypes.typeNotSupported:
        // TODO: Handle this case.
        break;
      case DeviceTypes.vacuumCleaner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.washingMachine:
        // TODO: Handle this case.
        break;
    }
    return right(<String, String>{});
  }

  static Future<Either<SceneCbjFailure, Map<String, String>>>
      bedRoomDeviceAction(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) async {
    final DeviceTypes deviceType = DeviceTypes.values.firstWhere(
      (element) => element.name == deviceEntity.deviceTypes.getOrCrash(),
    );
    final Map<String, String> actionsList = {};

    switch (deviceType) {
      case DeviceTypes.AirConditioner:
        // TODO: Turn on on sleep mode?.
        break;
      case DeviceTypes.babyMonitor:
        // TODO: Open and ready.
        break;
      case DeviceTypes.bed:
        // TODO: Change angle to be straight for sleep (not with angle for reading).
        break;
      case DeviceTypes.blinds:
        // TODO: Turn all the way down?.
        break;
      case DeviceTypes.boiler:
        // TODO: Handle this case.
        break;
      case DeviceTypes.browserApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.button:
        // TODO: Handle this case.
        break;
      case DeviceTypes.buttonWithLight:
        // TODO: Turn off button light for better sleep? or turn on so that it will be easy to find the button at the dart.
        break;
      case DeviceTypes.cctLight:
        // TODO: Dim light in case it turned on in the night and turn off
        break;
      case DeviceTypes.coffeeMachine:
        // TODO: Turn off.
        break;
      case DeviceTypes.computerApp:
        // TODO: Turn off.
        break;
      case DeviceTypes.dimmableLight:
        // TODO: Dim light in case it turned on in the night and turn off
        break;
      case DeviceTypes.dishwasher:
        // TODO: Turn off.
        break;
      case DeviceTypes.hub:
        // TODO: Handle this case.
        break;
      case DeviceTypes.humiditySensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.kettle:
        // TODO: Turn off.
        break;
      case DeviceTypes.light:
        // TODO: Dim light in case it turned on in the night and turn off.
        break;
      case DeviceTypes.lightSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.microphone:
        // TODO: Handle this case.
        break;
      case DeviceTypes.motionSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oven:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oxygenSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.phoneApp:
        // TODO: Put phone on sleep mode, gray screen as well as quite and maybe set alarm clock for the morning.
        break;
      case DeviceTypes.printer:
        // TODO: Postpone maintenance.
        break;
      case DeviceTypes.printerWithScanner:
        // TODO: Postpone maintenance.
        break;
      case DeviceTypes.refrigerator:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbLights:
        // TODO: Dim light in case it turned on in the night and turn off.
        break;
      case DeviceTypes.rgbcctLights:
        // TODO: Dim light in case it turned on in the night and turn off.
        break;
      case DeviceTypes.rgbwLights:
        actionsList.addEntries([
          CommonDevicesScenesPresetsForDevices.rgbwLightOffPreset(
            deviceEntity,
            brokerNodeId,
          ),
        ]);
        return right(actionsList);
      case DeviceTypes.scanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.securityCamera:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartPlug:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartSpeakers:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartTV:
        // TODO: Turn off.
        break;
      case DeviceTypes.smartWatch:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWaterBottle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeDetector:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.soundSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.switch_:
        // TODO: Handle this case.
        break;
      case DeviceTypes.teapot:
        // TODO: Turn off.
        break;
      case DeviceTypes.temperatureSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.toaster:
        // TODO: Handle this case.
        break;
      case DeviceTypes.typeNotSupported:
        // TODO: Handle this case.
        break;
      case DeviceTypes.vacuumCleaner:
        // TODO: Turn off.
        break;
      case DeviceTypes.washingMachine:
        // TODO: Turn off.
        break;
    }
    return right(<String, String>{});
  }

  static Future<Either<SceneCbjFailure, Map<String, String>>>
      outsideOffDeviceAction(
    DeviceEntityAbstract deviceEntity,
    String brokerNodeId,
  ) async {
    final DeviceTypes deviceType = DeviceTypes.values.firstWhere(
      (element) => element.name == deviceEntity.deviceTypes.getOrCrash(),
    );
    final Map<String, String> actionsList = {};

    switch (deviceType) {
      case DeviceTypes.AirConditioner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.babyMonitor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.bed:
        // TODO: Handle this case.).
        break;
      case DeviceTypes.blinds:
        // TODO: Handle this case.
        break;
      case DeviceTypes.boiler:
        // TODO: Handle this case.
        break;
      case DeviceTypes.browserApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.button:
        // TODO: Handle this case.
        break;
      case DeviceTypes.buttonWithLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.cctLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.coffeeMachine:
        // TODO: Handle this case.
        break;
      case DeviceTypes.computerApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dimmableLight:
        // TODO: Handle this case.
        break;
      case DeviceTypes.dishwasher:
        // TODO: Handle this case.
        break;
      case DeviceTypes.hub:
        // TODO: Handle this case.
        break;
      case DeviceTypes.humiditySensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.kettle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.light:
        // TODO: Handle this case.
        break;
      case DeviceTypes.lightSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.microphone:
        // TODO: Handle this case.
        break;
      case DeviceTypes.motionSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oven:
        // TODO: Handle this case.
        break;
      case DeviceTypes.oxygenSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.phoneApp:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printer:
        // TODO: Handle this case.
        break;
      case DeviceTypes.printerWithScanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.refrigerator:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbcctLights:
        // TODO: Handle this case.
        break;
      case DeviceTypes.rgbwLights:
        actionsList.addEntries([
          CommonDevicesScenesPresetsForDevices.rgbwLightOffPreset(
            deviceEntity,
            brokerNodeId,
          ),
        ]);
        return right(actionsList);
      case DeviceTypes.scanner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.securityCamera:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartPlug:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartSpeakers:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartTV:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWatch:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smartWaterBottle:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeDetector:
        // TODO: Handle this case.
        break;
      case DeviceTypes.smokeSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.soundSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.switch_:
        // TODO: Handle this case.
        break;
      case DeviceTypes.teapot:
        // TODO: Handle this case.
        break;
      case DeviceTypes.temperatureSensor:
        // TODO: Handle this case.
        break;
      case DeviceTypes.toaster:
        // TODO: Handle this case.
        break;
      case DeviceTypes.typeNotSupported:
        // TODO: Handle this case.
        break;
      case DeviceTypes.vacuumCleaner:
        // TODO: Handle this case.
        break;
      case DeviceTypes.washingMachine:
        // TODO: Handle this case.
        break;
    }
    return right(<String, String>{});
  }
}
