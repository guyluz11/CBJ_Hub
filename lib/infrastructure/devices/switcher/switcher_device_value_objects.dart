import 'package:cbj_hub/domain/generic_devices/abstract_device/core_failures.dart';
import 'package:cbj_hub/domain/generic_devices/abstract_device/value_objects_core.dart';
import 'package:cbj_hub/infrastructure/devices/switcher/switcher_device_validators.dart';
import 'package:dartz/dartz.dart';

/// Switcher communication port
class SwitcherPort extends ValueObjectCore<String> {
  factory SwitcherPort(String? input) {
    assert(input != null);
    return SwitcherPort._(
      validateSwitcherPortNotEmpty(input!),
    );
  }

  const SwitcherPort._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}

/// Switcher communication port
class SwitcherMacAddress extends ValueObjectCore<String> {
  factory SwitcherMacAddress(String? input) {
    assert(input != null);
    return SwitcherMacAddress._(
      validateSwitcherMacAddressNotEmpty(input!),
    );
  }

  const SwitcherMacAddress._(this.value);

  @override
  final Either<CoreFailure<String>, String> value;
}
