import 'package:isar/isar.dart';

part 'tuya_vendor_credentials_hive_model.g.dart';

@collection
class TuyaVendorCredentialsHiveModel {
  Id id = Isar.autoIncrement;

  late String? senderUniqueId;
  late String tuyaUserName;
  late String tuyaUserPassword;
  late String tuyaCountryCode;
  late String tuyaBizType;
  late String tuyaRegion;
  late String loginVendor;
}
