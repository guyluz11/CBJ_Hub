import 'package:isar/isar.dart';

part 'bindings_hive_model.g.dart';

@collection
class BindingsHiveModel {
  Id id = Isar.autoIncrement;
  late String bindingsStringJson;
}
