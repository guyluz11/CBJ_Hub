// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'domain/app_communication/i_app_communication_repository.dart' as _i6;
import 'domain/binding/i_binding_cbj_repository.dart' as _i8;
import 'domain/cbj_web_server/i_cbj_web_server_repository.dart' as _i10;
import 'domain/local_db/i_local_db_repository.dart' as _i12;
import 'domain/mqtt_server/i_mqtt_server_repository.dart' as _i14;
import 'domain/node_red/i_node_red_repository.dart' as _i16;
import 'domain/rooms/i_saved_rooms_repo.dart' as _i22;
import 'domain/routine/i_routine_cbj_repository.dart' as _i18;
import 'domain/saved_devices/i_saved_devices_repo.dart' as _i20;
import 'domain/scene/i_scene_cbj_repository.dart' as _i24;
import 'infrastructure/app_communication/app_communication_repository.dart'
    as _i7;
import 'infrastructure/bindings/binding_repository.dart' as _i9;
import 'infrastructure/cbj_web_server/cbj_web_server_repository.dart' as _i11;
import 'infrastructure/devices/cbj_devices/cbj_devices_connector_conjector.dart'
    as _i3;
import 'infrastructure/devices/esphome/esphome_connector_conjector.dart' as _i4;
import 'infrastructure/devices/google/google_connector_conjector.dart' as _i5;
import 'infrastructure/devices/lg/lg_connector_conjector.dart' as _i26;
import 'infrastructure/devices/lifx/lifx_connector_conjector.dart' as _i27;
import 'infrastructure/devices/philips_hue/philips_hue_connector_conjector.dart'
    as _i28;
import 'infrastructure/devices/shelly/shelly_connector_conjector.dart' as _i29;
import 'infrastructure/devices/sonoff_diy/sonoff_diy_connector_conjector.dart'
    as _i30;
import 'infrastructure/devices/switcher/switcher_connector_conjector.dart'
    as _i31;
import 'infrastructure/devices/tasmota/tasmota_ip/tasmota_ip_connector_conjector.dart'
    as _i32;
import 'infrastructure/devices/tasmota/tasmota_mqtt/tasmota_mqtt_connector_conjector.dart'
    as _i33;
import 'infrastructure/devices/tuya_smart/tuya_smart_connector_conjector.dart'
    as _i34;
import 'infrastructure/devices/xiaomi_io/xiaomi_io_connector_conjector.dart'
    as _i35;
import 'infrastructure/devices/yeelight/yeelight_connector_conjector.dart'
    as _i36;
import 'infrastructure/local_db/local_db_repository.dart' as _i13;
import 'infrastructure/mqtt_server/mqtt_server_repository.dart' as _i15;
import 'infrastructure/node_red/node_red_repository.dart' as _i17;
import 'infrastructure/room/saved_rooms_repo.dart' as _i23;
import 'infrastructure/routines/routine_repository.dart' as _i19;
import 'infrastructure/saved_devices/saved_devices_repo.dart' as _i21;
import 'infrastructure/scenes/scene_repository.dart'
    as _i25; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.CbjDevicesConnectorConjector>(
      _i3.CbjDevicesConnectorConjector());
  gh.singleton<_i4.EspHomeConnectorConjector>(_i4.EspHomeConnectorConjector());
  gh.singleton<_i5.GoogleConnectorConjector>(_i5.GoogleConnectorConjector());
  gh.lazySingleton<_i6.IAppCommunicationRepository>(
      () => _i7.AppCommunicationRepository());
  gh.lazySingleton<_i8.IBindingCbjRepository>(() => _i9.BindingCbjRepository());
  gh.lazySingleton<_i10.ICbjWebServerRepository>(
      () => _i11.CbjWebServerRepository());
  gh.lazySingleton<_i12.ILocalDbRepository>(() => _i13.HiveRepository());
  gh.lazySingleton<_i14.IMqttServerRepository>(
      () => _i15.MqttServerRepository());
  gh.lazySingleton<_i16.INodeRedRepository>(() => _i17.NodeRedRepository());
  gh.lazySingleton<_i18.IRoutineCbjRepository>(
      () => _i19.RoutineCbjRepository());
  gh.lazySingleton<_i20.ISavedDevicesRepo>(() => _i21.SavedDevicesRepo());
  gh.lazySingleton<_i22.ISavedRoomsRepo>(() => _i23.SavedRoomsRepo());
  gh.lazySingleton<_i24.ISceneCbjRepository>(() => _i25.SceneCbjRepository());
  gh.singleton<_i26.LgConnectorConjector>(_i26.LgConnectorConjector());
  gh.singleton<_i27.LifxConnectorConjector>(_i27.LifxConnectorConjector());
  gh.singleton<_i28.PhilipsHueConnectorConjector>(
      _i28.PhilipsHueConnectorConjector());
  gh.singleton<_i29.ShellyConnectorConjector>(_i29.ShellyConnectorConjector());
  gh.singleton<_i30.SonoffDiyConnectorConjector>(
      _i30.SonoffDiyConnectorConjector());
  gh.singleton<_i31.SwitcherConnectorConjector>(
      _i31.SwitcherConnectorConjector());
  gh.singleton<_i32.TasmotaIpConnectorConjector>(
      _i32.TasmotaIpConnectorConjector());
  gh.singleton<_i33.TasmotaMqttConnectorConjector>(
      _i33.TasmotaMqttConnectorConjector());
  gh.singleton<_i34.TuyaSmartConnectorConjector>(
      _i34.TuyaSmartConnectorConjector());
  gh.singleton<_i35.XiaomiIoConnectorConjector>(
      _i35.XiaomiIoConnectorConjector());
  gh.singleton<_i36.YeelightConnectorConjector>(
      _i36.YeelightConnectorConjector());
  return get;
}
