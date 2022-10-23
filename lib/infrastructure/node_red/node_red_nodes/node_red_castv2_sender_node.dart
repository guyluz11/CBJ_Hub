import 'package:cbj_hub/infrastructure/node_red/node_red_nodes/node_red_visual_node_abstract.dart';

/// Class for Node-Red castv2 node
/// https://nodered.org/docs/user-guide/writing-castv2s
class NodeRedCastv2Node extends NodeRedVisualNodeAbstract {
  NodeRedCastv2Node({
    required this.funcString,
    super.wires,
    super.name,
    required this.connectionId,
  }) : super(
          type: 'castv2-sender',
        );

  /// Take action and pass it down as property for the next node
  factory NodeRedCastv2Node.passOnlyNewAction({
    required String action,
    required String connectionId,
    List<List<String>>? wires,
    String? name,
  }) {
    final String castv2 = '''msg.payload=\\"$action\\"; return msg;''';
    return NodeRedCastv2Node(
      funcString: castv2,
      wires: wires,
      name: name,
      connectionId: connectionId,
    );
  }

  String funcString;
  String connectionId;

  @override
  String toString() {
    return '''
    {
        "id": "$id",
        "type": "$type",
        "z": "cc525388a451891a",
        "name": "$name",
        "connection": "$connectionId",
        "x": 640,
        "y": 260,
        "wires":  ${fixWiresForNodeRed()}
    }
''';
  }
}
