import 'package:cbj_hub/infrastructure/node_red/node_red_converter.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_broker_node.dart';

class ChromecastApiNodeRed {
  final String module = 'node-red-contrib-castv2';

  String setNewYoutubeVideo(
    String deviceUniqueId,
    String deviceIp,
    String youtubeVideoId,
  ) {
    String a = NodeRedConverter.nodeRedPluginsApi;

    final NodeRedMqttBrokerNode brokerNode =
        NodeRedMqttBrokerNode(name: 'Cbj NodeRed Api Broker');

    // getIt<INodeRedRepository>().setFlowWithModule(
    //   moduleToUse: module,
    //   label: 'playYoutubeUrl',
    //   //TODO: add nodes for device
    //   nodes: nodes,
    //   flowId: '$deviceUniqueId-YoutubeVideo',
    // );
    return 'a';
  }
}
