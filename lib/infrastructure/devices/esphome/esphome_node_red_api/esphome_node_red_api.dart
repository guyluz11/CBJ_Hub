import 'package:cbj_hub/domain/mqtt_server/i_mqtt_server_repository.dart';
import 'package:cbj_hub/domain/node_red/i_node_red_repository.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/contrib_esphome_nodes/node_red_esphome_device_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_function_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_broker_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_in_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_out_node.dart';
import 'package:cbj_hub/injection.dart';

/// TODO: Change the code to fit ESPHome node Red API
class EsphomeNodeRedApi {
  final String module = 'node-red-contrib-esphome';

  final String youtubeVideoTopicProperty = 'youtubeVideo';
  final String playingVideoTopicProperty = 'playingVideo';
  final String pauseVideoTopicProperty = 'pauseVideo';
  final String stopVideoTopicProperty = 'stopVideo';
  final String playVideoTopicProperty = 'playVideo';
  final String queuePrevVideoTopicProperty = 'queuePrevVideo';
  final String queueNextVideoTopicProperty = 'queueNextVideo';
  final String closeAppTopicProperty = 'closeApp';
  final String outputVideoTopicProperty = 'outputVideo';

  Future<String> setNewYoutubeVideoNodes(
    String deviceUniqueId,
    String deviceIp,
  ) async {
    String nodes = '[\n';

    final String nodeRedApiBaseTopic =
        getIt<IMqttServerRepository>().getNodeRedApiBaseTopic();

    final String nodeRedDevicesTopic =
        getIt<IMqttServerRepository>().getNodeRedDevicesTopicTypeName();

    const String mqttNodeName = 'Esphome';

    final String topic =
        '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/$deviceUniqueId/$youtubeVideoTopicProperty';

    /// Mqtt broker
    final NodeRedMqttBrokerNode mqttBrokerNode =
        NodeRedMqttBrokerNode(name: 'Cbj NodeRed plugs Api Broker');

    nodes += mqttBrokerNode.toString();

    /// Mqtt out

    final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$outputVideoTopicProperty',
      name: '$mqttNodeName - $outputVideoTopicProperty',
    );
    nodes += ', ${mqttNode.toString()}';

    /// Cast v2 connection
    final NodeRedEspHomeDeviceNode nodeRedEspHomeDeviceNode =
        NodeRedEspHomeDeviceNode(host: deviceIp);
    nodes += ', ${nodeRedEspHomeDeviceNode.toString()}';

    /// Cast v2 sender
    final NodeRedEspHomeDeviceNode esphomeNodeRedApi = NodeRedEspHomeDeviceNode(
      host: nodeRedEspHomeDeviceNode.id,
      wires: [
        [
          mqttNode.id,
        ]
      ],
    );
    nodes += ', ${esphomeNodeRedApi.toString()}';

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
      name: '$mqttNodeName - $playingVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$playingVideoTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String stopVideoNodesString(
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
      name: '$mqttNodeName - $stopVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$stopVideoTopicProperty',
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
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PAUSE\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $pauseVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$pauseVideoTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String playVideoNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"PLAY\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $playVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$playVideoTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String queuePrevVideoNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_PREV\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $queuePrevVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$queuePrevVideoTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String queueNextVideoNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"QUEUE_NEXT\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $queueNextVideoTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$queueNextVideoTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }

  String closeVideoNodesString(
    NodeRedMqttBrokerNode mqttBrokerNode,
    String nextNodeIdToConnectToo,
    String mqttNodeName,
    String topic,
  ) {
    String nodes = '';

    /// Function node
    const String functionString =
        '''msg.payload = JSON.parse(\\"{\\\\\\"type\\\\\\": \\\\\\"CLOSE\\\\\\"}\\"); return msg;''';
    final NodeRedFunctionNode nodeRedFunctionNode = NodeRedFunctionNode(
      funcString: functionString,
      wires: [
        [nextNodeIdToConnectToo]
      ],
    );
    nodes += nodeRedFunctionNode.toString();

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $closeAppTopicProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$closeAppTopicProperty',
      wires: [
        [nodeRedFunctionNode.id]
      ],
    );
    return '$nodes,\n$nodeRedMqttInNode';
  }
}
