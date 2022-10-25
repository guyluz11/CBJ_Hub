import 'package:isar/isar.dart';

part 'remote_pipes_hive_model.g.dart';

@collection
class RemotePipesHiveModel {
  Id id = Isar.autoIncrement;

  late String domainName;
}
