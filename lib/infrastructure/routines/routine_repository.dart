import 'package:cbj_hub/domain/rooms/i_saved_rooms_repo.dart';
import 'package:cbj_hub/domain/routine/i_routine_cbj_repository.dart';
import 'package:cbj_hub/domain/routine/routine_cbj_entity.dart';
import 'package:cbj_hub/domain/routine/routine_cbj_failures.dart';
import 'package:cbj_integrations_controller/domain/local_db/local_db_failures.dart';
import 'package:cbj_integrations_controller/domain/mqtt_server/i_mqtt_server_repository.dart';
import 'package:cbj_integrations_controller/domain/saved_devices/i_saved_devices_repo.dart';
import 'package:cbj_integrations_controller/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IRoutineCbjRepository)
class RoutineCbjRepository implements IRoutineCbjRepository {
  final Map<String, RoutineCbjEntity> _allRoutines = {};

  @override
  Future<void> setUpAllFromDb() async {
    // TODO: Fix after new cbj_integrations_controller
    // await getItCbj<ILocalDbRepository>().getRoutinesFromDb().then((value) {
    //   value.fold((l) => null, (r) async {
    //     for (final element in r) {
    //       await addNewRoutine(element);
    //     }
    //   });
    // });
  }

  @override
  Future<List<RoutineCbjEntity>> getAllRoutinesAsList() async {
    return _allRoutines.values.toList();
  }

  @override
  Future<Map<String, RoutineCbjEntity>> getAllRoutinesAsMap() async {
    return _allRoutines;
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveAndActivateRoutineToDb() async {
    // TODO: Fix after new cbj_integrations_controller
    //
    // return getItCbj<ILocalDbRepository>().saveRoutines(
    //   routineList: List<RoutineCbjEntity>.from(_allRoutines.values),
    // );
    return left(const LocalDbFailures.unableToUpdate());
  }

  @override
  Future<Either<RoutineCbjFailure, Unit>> addNewRoutine(
    RoutineCbjEntity routineCbj,
  ) async {
    final RoutineCbjEntity tempRoutineCbj = routineCbj;

    /// Check if routine already exist
    if (findRoutineIfAlreadyBeenAdded(tempRoutineCbj) == null) {
      _allRoutines.addEntries(
        [MapEntry(tempRoutineCbj.uniqueId.getOrCrash(), tempRoutineCbj)],
      );

      final String entityId = tempRoutineCbj.uniqueId.getOrCrash();

      /// If it is new routine
      _allRoutines[entityId] = tempRoutineCbj;

      ISavedRoomsRepo.instance
          .addRoutineToRoomDiscoveredIfNotExist(tempRoutineCbj);
      // TODO: Fix after new cbj_integrations_controller
      // final String routineNodeRedFlowId = await getItCbj<NodeRedRepository>()
      //     .createNewNodeRedRoutine(tempRoutineCbj);
      // if (routineNodeRedFlowId.isNotEmpty) {
      //   tempRoutineCbj = tempRoutineCbj.copyWith(
      //     nodeRedFlowId: RoutineCbjNodeRedFlowId(routineNodeRedFlowId),
      //   );
      // }
      return left(const RoutineCbjFailure.unableToUpdate());
    }
    return right(unit);
  }

  @override
  Future<Either<RoutineCbjFailure, Unit>> addNewRoutineAndSaveItToLocalDb(
    RoutineCbjEntity routineCbj,
  ) async {
    await addNewRoutine(routineCbj);
    await getItCbj<ISavedDevicesRepo>().saveAndActivateSmartDevicesToDb();
    await saveAndActivateRoutineToDb();

    return right(unit);
  }

  @override
  Future<bool> activateRoutine(
    RoutineCbjEntity routineCbj,
  ) async {
    final String fullPathOfRoutine = await getFullMqttPathOfRoutine(routineCbj);
    IMqttServerRepository.instance
        .publishMessage(fullPathOfRoutine, DateTime.now().toString());

    return true;
  }

  /// Get entity and return the full MQTT path to it
  @override
  Future<String> getFullMqttPathOfRoutine(RoutineCbjEntity routineCbj) async {
    final String hubBaseTopic =
        IMqttServerRepository.instance.getHubBaseTopic();
    final String routinesTopicTypeName =
        IMqttServerRepository.instance.getRoutinesTopicTypeName();
    final String routineId = routineCbj.firstNodeId.getOrCrash()!;

    return '$hubBaseTopic/$routinesTopicTypeName/$routineId';
  }

  /// Check if all routines does not contain the same routine already
  /// Will compare the unique id's that each company sent us
  RoutineCbjEntity? findRoutineIfAlreadyBeenAdded(
    RoutineCbjEntity routineEntity,
  ) {
    return _allRoutines[routineEntity.uniqueId.getOrCrash()];
  }
}
