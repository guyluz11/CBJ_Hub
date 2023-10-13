// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cbj_hub/domain/app_communication/i_app_communication_repository.dart'
    as _i3;
import 'package:cbj_hub/domain/binding/i_binding_cbj_repository.dart' as _i5;
import 'package:cbj_hub/domain/cbj_web_server/i_cbj_web_server_repository.dart'
    as _i7;
import 'package:cbj_hub/domain/rooms/i_saved_rooms_repo.dart' as _i15;
import 'package:cbj_hub/domain/routine/i_routine_cbj_repository.dart' as _i11;
import 'package:cbj_hub/domain/scene/i_scene_cbj_repository.dart' as _i17;
import 'package:cbj_hub/infrastructure/app_communication/app_communication_repository.dart'
    as _i4;
import 'package:cbj_hub/infrastructure/bindings/binding_repository.dart' as _i6;
import 'package:cbj_hub/infrastructure/cbj_web_server/cbj_web_server_repository.dart'
    as _i8;
import 'package:cbj_hub/infrastructure/mqtt_server/mqtt_server_repository.dart'
    as _i10;
import 'package:cbj_hub/infrastructure/node_red/node_red_repository.dart'
    as _i19;
import 'package:cbj_hub/infrastructure/room/saved_rooms_repo.dart' as _i16;
import 'package:cbj_hub/infrastructure/routines/routine_repository.dart'
    as _i12;
import 'package:cbj_hub/infrastructure/saved_devices/saved_devices_repo.dart'
    as _i14;
import 'package:cbj_hub/infrastructure/scenes/scene_repository.dart' as _i18;
import 'package:cbj_hub/infrastructure/shared_variables.dart' as _i20;
import 'package:cbj_integrations_controller/domain/mqtt_server/i_mqtt_server_repository.dart'
    as _i9;
import 'package:cbj_integrations_controller/domain/saved_devices/i_saved_devices_repo.dart'
    as _i13;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i3.IAppCommunicationRepository>(
        () => _i4.AppCommunicationRepository());
    gh.lazySingleton<_i5.IBindingCbjRepository>(
        () => _i6.BindingCbjRepository());
    gh.lazySingleton<_i7.ICbjWebServerRepository>(
        () => _i8.CbjWebServerRepository());
    gh.lazySingleton<_i9.IMqttServerRepository>(
        () => _i10.MqttServerRepository());
    gh.lazySingleton<_i11.IRoutineCbjRepository>(
        () => _i12.RoutineCbjRepository());
    gh.lazySingleton<_i13.ISavedDevicesRepo>(() => _i14.SavedDevicesRepo());
    gh.lazySingleton<_i15.ISavedRoomsRepo>(() => _i16.SavedRoomsRepo());
    gh.lazySingleton<_i17.ISceneCbjRepository>(() => _i18.SceneCbjRepository());
    gh.lazySingleton<_i19.NodeRedRepository>(() => _i19.NodeRedRepository());
    gh.singleton<_i20.SharedVariables>(_i20.SharedVariables());
    return this;
  }
}
