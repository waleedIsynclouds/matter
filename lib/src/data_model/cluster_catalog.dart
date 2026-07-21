import 'cluster_catalog_data.g.dart';

enum MatterValueType {
  unknown,
  uint,
  int,
  bool,
  string,
  octetString,
  float,
  doubleValue,
  struct,
  array,
  list,
}

class ClusterInfo {
  final String name;
  final Map<int, AttributeInfo> attributes;
  final Map<int, CommandInfo> commands;

  const ClusterInfo({
    required this.name,
    this.attributes = const {},
    this.commands = const {},
  });
}

class AttributeInfo {
  final String name;
  final MatterValueType type;

  const AttributeInfo({
    required this.name,
    this.type = MatterValueType.unknown,
  });
}

class CommandInfo {
  final String name;
  final List<CommandFieldInfo> fields;

  const CommandInfo({required this.name, this.fields = const []});
}

class CommandFieldInfo {
  final int tag;
  final String name;
  final MatterValueType type;
  final bool nullable;

  const CommandFieldInfo({
    required this.tag,
    required this.name,
    this.type = MatterValueType.unknown,
    this.nullable = false,
  });
}

const Map<int, ClusterInfo> clusterCatalog = generatedClusterCatalog;

ClusterInfo? clusterInfoForId(int clusterId) => clusterCatalog[clusterId];

String matterClusterName(int clusterId) {
  return clusterCatalog[clusterId]?.name ?? 'Cluster ${matterHex(clusterId)}';
}

String matterAttributeName(int clusterId, int attributeId) {
  return clusterCatalog[clusterId]?.attributes[attributeId]?.name ??
      'Attribute ${matterHex(attributeId)}';
}

String matterHex(int value, {int width = 4}) {
  return '0x${value.toRadixString(16).toUpperCase().padLeft(width, '0')}';
}
