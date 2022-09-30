import 'dart:convert';

import 'package:cbj_hub/domain/binding/binding_cbj_entity.dart';
import 'package:cbj_hub/domain/node_red/i_node_red_repository.dart';
import 'package:cbj_hub/domain/routine/routine_cbj_entity.dart';
import 'package:cbj_hub/domain/scene/scene_cbj_entity.dart';
import 'package:cbj_hub/infrastructure/node_red/node_red_api/node_red_api.dart';
import 'package:cbj_hub/utils.dart';
import 'package:http/src/response.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Control Node-RED, create scenes and more
@LazySingleton(as: INodeRedRepository)
class NodeRedRepository extends INodeRedRepository {
  NodeRedRepository() {
    _deviceIsReadyToSendInternetRequests = isThereInternetConnection();
  }

  /// Set _deviceIsReadyToSendInternetRequests to true when there is an internet
  Future<bool> isThereInternetConnection() async {
    while (true) {
      final bool result = await InternetConnectionChecker().hasConnection;
      if (result) {
        break;
      } else {
        logger.w(
          'Node-Red will not get connected until device is connected to www',
        );
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }
    return true;
  }

  /// Here to fix a bug where device crash if trying to send network requests
  /// before there is network.
  /// TODO: check if this can be removed in case we used 127.0.0.1 instead of
  /// localhost and not get this issue again
  /// https://github.com/CyBear-Jinni/cbj_hub/issues/150
  late Future<bool> _deviceIsReadyToSendInternetRequests;

  static NodeRedAPI nodeRedApi = NodeRedAPI();

  // /// List of all the scenes JSONs in Node-RED
  // List<String> scenesList = [];
  //
  // /// List of all the routines JSONs in Node-RED
  // List<String> routinesList = [];
  //
  // /// List of all the bindings JSONs in Node-RED
  // List<String> bindingsList = [];

  @override
  Future<String> createNewNodeRedScene(SceneCbjEntity sceneCbj) async {
    await _deviceIsReadyToSendInternetRequests;

    // final String flowId = sceneCbj.uniqueId.getOrCrash();

    try {
      if (sceneCbj.nodeRedFlowId.getOrCrash() != null) {
        await nodeRedApi.deleteFlowById(
          id: sceneCbj.nodeRedFlowId.getOrCrash()!,
        );
      }
      final Response response = await nodeRedApi.postFlow(
        label: sceneCbj.name.getOrCrash(),
        nodes: sceneCbj.automationString.getOrCrash()!,
        flowId: sceneCbj.uniqueId.getOrCrash(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBodyJson =
            json.decode(response.body) as Map<String, dynamic>;
        final String flowId = responseBodyJson["id"] as String;
        return flowId;
      } else if (response.statusCode == 400) {
        logger.w(
          'Scene probably already exist in node red status code\n${response.statusCode}',
        );
      } else {
        logger.e(
          'Error setting scene in node red status code\n${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString() ==
          'The remote computer refused the network connection.\r\n') {
        logger.e('Node-RED is not installed');
      } else {
        logger.e('Node-RED create new scene error:\n$e');
      }
    }
    return "";
  }

  @override
  Future<String> createNewNodeRedRoutine(RoutineCbjEntity routineCbj) async {
    await _deviceIsReadyToSendInternetRequests;
    // final String flowId = routineCbj.uniqueId.getOrCrash();

    try {
      // if (routinesList.contains(routineCbj.uniqueId.getOrCrash())) {
      //   await nodeRedApi.deleteFlowById(id: flowId);
      // }
      final Response response = await nodeRedApi.postFlow(
        label: routineCbj.name.getOrCrash(),
        nodes: routineCbj.automationString.getOrCrash()!,
        flowId: routineCbj.uniqueId.getOrCrash(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBodyJson =
            json.decode(response.body) as Map<String, dynamic>;
        final String flowId = responseBodyJson["id"] as String;
        return flowId;
      } else if (response.statusCode == 400) {
        logger.w(
          'Routine probably already exist in node red status code\n${response.statusCode}',
        );
      } else {
        logger.e(
          'Error setting routine in node red status code\n${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString() ==
          'The remote computer refused the network connection.\r\n') {
        logger.e('Node-RED is not installed');
      } else {
        logger.e('Node-RED create new routine error:\n$e');
      }
    }
    return "";
  }

  @override
  Future<String> createNewNodeRedBinding(BindingCbjEntity bindingCbj) async {
    await _deviceIsReadyToSendInternetRequests;

    try {
      // if (bindingsList.contains(bindingCbj.uniqueId.getOrCrash())) {
      //   await nodeRedApi.deleteFlowById(id: flowId);
      // }
      final Response response = await nodeRedApi.postFlow(
        label: bindingCbj.name.getOrCrash(),
        nodes: bindingCbj.automationString.getOrCrash()!,
        flowId: bindingCbj.uniqueId.getOrCrash(),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBodyJson =
            json.decode(response.body) as Map<String, dynamic>;
        final String flowId = responseBodyJson["id"] as String;
        return flowId;
      } else if (response.statusCode == 400) {
        logger.w(
          'Binding probably already exist in node red status code\n${response.statusCode}',
        );
      } else {
        logger.e(
          'Error setting binding in node red status code\n${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString() ==
          'The remote computer refused the network connection.\r\n') {
        logger.e('Node-RED is not installed');
      } else {
        logger.e('Node-RED create new Binding error:\n$e');
      }
    }
    return "";
  }
}
