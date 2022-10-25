import 'dart:convert';

import 'package:cbj_hub/domain/app_communication/i_app_communication_repository.dart';
import 'package:cbj_hub/domain/binding/binding_cbj_entity.dart';
import 'package:cbj_hub/domain/binding/value_objects_routine_cbj.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/device_entity_abstract.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/domain/local_db/i_local_db_repository.dart';
import 'package:cbj_hub/domain/local_db/local_db_failures.dart';
import 'package:cbj_hub/domain/room/room_entity.dart';
import 'package:cbj_hub/domain/room/value_objects_room.dart';
import 'package:cbj_hub/domain/routine/routine_cbj_entity.dart';
import 'package:cbj_hub/domain/routine/value_objects_routine_cbj.dart';
import 'package:cbj_hub/domain/scene/scene_cbj_entity.dart';
import 'package:cbj_hub/domain/scene/value_objects_scene_cbj.dart';
import 'package:cbj_hub/domain/vendors/login_abstract/login_entity_abstract.dart';
import 'package:cbj_hub/domain/vendors/login_abstract/value_login_objects_core.dart';
import 'package:cbj_hub/domain/vendors/tuya_login/generic_tuya_login_entity.dart';
import 'package:cbj_hub/domain/vendors/tuya_login/generic_tuya_login_value_objects.dart';
import 'package:cbj_hub/infrastructure/bindings/binding_cbj_dtos.dart';
import 'package:cbj_hub/infrastructure/core/singleton/my_singleton.dart';
import 'package:cbj_hub/infrastructure/devices/companies_connector_conjector.dart';
import 'package:cbj_hub/infrastructure/devices/device_helper/device_helper.dart';
import 'package:cbj_hub/infrastructure/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/bindings_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/devices_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/remote_pipes_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/rooms_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/routines_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/scenes_hive_model.dart';
import 'package:cbj_hub/infrastructure/local_db/hive_objects/tuya_vendor_credentials_hive_model.dart';
import 'package:cbj_hub/infrastructure/room/room_entity_dtos.dart';
import 'package:cbj_hub/infrastructure/routines/routine_cbj_dtos.dart';
import 'package:cbj_hub/infrastructure/scenes/scene_cbj_dtos.dart';
import 'package:cbj_hub/injection.dart';
import 'package:cbj_hub/utils.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

/// Only ISavedDevicesRepo need to call functions here
@LazySingleton(as: ILocalDbRepository)
class HiveRepository extends ILocalDbRepository {
  HiveRepository() {
    asyncConstractor();
  }

  Future<void> asyncConstractor() async {
    String? localDbPath = await MySingleton.getLocalDbPath();

    if (localDbPath == null) {
      logger.e('Cant find local DB path');
      localDbPath = '/';
    }

    loadFromDb();
  }

  @override
  Future<void> loadFromDb() async {
    (await getRemotePipesDnsName()).fold(
        (l) =>
            logger.w('No Remote Pipes Dns name was found in the local storage'),
        (r) {
      getIt<IAppCommunicationRepository>().startRemotePipesConnection(r);

      logger.i('Remote Pipes DNS name was "$r" found');
    });
    (await getTuyaVendorLoginCredentials(
      vendorBoxName: tuyaVendorCredentialsBoxName,
    ))
        .fold((l) {}, (r) {
      CompaniesConnectorConjector.setVendorLoginCredentials(r);

      logger.i(
        'Tuya login credentials user name ${r.tuyaUserName.getOrCrash()} found',
      );
    });
    (await getTuyaVendorLoginCredentials(
      vendorBoxName: smartLifeVendorCredentialsBoxName,
    ))
        .fold((l) {}, (r) {
      CompaniesConnectorConjector.setVendorLoginCredentials(r);

      logger.i(
        'Smart Life login credentials user name ${r.tuyaUserName.getOrCrash()} found',
      );
    });
    (await getTuyaVendorLoginCredentials(
      vendorBoxName: jinvooSmartVendorCredentialsBoxName,
    ))
        .fold((l) {}, (r) {
      CompaniesConnectorConjector.setVendorLoginCredentials(r);

      logger.i(
        'Jinvoo Smart login credentials user name ${r.tuyaUserName.getOrCrash()} found',
      );
    });
  }

  @override
  Future<Either<LocalDbFailures, List<RoomEntity>>> getRoomsFromDb() async {
    final List<RoomEntity> rooms = <RoomEntity>[];

    try {
      final Isar roomsBox = await Isar.open([RoomsHiveModelSchema]);

      final List<RoomsHiveModel> roomsHiveModelFromDb =
          await roomsBox.roomsHiveModels.where().findAll();

      await roomsBox.close();

      for (final RoomsHiveModel roomIsar in roomsHiveModelFromDb) {
        final RoomEntity roomEntity = RoomEntity(
          uniqueId: RoomUniqueId.fromUniqueString(roomIsar.roomUniqueId),
          defaultName: RoomDefaultName(roomIsar.roomDefaultName),
          background: RoomBackground(roomIsar.roomBackground),
          roomTypes: RoomTypes(roomIsar.roomTypes),
          roomDevicesId: RoomDevicesId(roomIsar.roomDevicesId),
          roomScenesId: RoomScenesId(roomIsar.roomScenesId),
          roomRoutinesId: RoomRoutinesId(roomIsar.roomRoutinesId),
          roomBindingsId: RoomBindingsId(roomIsar.roomBindingsId),
          roomMostUsedBy: RoomMostUsedBy(roomIsar.roomMostUsedBy),
          roomPermissions: RoomPermissions(roomIsar.roomPermissions),
        );
        rooms.add(roomEntity);
      }
    } catch (e) {
      logger.e('Local DB hive error while getting rooms: $e');
      // TODO: Check why hive crash stop this from working
      await deleteAllSavedRooms();
    }

    /// Gets all rooms from db, if there are non it will create and return
    /// only a discovered room
    if (rooms.isEmpty) {
      final RoomEntity discoveredRoom = RoomEntity.empty().copyWith(
        uniqueId: RoomUniqueId.discoveredRoomId(),
        defaultName: RoomDefaultName.discoveredRoomName(),
      );
      rooms.add(discoveredRoom);
    }
    return right(rooms);
  }

  @override
  Future<Either<LocalDbFailures, List<DeviceEntityAbstract>>>
      getSmartDevicesFromDb() async {
    final List<DeviceEntityAbstract> devices = <DeviceEntityAbstract>[];

    try {
      final Isar devicesBox = await Isar.open([DevicesHiveModelSchema]);

      final List<DevicesHiveModel> devicesHiveModelFromDb =
          await devicesBox.devicesHiveModels.where().findAll();

      await devicesBox.close();

      for (final DevicesHiveModel deviceIsar in devicesHiveModelFromDb) {
        final DeviceEntityAbstract deviceEntity =
            DeviceHelper.convertJsonStringToDomain(deviceIsar.deviceStringJson);

        devices.add(
          deviceEntity
            ..deviceStateGRPC =
                DeviceState(DeviceStateGRPC.waitingInComp.toString()),
        );
      }
      return right(devices);
    } catch (e) {
      logger.e('Local DB hive error while getting devices: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, String>> getHubEntityLastKnownIp() async {
    // TODO: implement getHubEntityLastKnownIp
    throw UnimplementedError();
  }

  @override
  Future<Either<LocalDbFailures, String>> getHubEntityNetworkBssid() async {
    // TODO: implement getHubEntityNetworkBssid
    throw UnimplementedError();
  }

  @override
  Future<Either<LocalDbFailures, String>> getHubEntityNetworkName() async {
    // TODO: implement getHubEntityNetworkName
    throw UnimplementedError();
  }

  @override
  Future<Either<LocalDbFailures, GenericTuyaLoginDE>>
      getTuyaVendorLoginCredentials({
    required String vendorBoxName,
  }) async {
    try {
      final Isar tuyaVendorCredentialsBox =
          await Isar.open([TuyaVendorCredentialsHiveModelSchema]);

      final List<TuyaVendorCredentialsHiveModel>
          tuyaVendorCredentialsModelFromDb = await tuyaVendorCredentialsBox
              .tuyaVendorCredentialsHiveModels
              .where()
              .findAll();

      if (tuyaVendorCredentialsModelFromDb.isNotEmpty) {
        final TuyaVendorCredentialsHiveModel firstTuyaVendorFromDB =
            tuyaVendorCredentialsModelFromDb[0];

        final String? senderUniqueId = firstTuyaVendorFromDB.senderUniqueId;
        final String tuyaUserName = firstTuyaVendorFromDB.tuyaUserName;
        final String tuyaUserPassword = firstTuyaVendorFromDB.tuyaUserPassword;
        final String tuyaCountryCode = firstTuyaVendorFromDB.tuyaCountryCode;
        final String tuyaBizType = firstTuyaVendorFromDB.tuyaBizType;
        final String tuyaRegion = firstTuyaVendorFromDB.tuyaRegion;
        final String loginVendor = firstTuyaVendorFromDB.loginVendor;

        await tuyaVendorCredentialsBox.close();

        final GenericTuyaLoginDE genericTuyaLoginDE = GenericTuyaLoginDE(
          senderUniqueId: CoreLoginSenderId.fromUniqueString(senderUniqueId),
          loginVendor: CoreLoginVendor(loginVendor),
          tuyaUserName: GenericTuyaLoginUserName(tuyaUserName),
          tuyaUserPassword: GenericTuyaLoginUserPassword(tuyaUserPassword),
          tuyaCountryCode: GenericTuyaLoginCountryCode(tuyaCountryCode),
          tuyaBizType: GenericTuyaLoginBizType(tuyaBizType),
          tuyaRegion: GenericTuyaLoginRegion(tuyaRegion),
        );

        logger.i(
          'Tuya user name is: '
          '$tuyaUserName',
        );
        return right(genericTuyaLoginDE);
      }
      await tuyaVendorCredentialsBox.close();
      logger.i(
        "Didn't find any Tuya in the local DB for box name $vendorBoxName",
      );
    } catch (e) {
      logger.e('Local DB hive error while getting Tuya vendor: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, String>> getRemotePipesDnsName() async {
    try {
      final Isar remotePipesBox = await Isar.open([RemotePipesHiveModelSchema]);

      final List<RemotePipesHiveModel> remotePipesHiveModelFromDb =
          await remotePipesBox.remotePipesHiveModels.where().findAll();

      if (remotePipesHiveModelFromDb.isNotEmpty) {
        final String remotePipesDnsName =
            remotePipesHiveModelFromDb[0].domainName;
        await remotePipesBox.close();

        logger.i(
          'Remote pipes domain name is: '
          '$remotePipesDnsName',
        );
        return right(remotePipesDnsName);
      }
      await remotePipesBox.close();
      logger.i("Didn't find any remote pipes in the local DB");
    } catch (e) {
      logger.e('Local DB hive error while getting Remote Pipes: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveSmartDevices({
    required List<DeviceEntityAbstract> deviceList,
  }) async {
    try {
      final List<DevicesHiveModel> devicesHiveList = [];

      final List<String> devicesListStringJson = List<String>.from(
        deviceList.map((e) => DeviceHelper.convertDomainToJsonString(e)),
      );

      for (final String devicesEntityDtosJsonString in devicesListStringJson) {
        final DevicesHiveModel devicesHiveModel = DevicesHiveModel()
          ..deviceStringJson = devicesEntityDtosJsonString;
        devicesHiveList.add(devicesHiveModel);
      }

      final Isar devicesBox = await Isar.open([DevicesHiveModelSchema]);

      await devicesBox.writeTxn(() async {
        await devicesBox.devicesHiveModels.clear();
        await devicesBox.devicesHiveModels.putAll(devicesHiveList);
      });

      await devicesBox.close();
      logger.i('Devices got saved to local storage');
    } catch (e) {
      logger.e('Error saving Devices to local storage\n$e');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveRoomsToDb({
    required List<RoomEntity> roomsList,
  }) async {
    try {
      final Isar roomsBox = await Isar.open([RoomsHiveModelSchema]);

      final List<RoomsHiveModel> roomsHiveList = [];

      final List<RoomEntityDtos> roomsListDto =
          List<RoomEntityDtos>.from(roomsList.map((e) => e.toInfrastructure()));

      for (final RoomEntityDtos roomEntityDtos in roomsListDto) {
        final RoomsHiveModel roomsHiveModel = RoomsHiveModel()
          ..roomUniqueId = roomEntityDtos.uniqueId
          ..roomDefaultName = roomEntityDtos.defaultName
          ..roomBackground = roomEntityDtos.background
          ..roomDevicesId = roomEntityDtos.roomDevicesId
          ..roomScenesId = roomEntityDtos.roomScenesId
          ..roomRoutinesId = roomEntityDtos.roomRoutinesId
          ..roomBindingsId = roomEntityDtos.roomBindingsId
          ..roomMostUsedBy = roomEntityDtos.roomMostUsedBy
          ..roomPermissions = roomEntityDtos.roomPermissions
          ..roomTypes = roomEntityDtos.roomTypes;
        roomsHiveList.add(roomsHiveModel);
      }

      await roomsBox.writeTxn(() async {
        await roomsBox.roomsHiveModels.clear();
        await roomsBox.roomsHiveModels.putAll(roomsHiveList); // insert & update
      });

      await roomsBox.close();
      logger.i('Rooms got saved to local storage');
    } catch (e) {
      logger.e('Error saving Rooms to local storage\n$e');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveHubEntity({
    required String hubNetworkBssid,
    required String networkName,
    required String lastKnownIp,
  }) async {
    // TODO: implement saveHubEntity
    throw UnimplementedError();
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveVendorLoginCredentials({
    required LoginEntityAbstract loginEntityAbstract,
  }) async {
    if (loginEntityAbstract is GenericTuyaLoginDE) {
      if (loginEntityAbstract.loginVendor.getOrCrash() ==
          VendorsAndServices.smartLife.name) {
        saveTuyaVendorCredentials(
          tuyaLoginDE: loginEntityAbstract,
          vendorCredentialsBoxName: smartLifeVendorCredentialsBoxName,
        );
      } else if (loginEntityAbstract.loginVendor.getOrCrash() ==
          VendorsAndServices.jinvooSmart.name) {
        saveTuyaVendorCredentials(
          tuyaLoginDE: loginEntityAbstract,
          vendorCredentialsBoxName: jinvooSmartVendorCredentialsBoxName,
        );
      } else {
        saveTuyaVendorCredentials(
          tuyaLoginDE: loginEntityAbstract,
          vendorCredentialsBoxName: tuyaVendorCredentialsBoxName,
        );
      }
    } else {
      logger.e(
        'Please implement save function for this login type '
        '${loginEntityAbstract.runtimeType}',
      );
    }

    return right(unit);
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveRemotePipes({
    required String remotePipesDomainName,
  }) async {
    try {
      final Isar remotePipesBox = await Isar.open([RemotePipesHiveModelSchema]);

      final RemotePipesHiveModel remotePipesHiveModel = RemotePipesHiveModel()
        ..domainName = remotePipesDomainName;

      await remotePipesBox.writeTxn(() async {
        await remotePipesBox.remotePipesHiveModels.clear();
        await remotePipesBox.remotePipesHiveModels.put(remotePipesHiveModel);
      });

      await remotePipesBox.close();
      logger.i(
        'Remote Pipes got saved to local storage with domain name is: '
        '$remotePipesDomainName',
      );
    } catch (e) {
      logger.e('Error saving Remote Pipes to local storage');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }

  Future<Either<LocalDbFailures, Unit>> saveTuyaVendorCredentials({
    required GenericTuyaLoginDE tuyaLoginDE,
    required String vendorCredentialsBoxName,
  }) async {
    try {
      final Isar tuyaVendorCredentialsBox =
          await Isar.open([TuyaVendorCredentialsHiveModelSchema]);

      final TuyaVendorCredentialsHiveModel tuyaVendorCredentialsModel =
          TuyaVendorCredentialsHiveModel()
            ..senderUniqueId = tuyaLoginDE.senderUniqueId.getOrCrash()
            ..tuyaUserName = tuyaLoginDE.tuyaUserName.getOrCrash()
            ..tuyaUserPassword = tuyaLoginDE.tuyaUserPassword.getOrCrash()
            ..tuyaCountryCode = tuyaLoginDE.tuyaCountryCode.getOrCrash()
            ..tuyaBizType = tuyaLoginDE.tuyaBizType.getOrCrash()
            ..tuyaRegion = tuyaLoginDE.tuyaRegion.getOrCrash()
            ..loginVendor = tuyaLoginDE.loginVendor.getOrCrash();

      await tuyaVendorCredentialsBox.writeTxn(() async {
        await tuyaVendorCredentialsBox.tuyaVendorCredentialsHiveModels.clear();
        await tuyaVendorCredentialsBox.tuyaVendorCredentialsHiveModels
            .put(tuyaVendorCredentialsModel);
      });

      await tuyaVendorCredentialsBox.close();
      logger.i(
        'Tuya vendor credentials saved to local storage with the user name: '
        '${tuyaLoginDE.tuyaUserName.getOrCrash()}',
      );
    } catch (e) {
      logger.e('Error saving Remote Pipes to local storage');
      return left(const LocalDbFailures.unexpected());
    }
    return right(unit);
  }

  Future<void> deleteAllSavedRooms() async {
    await saveRoomsToDb(roomsList: []);
  }

  @override
  Future<Either<LocalDbFailures, List<SceneCbjEntity>>>
      getScenesFromDb() async {
    final List<SceneCbjEntity> scenes = <SceneCbjEntity>[];

    try {
      final Isar scenesBox = await Isar.open([ScenesHiveModelSchema]);

      final List<ScenesHiveModel> scenesHiveModelFromDb =
          await scenesBox.scenesHiveModels.where().findAll();

      await scenesBox.close();

      for (final ScenesHiveModel sceneIsar in scenesHiveModelFromDb) {
        final SceneCbjEntity sceneEntity = SceneCbjDtos.fromJson(
          jsonDecode(sceneIsar.scenesStringJson) as Map<String, dynamic>,
        ).toDomain();

        scenes.add(
          sceneEntity.copyWith(
            deviceStateGRPC: SceneCbjDeviceStateGRPC(
              DeviceStateGRPC.waitingInComp.toString(),
            ),
          ),
        );
      }
      return right(scenes);
    } catch (e) {
      logger.e('Local DB hive error while getting devices: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, List<RoutineCbjEntity>>>
      getRoutinesFromDb() async {
    final List<RoutineCbjEntity> routines = <RoutineCbjEntity>[];

    try {
      final Isar routinesBox = await Isar.open([RoutinesHiveModelSchema]);

      final List<RoutinesHiveModel> routinesHiveModelFromDb =
          await routinesBox.routinesHiveModels.where().findAll();

      await routinesBox.close();

      for (final RoutinesHiveModel routineHive in routinesHiveModelFromDb) {
        final RoutineCbjEntity routineEntity = RoutineCbjDtos.fromJson(
          jsonDecode(routineHive.routinesStringJson) as Map<String, dynamic>,
        ).toDomain();

        routines.add(
          routineEntity.copyWith(
            deviceStateGRPC: RoutineCbjDeviceStateGRPC(
              DeviceStateGRPC.waitingInComp.toString(),
            ),
          ),
        );
      }
      return right(routines);
    } catch (e) {
      logger.e('Local DB hive error while getting devices: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, List<BindingCbjEntity>>>
      getBindingsFromDb() async {
    final List<BindingCbjEntity> bindings = <BindingCbjEntity>[];

    try {
      final Isar bindingsBox = await Isar.open([BindingsHiveModelSchema]);

      final List<BindingsHiveModel> bindingsHiveModelFromDb =
          await bindingsBox.bindingsHiveModels.where().findAll();

      await bindingsBox.close();

      for (final BindingsHiveModel bindingIsar in bindingsHiveModelFromDb) {
        final BindingCbjEntity bindingEntity = BindingCbjDtos.fromJson(
          jsonDecode(bindingIsar.bindingsStringJson) as Map<String, dynamic>,
        ).toDomain();

        bindings.add(
          bindingEntity.copyWith(
            deviceStateGRPC: BindingCbjDeviceStateGRPC(
              DeviceStateGRPC.waitingInComp.toString(),
            ),
          ),
        );
      }
      return right(bindings);
    } catch (e) {
      logger.e('Local DB hive error while getting devices: $e');
    }
    return left(const LocalDbFailures.unexpected());
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveScenes({
    required List<SceneCbjEntity> sceneList,
  }) async {
    try {
      final List<ScenesHiveModel> scenesHiveList = [];

      final List<String> scenesListStringJson = List<String>.from(
        sceneList.map((e) => jsonEncode(e.toInfrastructure().toJson())),
      );

      for (final String scenesEntityDtosJsonString in scenesListStringJson) {
        final ScenesHiveModel scenesHiveModel = ScenesHiveModel()
          ..scenesStringJson = scenesEntityDtosJsonString;
        scenesHiveList.add(scenesHiveModel);
      }

      final Isar scenesBox = await Isar.open([ScenesHiveModelSchema]);

      await scenesBox.writeTxn(() async {
        await scenesBox.scenesHiveModels.clear();
        await scenesBox.scenesHiveModels.putAll(scenesHiveList);
      });

      await scenesBox.close();
      logger.i('Scenes got saved to local storage');
    } catch (e) {
      logger.e('Error saving Scenes to local storage\n$e');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveRoutines({
    required List<RoutineCbjEntity> routineList,
  }) async {
    try {
      final List<RoutinesHiveModel> routinesHiveList = [];

      final List<String> routinesListStringJson = List<String>.from(
        routineList.map((e) => jsonEncode(e.toInfrastructure().toJson())),
      );

      for (final String routinesEntityDtosJsonString
          in routinesListStringJson) {
        final RoutinesHiveModel routinesHiveModel = RoutinesHiveModel()
          ..routinesStringJson = routinesEntityDtosJsonString;
        routinesHiveList.add(routinesHiveModel);
      }

      final Isar routinesBox = await Isar.open([RoutinesHiveModelSchema]);

      await routinesBox.writeTxn(() async {
        await routinesBox.routinesHiveModels.clear();
        await routinesBox.routinesHiveModels
            .putAll(routinesHiveList); // insert & update
      });

      await routinesBox.close();
      logger.i('Routines got saved to local storage');
    } catch (e) {
      logger.e('Error saving Routines to local storage\n$e');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }

  @override
  Future<Either<LocalDbFailures, Unit>> saveBindings({
    required List<BindingCbjEntity> bindingList,
  }) async {
    try {
      final List<BindingsHiveModel> bindingsHiveList = [];

      final List<String> bindingsListStringJson = List<String>.from(
        bindingList.map((e) => jsonEncode(e.toInfrastructure().toJson())),
      );

      for (final String bindingsEntityDtosJsonString
          in bindingsListStringJson) {
        final BindingsHiveModel bindingsHiveModel = BindingsHiveModel()
          ..bindingsStringJson = bindingsEntityDtosJsonString;
        bindingsHiveList.add(bindingsHiveModel);
      }

      final Isar bindingsBox = await Isar.open([BindingsHiveModelSchema]);

      await bindingsBox.writeTxn(() async {
        await bindingsBox.bindingsHiveModels.clear();
        await bindingsBox.bindingsHiveModels.putAll(bindingsHiveList);
      });

      await bindingsBox.close();
      logger.i('Bindings got saved to local storage');
    } catch (e) {
      logger.e('Error saving Bindings to local storage\n$e');
      return left(const LocalDbFailures.unexpected());
    }

    return right(unit);
  }
}
