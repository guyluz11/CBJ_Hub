import 'package:isar/isar.dart';

part 'hub_entity_hive_model.g.dart';

@collection
class HubEntityHiveModel {
  Id id = Isar.autoIncrement;

  late String hubNetworkBssid;
  late String networkName;
  late String lastKnownIp;
}
