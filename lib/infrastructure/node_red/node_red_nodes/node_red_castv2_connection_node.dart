import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_visual_node_abstract.dart';

/// Class for Node-Red castv2 node
/// https://nodered.org/docs/user-guide/writing-castv2s
class NodeRedCastv2Node extends NodeRedVisualNodeAbstract {
  NodeRedCastv2Node({
    required this.funcString,
    super.wires,
    super.name,
  }) : super(
          type: 'castv2-connection',
        );

  /// Take action and pass it down as property for the next node
  factory NodeRedCastv2Node.passOnlyNewAction({
    required String action,
    List<List<String>>? wires,
    String? name,
  }) {
    final String castV2 = '''msg.payload=\\"$action\\"; return msg;''';
    return NodeRedCastv2Node(funcString: castV2, wires: wires, name: name);
  }

  String funcString;

  @override
  String toString() {
    return '''
    {
       "id": "$id",
        "type": "$type",
        "name": "$name",
        "target": "",
        "host": "192.168.31.84",
        "port": "8009"
    }
''';
  }
}
