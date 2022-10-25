import 'package:isar/isar.dart';

part 'routines_hive_model.g.dart';

@collection
class RoutinesHiveModel {
  Id id = Isar.autoIncrement;
  late String routinesStringJson;
}
