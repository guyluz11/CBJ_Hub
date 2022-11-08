import 'package:cbj_hub/infrastructure/system_commands/system_commands_manager_d.dart';

class MySingletonHelper {


  static Future<void> asyncConstractor() async{
    _systemCommandsManager =  SystemCommandsManager();
  }
  
  static late SystemCommandsManager _systemCommandsManager; 
  
  static Future<String> getUuid() {

    return _systemCommandsManager.getUuidOfCurrentDevice();
  }

  static Future<String> getCurrentUserName() {

    return _systemCommandsManager.getCurrentUserName();
  }

  static Future<String> getLocalDbPath(Future<String?> currentUserName) {
    return _systemCommandsManager.getLocalDbPath(_systemCommandsManager.getSnapCommonEnvironmentVariable(), currentUserName);
  }

  static Future<String> getProjectFilesLocation( String rootDirectoryPath ) {

    return _systemCommandsManager.getProjectFilesLocation(rootDirectoryPath);
  }
}
