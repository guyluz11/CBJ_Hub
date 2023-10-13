/// A cbj web server to interact with get current state requests from mqtt as
/// well as website to change devices state locally on the network without
/// the need of installing any app.
abstract class ICbjWebServerRepository {
  ICbjWebServerRepository() {
    instance = this;
  }

  static late ICbjWebServerRepository instance;

  /// Start the web server
  Future<void> startWebServer();

  /// Get device state
  void getDeviceState(String id) {}
}
