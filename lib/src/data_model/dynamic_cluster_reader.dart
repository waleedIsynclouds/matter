import 'dart:async';
import 'dart:typed_data';

import '../controller.dart';
import '../model/chip_attribute_path.dart';
import '../model/chip_path_id.dart';
import '../tlv/tag.dart';
import '../tlv/tlv_reader.dart';
import '../tlv/values.dart';
import 'cluster_catalog.dart';

class ClusterSnapshot {
  final int endpointId;
  final int clusterId;
  final ClusterInfo? info;
  final Map<int, DecodedAttribute> attributes;

  const ClusterSnapshot({
    required this.endpointId,
    required this.clusterId,
    required this.info,
    required this.attributes,
  });
}

class DecodedAttribute {
  final int id;
  final AttributeInfo? info;
  final String value;
  final Uint8List? rawTlv;

  const DecodedAttribute({
    required this.id,
    required this.info,
    required this.value,
    this.rawTlv,
  });
}

Future<ClusterSnapshot> readCluster(
  ChipDeviceController controller, {
  required int nodeId,
  required int endpointId,
  required int clusterId,
  Object? connectContext,
  int imTimeoutMs = 5000,
}) {
  final completer = Completer<ClusterSnapshot>();
  final attributePath = ChipAttributePath(
    endpointId: ChipPathId.forId(endpointId),
    clusterId: ChipPathId.forId(clusterId),
    attributeId: ChipPathId.forWildcard(),
  );

  controller.read(
    nodeId,
    ReportCallbackWarp(
      onReportFun: (nodeState) {
        if (completer.isCompleted) {
          return;
        }
        final cluster = nodeState.endpoints[endpointId]?.clusters[clusterId];
        final info = clusterInfoForId(clusterId);
        final decoded = <int, DecodedAttribute>{};
        cluster?.attributes.forEach((attributeId, state) {
          final attributeInfo = info?.attributes[attributeId];
          decoded[attributeId] = DecodedAttribute(
            id: attributeId,
            info: attributeInfo,
            value: decodeMatterTlv(state.tlv, fallbackJson: state.json),
            rawTlv: state.tlv,
          );
        });
        completer.complete(
          ClusterSnapshot(
            endpointId: endpointId,
            clusterId: clusterId,
            info: info,
            attributes: decoded,
          ),
        );
      },
      onErrorFun: (_, _, e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
      onDoneFun: () {
        if (!completer.isCompleted) {
          completer.complete(
            ClusterSnapshot(
              endpointId: endpointId,
              clusterId: clusterId,
              info: clusterInfoForId(clusterId),
              attributes: const {},
            ),
          );
        }
      },
    ),
    [attributePath],
    null,
    null,
    false,
    imTimeoutMs,
    0,
    connectContext: connectContext,
  );
  return completer.future;
}

String decodeMatterTlv(Uint8List? tlv, {String? fallbackJson}) {
  if (tlv == null) {
    return fallbackJson ?? '';
  }
  try {
    final reader = TlvReader(tlv);
    final value = _decodeElement(reader);
    if (!reader.isEndOfTlv()) {
      final values = <String>[value];
      while (!reader.isEndOfTlv()) {
        values.add(_decodeElement(reader));
      }
      return values.join(', ');
    }
    return value;
  } catch (_) {
    return fallbackJson ?? _hex(tlv);
  }
}

String _decodeElement(TlvReader reader) {
  final element = reader.nextElement();
  final value = element.value;
  if (value is IntValue) {
    return value.value.toString();
  }
  if (value is UnsignedIntValue) {
    return value.value.toString();
  }
  if (value is BooleanValue) {
    return value.value.toString();
  }
  if (value is Utf8StringValue) {
    return value.value;
  }
  if (value is ByteStringValue) {
    return _hex(value.value);
  }
  if (value is FloatValue) {
    return value.value.toString();
  }
  if (value is DoubleValue) {
    return value.value.toString();
  }
  if (value is NullValue) {
    return 'null';
  }
  if (value is StructureValue) {
    final fields = <String>[];
    while (!reader.isEndOfContainer()) {
      final nested = reader.peekElement();
      fields.add('${_tagLabel(nested.tag)}: ${_decodeElement(reader)}');
    }
    reader.exitContainer();
    return '{${fields.join(', ')}}';
  }
  if (value is ArrayValue || value is ListValue) {
    final items = <String>[];
    while (!reader.isEndOfContainer()) {
      items.add(_decodeElement(reader));
    }
    reader.exitContainer();
    return '[${items.join(', ')}]';
  }
  if (value is EndOfContainerValue) {
    return '';
  }
  return value.toString();
}

String _tagLabel(Tag tag) {
  if (tag is ContextSpecificTag) {
    return tag.tagNumber.toString();
  }
  return tag.toString();
}

String _hex(Uint8List bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
