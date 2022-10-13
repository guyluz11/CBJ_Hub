import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/infrastructure/devices/tasmota/tasmota_ip/tasmota_ip_device_validators.dart';
import 'package:dartz/dartz.dart';

/// TasmotaIp device host name
class TasmotaIpHostName extends ValueObjectCore<String> {
  factory TasmotaIpHostName(String? input) {
    assert(input != null);
    return TasmotaIpHostName._(
      validateTasmotaIpHostNameNotEmpty(input!),
    );
  }

  const TasmotaIpHostName._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}

class TasmotaIpLastIp extends ValueObjectCore<String> {
  factory TasmotaIpLastIp(String? input) {
    assert(input != null);
    return TasmotaIpLastIp._(
      validateTasmotaIpLastIpNotEmpty(input!),
    );
  }

  const TasmotaIpLastIp._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}
