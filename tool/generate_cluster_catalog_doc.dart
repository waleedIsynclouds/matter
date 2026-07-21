// Generates docs/CLUSTER_CATALOG.md — a full, human-readable dump of every
// cluster/attribute/command in lib/src/data_model/cluster_catalog_data.g.dart.
// Intended as a reference document (e.g. to convert to PDF for stakeholders).
//
// Run: dart run tool/generate_cluster_catalog_doc.dart

import 'dart:io';

import 'package:flutter_matter/src/data_model/cluster_catalog.dart';

String _hex(int value, {int width = 8}) =>
    '0x${value.toRadixString(16).toUpperCase().padLeft(width, '0')}';

String _typeLabel(MatterValueType type) {
  switch (type) {
    case MatterValueType.unknown:
      return 'unknown';
    case MatterValueType.uint:
      return 'unsigned integer';
    case MatterValueType.int:
      return 'signed integer';
    case MatterValueType.bool:
      return 'boolean';
    case MatterValueType.string:
      return 'string';
    case MatterValueType.octetString:
      return 'octet string';
    case MatterValueType.float:
      return 'float';
    case MatterValueType.doubleValue:
      return 'double';
    case MatterValueType.struct:
      return 'struct';
    case MatterValueType.array:
      return 'array';
    case MatterValueType.list:
      return 'list';
  }
}

void main() {
  final clusters = clusterCatalog.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  var totalAttributes = 0;
  var totalCommands = 0;
  for (final entry in clusters) {
    totalAttributes += entry.value.attributes.length;
    totalCommands += entry.value.commands.length;
  }

  final buffer = StringBuffer();
  buffer.writeln('# Matter Cluster Catalog');
  buffer.writeln();
  buffer.writeln(
    '_Generated from `lib/src/data_model/cluster_catalog_data.g.dart` by '
    '`tool/generate_cluster_catalog_doc.dart`. That data is itself generated '
    'from the ZGMatter framework headers by `tool/generate_cluster_catalog.dart`. '
    'Regenerate this document any time the catalog changes rather than editing it by hand._',
  );
  buffer.writeln();
  buffer.writeln(
    '**${clusters.length} clusters · $totalAttributes attributes · $totalCommands commands**',
  );
  buffer.writeln();
  buffer.writeln('## Contents');
  buffer.writeln();
  for (final entry in clusters) {
    final anchor = entry.value.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-');
    buffer.writeln(
      '- [${entry.value.name} (${_hex(entry.key)})](#$anchor-${entry.key.toRadixString(16)})',
    );
  }
  buffer.writeln();
  buffer.writeln('---');
  buffer.writeln();

  for (final entry in clusters) {
    final clusterId = entry.key;
    final cluster = entry.value;
    buffer.writeln('## ${cluster.name} (${_hex(clusterId)})');
    buffer.writeln();
    buffer.writeln(
      '${cluster.attributes.length} attributes, ${cluster.commands.length} commands.',
    );
    buffer.writeln();

    buffer.writeln('### Attributes');
    buffer.writeln();
    if (cluster.attributes.isEmpty) {
      buffer.writeln('_No attributes cataloged._');
    } else {
      buffer.writeln('| ID | Name | Type |');
      buffer.writeln('| --- | --- | --- |');
      final attrs = cluster.attributes.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final attr in attrs) {
        buffer.writeln(
          '| `${_hex(attr.key)}` | ${attr.value.name} | ${_typeLabel(attr.value.type)} |',
        );
      }
    }
    buffer.writeln();

    buffer.writeln('### Commands');
    buffer.writeln();
    if (cluster.commands.isEmpty) {
      buffer.writeln('_No commands cataloged._');
    } else {
      final cmds = cluster.commands.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final cmd in cmds) {
        buffer.writeln('**${cmd.value.name}** (`${_hex(cmd.key, width: 2)}`)');
        buffer.writeln();
        if (cmd.value.fields.isEmpty) {
          buffer.writeln('_No fields._');
        } else {
          buffer.writeln('| Tag | Field | Type | Nullable |');
          buffer.writeln('| --- | --- | --- | :---: |');
          for (final field in cmd.value.fields) {
            buffer.writeln(
              '| ${field.tag} | ${field.name} | ${_typeLabel(field.type)} | ${field.nullable ? 'yes' : 'no'} |',
            );
          }
        }
        buffer.writeln();
      }
    }
    buffer.writeln('---');
    buffer.writeln();
  }

  final output = File('docs/CLUSTER_CATALOG.md');
  output.createSync(recursive: true);
  output.writeAsStringSync(buffer.toString());
  // ignore: avoid_print
  print('Wrote ${output.path} (${clusters.length} clusters).');
}
