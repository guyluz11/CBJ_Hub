import 'package:cbj_hub/domain/binding/binding_cbj_entity.dart';
import 'package:cbj_hub/domain/routine/routine_cbj_entity.dart';
import 'package:cbj_hub/domain/scene/scene_cbj_entity.dart';

/// Class to define all Node RED repo functions
abstract class INodeRedRepository {
  /// Function to create new scene in Node-RED
  Future<String> createNewNodeRedScene(SceneCbjEntity sceneCbj);

  // /// Replace existing scene with new one
  // Future<bool> replaceSceneWithNewNodeRedScene(SceneCbjEntity sceneCbj);

  /// Function to create new routine in Node-RED
  Future<String> createNewNodeRedRoutine(RoutineCbjEntity routineCbj);

  /// Function to create new binding in Node-RED
  Future<String> createNewNodeRedBinding(BindingCbjEntity bindingCbj);
}
