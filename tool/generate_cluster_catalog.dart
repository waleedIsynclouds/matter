import 'dart:io';

const _clusterScope = {
  'Descriptor',
  'BasicInformation',
  'OnOff',
  'LevelControl',
  'ColorControl',
  'DoorLock',
  'WindowCovering',
  'Thermostat',
  'IlluminanceMeasurement',
  'TemperatureMeasurement',
  'PressureMeasurement',
  'FlowMeasurement',
  'RelativeHumidityMeasurement',
  'OccupancySensing',
  'Groups',
  'ScenesManagement',
  'GroupKeyManagement',
  'GeneralDiagnostics',
  'SoftwareDiagnostics',
  'ThreadNetworkDiagnostics',
  'WiFiNetworkDiagnostics',
  'OTASoftwareUpdateProvider',
  'OTASoftwareUpdateRequestor',
  'OperationalCredentials',
  'AdministratorCommissioning',
};

const _legacyClusterAliases = {
  'Basic': 'BasicInformation',
  'OtaSoftwareUpdateProvider': 'OTASoftwareUpdateProvider',
  'OtaSoftwareUpdateRequestor': 'OTASoftwareUpdateRequestor',
};

const _globalAttributeIds = {
  'GeneratedCommandList': 0xFFF8,
  'AcceptedCommandList': 0xFFF9,
  'EventList': 0xFFFA,
  'AttributeList': 0xFFFB,
  'FeatureMap': 0xFFFC,
  'ClusterRevision': 0xFFFD,
};

const _manualCommands = {
  'OnOff': {
    'Off': 0x00,
    'On': 0x01,
    'Toggle': 0x02,
    'OffWithEffect': 0x40,
    'OnWithRecallGlobalScene': 0x41,
    'OnWithTimedOff': 0x42,
  },
  'Groups': {
    'AddGroup': 0x00,
    'ViewGroup': 0x01,
    'GetGroupMembership': 0x02,
    'RemoveGroup': 0x03,
    'RemoveAllGroups': 0x04,
    'AddGroupIfIdentifying': 0x05,
  },
  'LevelControl': {
    'MoveToLevel': 0x00,
    'Move': 0x01,
    'Step': 0x02,
    'Stop': 0x03,
    'MoveToLevelWithOnOff': 0x04,
    'MoveWithOnOff': 0x05,
    'StepWithOnOff': 0x06,
    'StopWithOnOff': 0x07,
    'MoveToClosestFrequency': 0x08,
  },
  'AdministratorCommissioning': {
    'OpenCommissioningWindow': 0x00,
    'OpenBasicCommissioningWindow': 0x01,
    'RevokeCommissioning': 0x02,
  },
  'OperationalCredentials': {
    'AttestationRequest': 0x00,
    'AttestationResponse': 0x01,
    'CertificateChainRequest': 0x02,
    'CertificateChainResponse': 0x03,
    'CSRRequest': 0x04,
    'CSRResponse': 0x05,
    'AddNOC': 0x06,
    'UpdateNOC': 0x07,
    'NOCResponse': 0x08,
    'UpdateFabricLabel': 0x09,
    'RemoveFabric': 0x0A,
    'AddTrustedRootCertificate': 0x0B,
  },
};

void main() {
  final constants = File(
    'ios/frameworks/ZGMatter.framework/Headers/ZGMTRClusterConstants.h',
  ).readAsStringSync();
  final baseClusters = File(
    'ios/frameworks/ZGMatter.framework/Headers/ZGMTRBaseClusters.h',
  ).readAsStringSync();
  final payloads = File(
    'ios/frameworks/ZGMatter.framework/Headers/ZGMTRCommandPayloadsObjc.h',
  ).readAsStringSync();

  final clusters = _parseClusters(constants);
  final attributes = _parseAttributes(constants);
  final attributeTypes = _parseAttributeTypes(baseClusters);
  final commands = _parseCommands(constants, payloads);

  final buffer = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Run: dart run tool/generate_cluster_catalog.dart')
    ..writeln()
    ..writeln("import 'cluster_catalog.dart';")
    ..writeln()
    ..writeln('const Map<int, ClusterInfo> generatedClusterCatalog = {');

  for (final cluster
      in clusters.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value))) {
    final key = cluster.key;
    final id = cluster.value;
    buffer
      ..writeln('  ${_hexLiteral(id, 8)}: ClusterInfo(')
      ..writeln("    name: '${_displayName(key)}',")
      ..writeln('    attributes: {');
    for (final attribute
        in (attributes[key] ?? const <int, String>{}).entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key))) {
      final type = attributeTypes[key]?[attribute.value] ?? 'unknown';
      buffer.writeln(
        "      ${_hexLiteral(attribute.key, 8)}: AttributeInfo(name: '${_displayName(attribute.value)}', type: MatterValueType.$type),",
      );
    }
    buffer.writeln('    },');
    buffer.writeln('    commands: {');
    for (final command
        in (commands[key] ?? const <int, _Command>{}).entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key))) {
      buffer
        ..writeln('      ${_hexLiteral(command.key, 8)}: CommandInfo(')
        ..writeln("        name: '${_displayName(command.value.name)}',")
        ..writeln('        fields: [');
      for (final field in command.value.fields) {
        buffer.writeln(
          "          CommandFieldInfo(tag: ${field.tag}, name: '${_displayName(field.name)}', type: MatterValueType.${field.type}, nullable: ${field.nullable}),",
        );
      }
      buffer
        ..writeln('        ],')
        ..writeln('      ),');
    }
    buffer
      ..writeln('    },')
      ..writeln('  ),');
  }
  buffer.writeln('};');

  final output = File('lib/src/data_model/cluster_catalog_data.g.dart');
  output.createSync(recursive: true);
  output.writeAsStringSync(buffer.toString());
}

Map<String, int> _parseClusters(String constants) {
  final clusters = <String, int>{};
  final re = RegExp(
    r'ZGMTRCluster(?:IDType)?([A-Za-z0-9]+)ID\b[^=]*=\s*(0x[0-9A-Fa-f]+)',
  );
  for (final match in re.allMatches(constants)) {
    final raw = match.group(1)!;
    final name = _normalizeCluster(raw);
    if (!_clusterScope.contains(name)) {
      continue;
    }
    clusters[name] = int.parse(match.group(2)!.substring(2), radix: 16);
  }
  return clusters;
}

Map<String, Map<int, String>> _parseAttributes(String constants) {
  final attributes = <String, Map<int, String>>{};
  final re = RegExp(
    r'ZGMTRAttributeIDTypeCluster([A-Za-z0-9]+)Attribute([A-Za-z0-9]+)ID\b[^=]*=\s*([^,\n]+)',
  );
  for (final match in re.allMatches(constants)) {
    final cluster = _normalizeCluster(match.group(1)!);
    if (!_clusterScope.contains(cluster)) {
      continue;
    }
    final value = match.group(3)!.trim();
    final id = value.startsWith('0x')
        ? int.parse(value.substring(2), radix: 16)
        : _globalAttributeIds[match.group(2)!];
    if (id == null) {
      continue;
    }
    attributes.putIfAbsent(cluster, () => {})[id] = match.group(2)!;
  }
  return attributes;
}

Map<String, Map<String, String>> _parseAttributeTypes(String baseClusters) {
  final types = <String, Map<String, String>>{};
  final clusterRe = RegExp(
    r'@interface ZGMTRBaseCluster([A-Za-z0-9]+) : ZGMTRGenericBaseCluster(.*?)- \(instancetype\)init NS_UNAVAILABLE;',
    dotAll: true,
  );
  final attrRe = RegExp(
    r'readAttribute([A-Za-z0-9]+)With(?:Completion|Params):.*?\(\^\)\(([^)]+?) value, NSError',
    dotAll: true,
  );
  for (final clusterMatch in clusterRe.allMatches(baseClusters)) {
    final cluster = _normalizeCluster(clusterMatch.group(1)!);
    if (!_clusterScope.contains(cluster)) {
      continue;
    }
    final body = clusterMatch.group(2)!;
    for (final attrMatch in attrRe.allMatches(body)) {
      types.putIfAbsent(cluster, () => {})[attrMatch.group(1)!] =
          _objcTypeToMatterType(attrMatch.group(2)!);
    }
  }
  return types;
}

Map<String, Map<int, _Command>> _parseCommands(
  String constants,
  String payloads,
) {
  final commands = <String, Map<int, _Command>>{};
  final commandRe = RegExp(
    r'ZGMTRCommandIDTypeCluster([A-Za-z0-9]+)Command([A-Za-z0-9]+)ID\b[^=]*=\s*(0x[0-9A-Fa-f]+)',
  );
  for (final match in commandRe.allMatches(constants)) {
    final cluster = _normalizeCluster(match.group(1)!);
    if (!_clusterScope.contains(cluster)) {
      continue;
    }
    final name = match.group(2)!;
    commands.putIfAbsent(cluster, () => {})[int.parse(
      match.group(3)!.substring(2),
      radix: 16,
    )] = _Command(
      name,
      _parseCommandFields(payloads, cluster, name),
    );
  }
  _manualCommands.forEach((cluster, clusterCommands) {
    if (!_clusterScope.contains(cluster)) {
      return;
    }
    clusterCommands.forEach((name, id) {
      commands.putIfAbsent(cluster, () => {})[id] = _Command(
        name,
        _parseCommandFields(payloads, cluster, name),
      );
    });
  });
  return commands;
}

List<_Field> _parseCommandFields(
  String payloads,
  String cluster,
  String command,
) {
  final className = 'ZGMTR${cluster}Cluster${command}Params';
  final re = RegExp(
    '@interface $className : NSObject <NSCopying>(.*?)@end',
    dotAll: true,
  );
  final match = re.firstMatch(payloads);
  if (match == null) {
    return const [];
  }
  final fields = <_Field>[];
  final propRe = RegExp(
    r'@property \(nonatomic, copy\) ([A-Za-z0-9_* ]+?)\s+(_Nullable|_Nonnull)\s+([A-Za-z0-9]+)\b',
  );
  var tag = 0;
  for (final prop in propRe.allMatches(match.group(1)!)) {
    fields.add(
      _Field(
        tag: tag++,
        name: prop.group(3)!,
        type: _objcTypeToMatterType(prop.group(1)!),
        nullable: prop.group(2) == '_Nullable',
      ),
    );
  }
  return fields;
}

String _normalizeCluster(String cluster) {
  return _legacyClusterAliases[cluster] ?? cluster;
}

String _objcTypeToMatterType(String objcType) {
  if (objcType.contains('NSString')) {
    return 'string';
  }
  if (objcType.contains('NSData')) {
    return 'octetString';
  }
  if (objcType.contains('NSArray')) {
    return 'array';
  }
  if (objcType.contains('Struct') || objcType.contains('Cluster')) {
    return 'struct';
  }
  return objcType.contains('NSNumber') ? 'unknown' : 'unknown';
}

String _displayName(String name) {
  final words = name
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('Wi Fi', 'Wi-Fi')
      .replaceAll('OTA', 'OTA')
      .trim();
  return words.replaceAll("'", "\\'");
}

String _hexLiteral(int value, int width) {
  return '0x${value.toRadixString(16).toUpperCase().padLeft(width, '0')}';
}

class _Command {
  final String name;
  final List<_Field> fields;

  const _Command(this.name, this.fields);
}

class _Field {
  final int tag;
  final String name;
  final String type;
  final bool nullable;

  const _Field({
    required this.tag,
    required this.name,
    required this.type,
    required this.nullable,
  });
}
