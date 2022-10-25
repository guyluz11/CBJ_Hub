import 'package:isar/isar.dart';

part 'scenes_hive_model.g.dart';

@collection
class ScenesHiveModel {
  Id id = Isar.autoIncrement;
  late String scenesStringJson;
}
