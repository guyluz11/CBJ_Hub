import 'package:cbj_hub/domain/mqtt_server/i_mqtt_server_repository.dart';
import 'package:cbj_hub/domain/node_red/i_node_red_repository.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/contrib_esphome_nodes/node_red_esphome_device_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/contrib_esphome_nodes/node_red_esphome_in_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/contrib_esphome_nodes/node_red_esphome_out_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_broker_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_in_node.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_mqtt_out_node.dart';
import 'package:cbj_hub/injection.dart';

/// TODO: Change the code to fit ESPHome node Red API
class EsphomeNodeRedApi {
  final String module = 'node-red-contrib-esphome';

  final String deviceStateProperty = 'deviceStateProperty';
  final String inputDeviceProperty = 'inputDeviceProperty';
  final String outputDeviceProperty = 'outputDeviceProperty';

  Future<String> setNewStateNodes(
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
        '$nodeRedApiBaseTopic/$nodeRedDevicesTopic/$deviceUniqueId/$deviceStateProperty';

    /// Mqtt broker
    final NodeRedMqttBrokerNode mqttBrokerNode =
        NodeRedMqttBrokerNode(name: 'Cbj NodeRed plugs Api Broker');

    nodes += mqttBrokerNode.toString();

    /// Mqtt out

    final NodeRedMqttOutNode mqttNode = NodeRedMqttOutNode(
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$outputDeviceProperty',
      name: '$mqttNodeName - $outputDeviceProperty',
    );
    nodes += ', ${mqttNode.toString()}';

    /// Device connection
    final NodeRedEspHomeDeviceNode nodeRedEspHomeDeviceNode =
        NodeRedEspHomeDeviceNode(
      host: deviceIp,
      name: 'ESPHome $deviceUniqueId device type',
    );
    nodes += ', ${nodeRedEspHomeDeviceNode.toString()}';

    /// Create an EspHome out node
    final NodeRedEspHomeOutNode nodeRedEspHomeOutNode = NodeRedEspHomeOutNode(
      wires: [
        [
          mqttNode.id,
        ]
      ],
      espHomeNodeDeviceId: nodeRedEspHomeDeviceNode.id,
      name: 'ESPHome $deviceUniqueId out type',
    );
    nodes += ', ${nodeRedEspHomeOutNode.toString()}';

    /// Mqtt in
    final NodeRedMqttInNode nodeRedMqttInNode = NodeRedMqttInNode(
      name: '$mqttNodeName - $inputDeviceProperty',
      brokerNodeId: mqttBrokerNode.id,
      topic: '$topic/$inputDeviceProperty',
      wires: [
        [nodeRedEspHomeOutNode.id]
      ],
    );
    nodes += ', ${nodeRedMqttInNode.toString()}';

    /// Create an EspHome in node
    final NodeRedEspHomeInNode nodeRedEspHomeInNode = NodeRedEspHomeInNode(
      wires: [
        [
          mqttNode.id,
        ]
      ],
      espHomeNodeDeviceId: nodeRedEspHomeDeviceNode.id,
      name: 'ESPHome $deviceUniqueId in type',
    );
    nodes += ', ${nodeRedEspHomeInNode.toString()}';

    nodes += '\n]';

    /// Setting the flow
    final Future<String> settingTheFlowResponse =
        getIt<INodeRedRepository>().setFlowWithModule(
      moduleToUse: module,
      label: 'setDeviceState',
      nodes: nodes,
      flowId: '$deviceUniqueId-EspDeviceState',
    );
    return settingTheFlowResponse;
  }
}
