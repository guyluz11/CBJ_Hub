import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_visual_node_abstract.dart';

/// Class for Node-Red castv2 node
/// https://flows.nodered.org/node/node-red-contrib-castv2
class NodeRedEspHomeDeviceNode extends NodeRedVisualNodeAbstract {
  NodeRedEspHomeDeviceNode({
    required this.host,
    super.wires,
    super.name,
  }) : super(
          type: 'esphome-device',
        );

  factory NodeRedEspHomeDeviceNode.passOnlyNewAction({
    required String host,
    List<List<String>>? wires,
    String? name,
  }) {
    return NodeRedEspHomeDeviceNode(
      wires: wires,
      name: name,
      host: host,
    );
  }

  String host;

  @override
  String toString() {
    return '''
    {
      "id": "$id",
      "type": "$type",
      "name": "$name",
      "target": "",
      "host": "$host",
      "port": "6053"
    }
''';
  }
}
