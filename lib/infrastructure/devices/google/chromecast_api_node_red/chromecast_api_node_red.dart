import 'package:cbj_hub/domain/mqtt_server/i_mqtt_server_repository.dart';
import 'package:cbj_hub/domain/node_red/i_node_red_repository.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_converter.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_castv2_connection_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_castv2_sender_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_function_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_broker_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_in_node.dart';
import 'package:cbj_hub/injection.dart';

class ChromecastApiNodeRed {
  final String module = 'node-red-contrib-castv2';

  final String youtubeVideoProperty = 'youtubeVideo';
  final String playingVideoProperty = 'playingVideo';
  final String pauseVideoProperty = ' pauseVideo';

  Future<String> setNewYoutubeVideoNodes(
    String deviceUniqueId,
    String deviceIp,
  ) async {
    String nodes = '[\n';

    const String a = NodeRedConverter.nodeRedPluginsApi;

    final String nodeRedApiBaseTopic =
        getIt<IMqttServerRepository>().getNodeRedApiBaseTopic();

    final String nodeRedDevicesTopic =
        getIt<IMqttServerRepository>().getNodeRedDevicesTopicTypeName();

    const String mqttNodeName = 'Chromecast';

    final String topic =
        '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/$deviceUniqueId/$youtubeVideoProperty';

    /// Mqtt broker
    final NodeRedMqttBrokerNode mqttBrokerNode =
        NodeRedMqttBrokerNode(name: 'Cbj NodeRed plugs Api Broker');

    nodes += mqttBrokerNode.toString();

    /// Mqtt out

    // final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
    //   brokerNodeId: mqttBrokerNode.id,
    //   topic: topic,
    //   name: '$mqttNodeName - $playingVideoProperty',
    // );
    // nodes += ', ${mqttNode.toString()}';

    /// Cast v2 connection
    final NodeRedCastV2ConnectionNode nodeRedCastV2ConnectionNode =
        NodeRedCastV2ConnectionNode(host: deviceIp);
    nodes += ', ${nodeRedCastV2ConnectionNode.toString()}';

    /// Cast v2 sender
    final NodeRedCastV2SenderNode nodeRedCastV2SenderNode =
        NodeRedCastV2SenderNode(
      connectionId: nodeRedCastV2ConnectionNode.id,
      wires: [
        [
          // mqttNode.id
        ]
      ],
    );
    nodes += ', ${nodeRedCastV2SenderNode.toString()}';

    nodes += ', ${openUrlNodesString(
      mqttBrokerNode,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      '$topic/$playingVideoProperty',
    )}';

    nodes += ', ${pauseVideoNodesString(
      mqttBrokerNode,
      nodeRedCastV2SenderNode.id,
      mqttNodeName,
      '$topic/$pauseVideoProperty',
    )}';

    nodes += '\n]';

    /// Setting the flow
    final Future<String> settingTheFlowResponse =
        getIt<INodeRedRepository>().setFlowWithModule(
      moduleToUse: module,
      label: 'playYoutubeUrl',
      nodes: nodes,
      flowId: '$deviceUniqueId-YoutubeVideo',
    );
    return settingTheFlowResponse;
  }

  String openUrlNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"app\\\\\\": \\\\\\"YouTube\\\\\\", \\\\\\"type\\\\\\": \\\\\\"MEDIA\\\\\\",\\\\\\"videoId\\\\\\": \\\\\\"\\" + msg.payload + \\"\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $playingVideoProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: topic,
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String pauseVideoNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"STOP\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $pauseVideoProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: topic,
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }
}
