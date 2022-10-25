import 'package:isar/isar.dart';

part 'devices_hive_model.g.dart';

@collection
class DevicesHiveModel {
  Id id = Isar.autoIncrement;
  late String deviceStringJson;
}
