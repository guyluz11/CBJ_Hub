import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/infrastructure/devices/google/google_device_validators.dart';
import 'package:dartz/dartz.dart';

/// Google communication port
class GooglePort extends ValueObjectCore<String> {
  factory GooglePort(String? input) {
    assert(input != null);
    return GooglePort._(
      validateGooglePortNotEmpty(input!),
    );
  }

  const GooglePort._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}
