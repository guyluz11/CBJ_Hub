import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/infrastructure/devices/philips_hue/philips_hue_device_validators.dart';
import 'package:dartz/dartz.dart';

/// PhilipsHue communication port
class PhilipsHuePort extends ValueObjectCore<String> {
  factory PhilipsHuePort(String? input) {
    assert(input != null);
    return PhilipsHuePort._(
      validatePhilipsHuePortNotEmpty(input!),
    );
  }

  const PhilipsHuePort._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}
