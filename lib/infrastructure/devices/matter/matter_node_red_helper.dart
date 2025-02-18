class MatterNodeRedHelper {
  factory MatterNodeRedHelper() => _instance;

  MatterNodeRedHelper._singletonContractor() {
    // createNodeReadConnector();
  }

  static final MatterNodeRedHelper _instance =
      MatterNodeRedHelper._singletonContractor();

  // Only one is needed
  // Future createNodeReadConnector() {
  //   NodeRedRepository.nodeRedRepositoryService
  //       .postFlow(label: 'Matter', nodes: nodes);
  // }
}
