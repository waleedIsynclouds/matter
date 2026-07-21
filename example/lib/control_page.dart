import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_matter/flutter_matter.dart';
import 'package:flutter_matter_example/data.dart';

import 'uitls.dart';

class _ConnectedDeviceCallbackWarp extends ConnectedDeviceCallback {
  final Function(Object? context) onConnectedFun;
  final Function(Exception)? onConnectionFailureFun;

  _ConnectedDeviceCallbackWarp({
    required this.onConnectedFun,
    this.onConnectionFailureFun,
  });

  @override
  void onConnected(Object? context) {
    onConnectedFun(context);
  }

  @override
  void onError(Exception e) {
    onConnectionFailureFun?.call(e);
  }
}

class OpenCommissioningCallbackWarp extends OpenCommissioningCallback {
  final void Function(String manualPairingCode, String qrCode)? onSuccessFun;
  final void Function(int status)? onErrorFun;

  OpenCommissioningCallbackWarp({this.onSuccessFun, this.onErrorFun});

  @override
  void onError(int status, Object? connectContext) {
    onErrorFun?.call(status);
  }

  @override
  void onSuccess(
    Object? connectContext,
    String manualPairingCode,
    String qrCode,
  ) {
    onSuccessFun?.call(manualPairingCode, qrCode);
  }
}

enum _ControlTabKind { info, cluster, sharing, readWrite, ocw }

class _ControlTab {
  final _ControlTabKind kind;
  final int? clusterId;
  final String label;

  const _ControlTab(this.kind, this.label, {this.clusterId});
}

class ControlPage extends StatefulWidget {
  final Device device;
  const ControlPage({super.key, required this.device});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  Object? connectContext;
  bool connectting = false;
  ChipDeviceController? chipDeviceController;
  late List<int> supportedClusters;
  late List<_ControlTab> tabs;

  @override
  void initState() {
    super.initState();
    supportedClusters = widget.device.supportedClusters ?? const [];
    tabs = _buildTabs();
    tabController = TabController(length: tabs.length, vsync: this);
    createChipDeviceController().then((value) {
      chipDeviceController = value;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<_ControlTab> _buildTabs() {
    final clusterTabs = supportedClusters
        .where((id) => id != 0x0000001D)
        .map(
          (id) => _ControlTab(
            _ControlTabKind.cluster,
            matterClusterName(id),
            clusterId: id,
          ),
        )
        .toList();
    return [
      const _ControlTab(_ControlTabKind.info, 'Info'),
      ...clusterTabs,
      const _ControlTab(_ControlTabKind.sharing, 'Sharing'),
      const _ControlTab(_ControlTabKind.readWrite, 'Read/Write'),
      const _ControlTab(_ControlTabKind.ocw, 'OCW'),
    ];
  }

  void _rebuildTabsIfNeeded(List<int> clusters) {
    final next = clusters.toSet().toList()..sort();
    if (_sameIntList(next, supportedClusters)) {
      return;
    }
    final oldIndex = tabController.index;
    final oldLength = tabs.length;
    setState(() {
      supportedClusters = next;
      tabs = _buildTabs();
      tabController.dispose();
      tabController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: oldIndex.clamp(0, tabs.length - 1),
      );
    });
    if (oldLength != tabs.length) {
      updateDeviceSupportedClusters(widget.device.nodeId, next);
    }
  }

  bool _sameIntList(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> _discoverClusters() async {
    final controller = chipDeviceController;
    final context = connectContext;
    if (controller == null || context == null) {
      return;
    }
    try {
      final clusters = await DescriptorCluster(
        controller: controller,
        connContext: context,
        endpointId: 1,
        nodeId: widget.device.nodeId,
      ).readServerListAttribute();
      _rebuildTabsIfNeeded(clusters);
      await updateDeviceSupportedClusters(widget.device.nodeId, clusters);
    } catch (e) {
      showToast('Failed to discover clusters');
    }
  }

  void _changeConnectState() {
    if (chipDeviceController == null || connectting) {
      return;
    }
    connectting = true;
    if (connectContext == null) {
      chipDeviceController!.connectedDevice(
        widget.device.nodeId,
        _ConnectedDeviceCallbackWarp(
          onConnectionFailureFun: (_) {
            connectting = false;
          },
          onConnectedFun: (context) {
            setState(() {
              connectting = false;
              connectContext = context;
            });
            _discoverClusters();
          },
        ),
      );
    } else {
      setState(() {
        connectting = false;
        connectContext = null;
      });
    }
  }

  void _unPairDevice() {
    int endpointId = 0; // root endpoint
    int attributeId = 0x00000005;
    int clusterId = 0x0000003E;

    chipDeviceController!.read(
      widget.device.nodeId,
      connectContext: connectContext,
      ReportCallbackWarp(
        onReportFun: (nodeState) {
          final tlvData = nodeState
              .endpoints[endpointId]
              ?.clusters[clusterId]
              ?.attributes[attributeId]
              ?.tlv;
          if (tlvData == null) {
            showToast("delete failed");
            return;
          }
          final tlvReader = TlvReader(tlvData);
          final fabricIndex = tlvReader.getUByte(AnonymousTag.instance);

          // send remove command
          final tlvWriter = TlvWriter();
          tlvWriter.startStructure(AnonymousTag.instance);
          tlvWriter.putUnsigned(ContextSpecificTag(0), fabricIndex);
          tlvWriter.endStructure();
          chipDeviceController!.invoke(
            InvokeCallbackWarp(
              onResponseCB: (p0, p1) {
                showToast("delete success");
                deleteDevice(widget.device);
                Navigator.pop(context);
              },
              onErrorCB: (p1) {
                showToast("delete failed");
              },
            ),
            widget.device.nodeId,
            timedRequestTimeoutMs: 5000,
            connectContext: connectContext,
            InvokeElement.create(
              endpointId,
              clusterId,
              0x0A,
              tlvWriter.getEncoded(),
              null,
            ),
          );
        },
        onErrorFun: (_, _, _) {
          showToast("delete failed");
        },
      ),
      [
        ChipAttributePath(
          endpointId: ChipPathId.forId(endpointId),
          attributeId: ChipPathId.forId(attributeId),
          clusterId: ChipPathId.forId(clusterId),
        ),
      ],
      null,
      null,
      false,
      5000,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control'),
        actions: [
          TextButton(
            onPressed: () {
              _changeConnectState();
            },
            child: Text(connectContext == null ? "Connect" : "disConnect"),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: tabs.map((e) => Tab(text: e.label)).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _unPairDevice();
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabs.map((tab) {
          return Builder(
            builder: (_) {
              if (tab.kind == _ControlTabKind.info) {
                if (connectContext == null || chipDeviceController == null) {
                  return OfflineDeviceInfoPage(device: widget.device);
                }
                return DeviceInfoTabPage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                );
              }
              if (tab.kind == _ControlTabKind.cluster) {
                return ClusterDetailPage(
                  chipDeviceController: chipDeviceController,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                  endpointId: 1,
                  clusterId: tab.clusterId!,
                );
              }
              if (connectContext == null || chipDeviceController == null) {
                return Center(child: Text("Device not connected"));
              }
              if (tab.kind == _ControlTabKind.sharing) {
                return SharingTabPage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                );
              }
              if (tab.kind == _ControlTabKind.ocw) {
                return OCWTabPage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                );
              }
              if (tab.kind == _ControlTabKind.readWrite) {
                return Read_WritePage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                );
              }
              return const SizedBox.shrink();
            },
          );
        }).toList(),
      ),
    );
  }
}

class InvokeCallbackWarp implements InvokeCallback {
  final Function()? onDoneCB;
  final Function(Exception)? onErrorCB;
  final Function(InvokeElement, int)? onResponseCB;

  InvokeCallbackWarp({this.onDoneCB, this.onErrorCB, this.onResponseCB});

  @override
  void onDone() {
    onDoneCB?.call();
  }

  @override
  void onError(Exception e) {
    onErrorCB?.call(e);
  }

  @override
  void onResponse(InvokeElement invokeElement, int successCode) {
    onResponseCB?.call(invokeElement, successCode);
  }
}

/// On/Off Page
class OnOffPage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  const OnOffPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    this.controlContext,
  });

  @override
  State<OnOffPage> createState() => _OnOffPageState();
}

class _OnOffPageState extends State<OnOffPage> {
  Set<int> subscribedIds = {};
  String? onoffState;

  void _onoffControl(int commandId) {
    TlvWriter writer = TlvWriter();
    writer.startStructure(AnonymousTag.instance);
    writer.endStructure();
    final ele = InvokeElement.create(
      0x1,
      0x6,
      commandId,
      writer.getEncoded(),
      null,
    );
    widget.chipDeviceController.invoke(
      connectContext: widget.controlContext,
      InvokeCallbackWarp(
        onResponseCB: (p0, p1) {
          showToast("Send successfully");
        },
        onErrorCB: (p1) {
          showToast("Send failed");
        },
      ),
      widget.controlDevice.nodeId,
      ele,
    );
  }

  void _subscribe() {
    int endpointId = 1;
    int attributeId = 0x00000000;
    int clusterId = 0x00000006;
    widget.chipDeviceController.subscribe(
      connectContext: widget.controlContext,
      widget.controlDevice.nodeId,
      SubscriptionCallbackWarp(
        onSubscriptionEstablishedFun: (subscriptionId) {
          subscribedIds.add(subscriptionId);
        },
        onDoneFun: () {
          setState(() {
            onoffState = null;
          });
        },
        onReportFun: (nodeState) {
          final tlvData = nodeState
              .endpoints[endpointId]
              ?.clusters[clusterId]
              ?.attributes[attributeId]
              ?.tlv;
          setState(() {
            onoffState =
                "on: ${TlvReader(tlvData!).getBool(AnonymousTag.instance)}";
          });
        },
      ),
      [
        ChipAttributePath(
          endpointId: ChipPathId.forId(endpointId),
          attributeId: ChipPathId.forId(attributeId),
          clusterId: ChipPathId.forId(clusterId),
        ),
      ],
      null, // eventPaths
      null, // dataVersionFilters
      3, // minInterval
      8, // maxInterval
      true, // keepSubscriptions
      false, // isFabricFiltered
      6000, // imTimeoutMs
      0, // eventMin
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final element in subscribedIds) {
      widget.chipDeviceController.getFabricIndex().then((value) {
        if (value == null) {
          return;
        }
        widget.chipDeviceController.unSubscription(
          value,
          widget.controlDevice.nodeId,
          element,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: const Text('Off'),
          onTap: () {
            _onoffControl(0);
          },
        ),
        ListTile(
          title: const Text('On'),
          onTap: () {
            _onoffControl(1);
          },
        ),
        ListTile(
          title: const Text('Toggle'),
          onTap: () {
            _onoffControl(2);
          },
        ),
        ListTile(
          title: const Text('Subscribe on/off state'),
          subtitle: onoffState == null ? null : Text(onoffState!),
          onTap: () {
            _subscribe();
          },
        ),
      ],
    );
  }
}

class OfflineDeviceInfoPage extends StatelessWidget {
  final Device device;

  const OfflineDeviceInfoPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Device', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Node ID: ${device.nodeId}'),
        if (device.vendorName != null) Text('Vendor: ${device.vendorName}'),
        if (device.productName != null) Text('Product: ${device.productName}'),
        if (device.softwareVersion != null)
          Text('Software: ${device.softwareVersion}'),
        if (device.vendorId != null)
          Text('Vendor ID: ${matterHex(device.vendorId!, width: 8)}'),
        if (device.productId != null)
          Text('Product ID: ${matterHex(device.productId!, width: 8)}'),
        if (device.discriminator != null)
          Text('Discriminator: ${device.discriminator}'),
        if (device.pairedAt != null)
          Text('Paired: ${device.pairedAt!.toLocal()}'),
        if (device.lastSeenAt != null)
          Text('Last seen: ${device.lastSeenAt!.toLocal()}'),
        const Divider(height: 24),
        const Text('Device not connected. Showing cached information.'),
      ],
    );
  }
}

class ClusterDetailPage extends StatefulWidget {
  final ChipDeviceController? chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  final int endpointId;
  final int clusterId;

  const ClusterDetailPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    required this.controlContext,
    required this.endpointId,
    required this.clusterId,
  });

  @override
  State<ClusterDetailPage> createState() => _ClusterDetailPageState();
}

class _ClusterDetailPageState extends State<ClusterDetailPage> {
  bool _loading = false;
  String? _error;
  Map<int, DecodedAttribute> _attributes = {};
  late Map<String, String> _lastKnownState;

  @override
  void initState() {
    super.initState();
    _lastKnownState = Map<String, String>.from(
      widget.controlDevice.lastKnownState,
    );
    if (_isConnected) {
      _loadCluster();
    }
  }

  @override
  void didUpdateWidget(covariant ClusterDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controlContext == null && _isConnected) {
      _loadCluster();
    }
  }

  bool get _isConnected =>
      widget.chipDeviceController != null && widget.controlContext != null;

  String _cacheKey(int attributeId) {
    return '${matterHex(widget.clusterId, width: 8)}:${matterHex(attributeId, width: 8)}';
  }

  Future<void> _loadCluster() async {
    final controller = widget.chipDeviceController;
    if (controller == null || widget.controlContext == null || _loading) {
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final snapshot = await readCluster(
        controller,
        nodeId: widget.controlDevice.nodeId,
        endpointId: widget.endpointId,
        clusterId: widget.clusterId,
        connectContext: widget.controlContext,
      );
      final cacheUpdates = <String, String>{};
      snapshot.attributes.forEach((attributeId, attribute) {
        cacheUpdates[_cacheKey(attributeId)] = attribute.value;
      });
      if (!mounted) {
        return;
      }
      setState(() {
        _attributes = snapshot.attributes;
        _lastKnownState = {..._lastKnownState, ...cacheUpdates};
        _loading = false;
      });
      unawaited(
        updateDeviceLastKnownState(widget.controlDevice.nodeId, cacheUpdates),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final clusterInfo = clusterInfoForId(widget.clusterId);
    final commands = clusterInfo?.commands.entries.toList() ?? const [];
    final cachedPrefix = '${matterHex(widget.clusterId, width: 8)}:';
    final cachedEntries = _lastKnownState.entries
        .where((entry) => entry.key.startsWith(cachedPrefix))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${matterClusterName(widget.clusterId)} ${matterHex(widget.clusterId, width: 8)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isConnected && !_loading ? _loadCluster : null,
            ),
          ],
        ),
        Text('Endpoint ${widget.endpointId}'),
        if (!_isConnected)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text('Device not connected. Showing last-known values.'),
          ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(),
          ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        const Divider(height: 24),
        Text('Attributes', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (_attributes.isEmpty && cachedEntries.isEmpty)
          const Text('No attributes read yet'),
        for (final entry
            in _attributes.entries.toList()
              ..sort((a, b) => a.key.compareTo(b.key)))
          _AttributeRow(
            name: matterAttributeName(widget.clusterId, entry.key),
            id: entry.key,
            value: entry.value.value,
            isLastKnown: false,
          ),
        if (_attributes.isEmpty)
          for (final entry in cachedEntries)
            _AttributeRow(
              name: matterAttributeName(
                widget.clusterId,
                _cachedAttributeId(entry.key),
              ),
              id: _cachedAttributeId(entry.key),
              value: entry.value,
              isLastKnown: true,
            ),
        const Divider(height: 24),
        Text('Commands', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (commands.isEmpty) const Text('No known commands in catalog'),
        for (final command in commands)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(command.value.name),
            subtitle: Text(
              command.value.fields.isEmpty
                  ? 'No fields'
                  : command.value.fields.map(_fieldLabel).join(', '),
            ),
            trailing: Text(matterHex(command.key, width: 8)),
          ),
      ],
    );
  }

  String _fieldLabel(CommandFieldInfo field) {
    final nullable = field.nullable ? '?' : '';
    return '${field.name}: ${field.type.name}$nullable';
  }

  int _cachedAttributeId(String key) {
    final id = key.split(':').last;
    return int.tryParse(id.replaceFirst('0x', ''), radix: 16) ?? 0;
  }
}

class _AttributeRow extends StatelessWidget {
  final String name;
  final int id;
  final String value;
  final bool isLastKnown;

  const _AttributeRow({
    required this.name,
    required this.id,
    required this.value,
    required this.isLastKnown,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text('$name\n${matterHex(id, width: 8)}'),
          ),
          Expanded(child: Text(isLastKnown ? 'last known: $value' : value)),
        ],
      ),
    );
  }
}

/// OCW Page
class OCWTabPage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;

  const OCWTabPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    this.controlContext,
  });

  @override
  State<OCWTabPage> createState() => _OCWTabPageState();
}

class _OCWTabPageState extends State<OCWTabPage> {
  String? _manualPairingCode;
  String? _qrCode;

  void _openWindow() {
    final tlvWriter = TlvWriter();
    tlvWriter.startStructure(AnonymousTag.instance);
    tlvWriter.endStructure();
    final invokeElement = InvokeElement.create(
      0,
      0x0000003C,
      0x00000002,
      tlvWriter.getEncoded(),
      null,
    );
    widget.chipDeviceController.invoke(
      InvokeCallbackWarp(
        onDoneCB: () {
          widget.chipDeviceController
              .openPairingWindowWithPIN(
                widget.controlContext!,
                180,
                3850,
                20202021,
                OpenCommissioningCallbackWarp(
                  onSuccessFun: (manualPairingCode, qrCode) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _manualPairingCode = manualPairingCode;
                      _qrCode = qrCode;
                    });
                  },
                ),
              )
              .then((value) {
                showToast("Success, code: $value");
              })
              .catchError((e, s) {
                showToast("failed");
              });
        },
        onResponseCB: (invokeElement, successCode) {},
        onErrorCB: (_) {},
      ),
      widget.controlDevice.nodeId,
      invokeElement,
      connectContext: widget.controlContext,
      timedRequestTimeoutMs: 2000,
      imTimeoutMs: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        ElevatedButton(
          onPressed: _openWindow,
          child: const Text('openPairingWindow'),
        ),
        if (_manualPairingCode != null) ...[
          const SizedBox(height: 16),
          Text(
            'Manual pairing code',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SelectableText(_manualPairingCode!),
        ],
        if (_qrCode != null) ...[
          const SizedBox(height: 16),
          Text(
            'QR code payload',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SelectableText(_qrCode!),
        ],
      ],
    );
  }
}

class SharingTabPage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;

  const SharingTabPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    required this.controlContext,
  });

  @override
  State<SharingTabPage> createState() => _SharingTabPageState();
}

class _SharingTabPageState extends State<SharingTabPage> {
  bool _loading = false;
  String? _manualPairingCode;
  String? _qrCode;
  List<_FabricInfo> _fabrics = const [];
  int? _currentFabricIndex;

  @override
  void initState() {
    super.initState();
    _loadFabrics();
  }

  void _openWindow() {
    final tlvWriter = TlvWriter();
    tlvWriter.startStructure(AnonymousTag.instance);
    tlvWriter.endStructure();
    final invokeElement = InvokeElement.create(
      0,
      0x0000003C,
      0x00000002,
      tlvWriter.getEncoded(),
      null,
    );
    widget.chipDeviceController.invoke(
      InvokeCallbackWarp(
        onDoneCB: () {
          widget.chipDeviceController.openPairingWindowWithPIN(
            widget.controlContext!,
            180,
            3850,
            20202021,
            OpenCommissioningCallbackWarp(
              onSuccessFun: (manualPairingCode, qrCode) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  _manualPairingCode = manualPairingCode;
                  _qrCode = qrCode;
                });
              },
            ),
          );
        },
        onErrorCB: (_) => showToast('failed'),
      ),
      widget.controlDevice.nodeId,
      invokeElement,
      connectContext: widget.controlContext,
      timedRequestTimeoutMs: 2000,
    );
  }

  Future<void> _loadFabrics() async {
    setState(() {
      _loading = true;
    });
    try {
      final snapshot = await readCluster(
        widget.chipDeviceController,
        nodeId: widget.controlDevice.nodeId,
        endpointId: 0,
        clusterId: 0x0000003E,
        connectContext: widget.controlContext,
      );
      final fabrics = _parseFabrics(snapshot.attributes[0x00000001]?.rawTlv);
      final currentFabricIndex = _parseUInt(
        snapshot.attributes[0x00000005]?.rawTlv,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _fabrics = fabrics;
        _currentFabricIndex = currentFabricIndex;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
      });
      showToast('Failed to read fabrics');
    }
  }

  void _revokeFabric(int fabricIndex) {
    final tlvWriter = TlvWriter();
    tlvWriter.startStructure(AnonymousTag.instance);
    tlvWriter.putUnsigned(ContextSpecificTag(0), fabricIndex);
    tlvWriter.endStructure();
    widget.chipDeviceController.invoke(
      InvokeCallbackWarp(
        onResponseCB: (invokeElement, successCode) {
          showToast('Fabric revoked');
          _loadFabrics();
        },
        onErrorCB: (_) => showToast('Revoke failed'),
      ),
      widget.controlDevice.nodeId,
      InvokeElement.create(
        0,
        0x0000003E,
        0x0000000A,
        tlvWriter.getEncoded(),
        null,
      ),
      connectContext: widget.controlContext,
      timedRequestTimeoutMs: 5000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Sharing',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loading ? null : _loadFabrics,
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _openWindow,
          child: const Text('Open commissioning window'),
        ),
        if (_manualPairingCode != null) ...[
          const SizedBox(height: 12),
          Text(
            'Manual pairing code',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SelectableText(_manualPairingCode!),
        ],
        if (_qrCode != null) ...[
          const SizedBox(height: 12),
          Text(
            'QR code payload',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          SelectableText(_qrCode!),
        ],
        const Divider(height: 24),
        Text('Fabrics', style: Theme.of(context).textTheme.titleSmall),
        if (_loading) const LinearProgressIndicator(),
        if (!_loading && _fabrics.isEmpty) const Text('No fabrics read yet'),
        for (final fabric in _fabrics)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              fabric.label?.isNotEmpty == true
                  ? fabric.label!
                  : 'Fabric ${fabric.fabricIndex ?? '-'}',
            ),
            subtitle: Text(
              'Vendor ID: ${fabric.vendorId ?? '-'}  Fabric ID: ${fabric.fabricId ?? '-'}  Node ID: ${fabric.nodeId ?? '-'}',
            ),
            trailing: fabric.fabricIndex == _currentFabricIndex
                ? const Text('Current')
                : TextButton(
                    onPressed: fabric.fabricIndex == null
                        ? null
                        : () => _revokeFabric(fabric.fabricIndex!),
                    child: const Text('Revoke'),
                  ),
          ),
      ],
    );
  }

  int? _parseUInt(Uint8List? tlv) {
    if (tlv == null) {
      return null;
    }
    try {
      final value = TlvReader(tlv).nextElement().value;
      return value is UnsignedIntValue ? value.value : null;
    } catch (_) {
      return null;
    }
  }

  List<_FabricInfo> _parseFabrics(Uint8List? tlv) {
    if (tlv == null) {
      return const [];
    }
    try {
      final reader = TlvReader(tlv);
      final fabrics = <_FabricInfo>[];
      reader.enterArray(AnonymousTag.instance);
      while (!reader.isEndOfContainer()) {
        reader.enterStructure(AnonymousTag.instance);
        int? vendorId;
        int? fabricId;
        int? nodeId;
        String? label;
        int? fabricIndex;
        while (!reader.isEndOfContainer()) {
          final element = reader.nextElement();
          final tag = element.tag is ContextSpecificTag
              ? (element.tag as ContextSpecificTag).tagNumber
              : null;
          final value = element.value;
          if (value is UnsignedIntValue) {
            if (tag == 2) {
              vendorId = value.value;
            } else if (tag == 3) {
              fabricId = value.value;
            } else if (tag == 4) {
              nodeId = value.value;
            } else if (tag == 254) {
              fabricIndex = value.value;
            }
          } else if (value is Utf8StringValue && tag == 5) {
            label = value.value;
          } else if (value is StructureValue ||
              value is ArrayValue ||
              value is ListValue) {
            reader.exitContainer();
          }
        }
        reader.exitContainer();
        fabrics.add(
          _FabricInfo(
            vendorId: vendorId,
            fabricId: fabricId,
            nodeId: nodeId,
            label: label,
            fabricIndex: fabricIndex,
          ),
        );
      }
      reader.exitContainer();
      return fabrics;
    } catch (_) {
      return const [];
    }
  }
}

class _FabricInfo {
  final int? vendorId;
  final int? fabricId;
  final int? nodeId;
  final String? label;
  final int? fabricIndex;

  const _FabricInfo({
    this.vendorId,
    this.fabricId,
    this.nodeId,
    this.label,
    this.fabricIndex,
  });
}

/// Read/Write Page
class Read_WritePage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  const Read_WritePage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    this.controlContext,
  });

  @override
  State<Read_WritePage> createState() => _Read_WritePageState();
}

class _Read_WritePageState extends State<Read_WritePage> {
  String _readValue = '';
  TextEditingController editingController = TextEditingController();

  void _writeNodeLabel(String writeValue) {
    int endpointId = 0; // root endpoint
    int clusterId = 0x00000028;
    int attributeId = 0x00000005;
    widget.chipDeviceController.write(
      widget.controlDevice.nodeId,
      WriteAttributesCallbackWarp(
        onResponseFun: (_, __) {
          showToast("Write Success");
        },
      ),
      [
        AttributeWriteRequest(
          endpointId: ChipPathId.forId(endpointId),
          clusterId: ChipPathId.forId(clusterId),
          attributeId: ChipPathId.forId(attributeId),
          dataVersion: 0,
          tlv: TlvWriter()
              .putString(AnonymousTag.instance, writeValue)
              .getEncoded(),
        ),
      ],
      5000,
      2000,
      connectContext: widget.controlContext,
    );
  }

  void _readNodeLabel() {
    int endpointId = 0; // root endpoint
    int clusterId = 0x00000028;
    int attributeId = 0x00000005;
    widget.chipDeviceController.read(
      widget.controlDevice.nodeId,
      connectContext: widget.controlContext,
      new ReportCallbackWarp(
        onReportFun: (nodeState) {
          final tlvData = nodeState
              .endpoints[endpointId]
              ?.clusters[clusterId]
              ?.attributes[attributeId]
              ?.tlv;
          if (tlvData == null) {
            showToast("read failed");
            return;
          }
          TlvReader reader = TlvReader(tlvData);
          setState(() {
            this._readValue = reader
                .getString(AnonymousTag.instance)
                .toString();
          });
        },
        onErrorFun: (_, __, ___) {
          showToast("read failed");
        },
      ),
      [
        ChipAttributePath(
          endpointId: ChipPathId.forId(endpointId),
          attributeId: ChipPathId.forId(attributeId),
          clusterId: ChipPathId.forId(clusterId),
        ),
      ],
      null,
      null,
      false,
      5000,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Text("NodeLabel: "),
              SizedBox(width: 5),
              Expanded(
                child: TextField(
                  controller: editingController,
                  decoration: InputDecoration(hintText: "Enter a value"),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final writeValue = editingController.text;
              if (writeValue.isEmpty) {
                showToast("Please enter a value");
                return;
              }
              _writeNodeLabel(writeValue);
            },
            child: Text("Write NodeLabel"),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              _readNodeLabel();
            },
            child: Text("Read NodeLabel"),
          ),
          SizedBox(height: 12),
          Text("Device NodeLabel Value: $_readValue"),
        ],
      ),
    );
  }
}

/// Info Page: static commissioning metadata + a one-shot read of the Basic
/// Information cluster + an opt-in wildcard subscription that streams every
/// attribute report and event the device sends.
class DeviceInfoTabPage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;

  const DeviceInfoTabPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    this.controlContext,
  });

  @override
  State<DeviceInfoTabPage> createState() => _DeviceInfoTabPageState();
}

class _DeviceInfoTabPageState extends State<DeviceInfoTabPage> {
  static const int _basicInfoClusterId = 0x00000028;

  static const Map<int, String> _basicInfoLabels = {
    1: 'Vendor name',
    2: 'Vendor ID',
    3: 'Product name',
    4: 'Product ID',
    5: 'Node label',
    6: 'Location',
    7: 'Hardware version',
    8: 'Hardware version string',
    9: 'Software version',
    10: 'Software version string',
    11: 'Manufacturing date',
    12: 'Part number',
    13: 'Product URL',
    14: 'Product label',
    15: 'Serial number',
    18: 'Unique ID',
  };

  bool _loadingInfo = false;
  Map<int, String> _basicInfo = {};
  bool _liveFeedOn = false;
  final Set<int> _subscriptionIds = {};
  final List<String> _eventLog = [];

  @override
  void initState() {
    super.initState();
    _loadBasicInfo();
  }

  @override
  void dispose() {
    for (final id in _subscriptionIds) {
      widget.chipDeviceController.getFabricIndex().then((value) {
        if (value == null) {
          return;
        }
        widget.chipDeviceController.unSubscription(
          value,
          widget.controlDevice.nodeId,
          id,
        );
      });
    }
    super.dispose();
  }

  String _hex(Uint8List? bytes) => bytes == null
      ? ''
      : bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

  String _decodeAttribute(int attributeId, AttributeState state) {
    final tlv = state.tlv;
    if (tlv == null) {
      return state.json ?? '';
    }
    try {
      switch (attributeId) {
        case 2:
        case 4:
        case 7:
          return TlvReader(tlv).getUShort(AnonymousTag.instance).toString();
        case 9:
          return TlvReader(tlv).getUInt(AnonymousTag.instance).toString();
        default:
          return TlvReader(tlv).getString(AnonymousTag.instance).toString();
      }
    } catch (_) {
      return _hex(tlv);
    }
  }

  void _loadBasicInfo() {
    setState(() {
      _loadingInfo = true;
    });
    final attributePath = ChipAttributePath(
      endpointId: ChipPathId.forId(0),
      clusterId: ChipPathId.forId(_basicInfoClusterId),
      attributeId: ChipPathId.forWildcard(),
    );
    widget.chipDeviceController.read(
      widget.controlDevice.nodeId,
      ReportCallbackWarp(
        onReportFun: (nodeState) {
          final attributes =
              nodeState
                  .endpoints[0]
                  ?.clusters[_basicInfoClusterId]
                  ?.attributes ??
              {};
          final decoded = <int, String>{};
          attributes.forEach((id, state) {
            decoded[id] = _decodeAttribute(id, state);
          });
          if (!mounted) {
            return;
          }
          setState(() {
            _basicInfo = decoded;
            _loadingInfo = false;
          });
          updateDeviceInfo(
            widget.controlDevice.nodeId,
            vendorName: decoded[1],
            productName: decoded[3],
            softwareVersion: decoded[10] ?? decoded[9],
          );
        },
        onErrorFun: (_, __, ___) {
          if (!mounted) {
            return;
          }
          setState(() {
            _loadingInfo = false;
          });
          showToast('Failed to read device info');
        },
      ),
      [attributePath],
      null,
      null,
      false,
      5000,
      0,
      connectContext: widget.controlContext,
    );
  }

  void _toggleLiveFeed() {
    if (_liveFeedOn) {
      setState(() {
        _liveFeedOn = false;
      });
      return;
    }
    setState(() {
      _liveFeedOn = true;
    });
    widget.chipDeviceController.subscribe(
      widget.controlDevice.nodeId,
      SubscriptionCallbackWarp(
        onSubscriptionEstablishedFun: (id) {
          _subscriptionIds.add(id);
        },
        onReportFun: (nodeState) {
          final lines = <String>[];
          final ts = DateTime.now()
              .toIso8601String()
              .split('T')
              .last
              .split('.')
              .first;
          nodeState.endpoints.forEach((epId, endpoint) {
            endpoint.clusters.forEach((clusterId, cluster) {
              cluster.attributes.forEach((attrId, attr) {
                lines.add(
                  '[$ts] attr ep:$epId cluster:0x${clusterId.toRadixString(16)} attr:0x${attrId.toRadixString(16)} = ${_decodeAttribute(attrId, attr)}',
                );
              });
              cluster.events.forEach((eventId, events) {
                for (final e in events) {
                  lines.add(
                    '[$ts] event ep:$epId cluster:0x${clusterId.toRadixString(16)} event:0x${eventId.toRadixString(16)} #${e.eventNumber} = ${_hex(e.tlv)}',
                  );
                }
              });
            });
          });
          if (lines.isEmpty || !mounted) {
            return;
          }
          setState(() {
            _eventLog.insertAll(0, lines);
            if (_eventLog.length > 200) {
              _eventLog.removeRange(200, _eventLog.length);
            }
          });
        },
      ),
      [
        ChipAttributePath(
          endpointId: ChipPathId.forWildcard(),
          clusterId: ChipPathId.forWildcard(),
          attributeId: ChipPathId.forWildcard(),
        ),
      ],
      [
        ChipEventPath(
          endpointId: ChipPathId.forWildcard(),
          clusterId: ChipPathId.forWildcard(),
          eventId: ChipPathId.forWildcard(),
          isUrgent: false,
        ),
      ],
      null,
      1,
      30,
      true,
      false,
      10000,
      0,
      connectContext: widget.controlContext,
    );
  }

  @override
  Widget build(BuildContext context) {
    final device = widget.controlDevice;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Device', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Text('Node ID: ${device.nodeId}'),
        if (device.vendorId != null)
          Text('Vendor ID: 0x${device.vendorId!.toRadixString(16)}'),
        if (device.productId != null)
          Text('Product ID: 0x${device.productId!.toRadixString(16)}'),
        if (device.discriminator != null)
          Text('Discriminator: ${device.discriminator}'),
        if (device.pairedAt != null)
          Text('Paired: ${device.pairedAt!.toLocal()}'),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Basic Information cluster',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadingInfo ? null : _loadBasicInfo,
            ),
          ],
        ),
        if (_loadingInfo) const LinearProgressIndicator(),
        if (!_loadingInfo && _basicInfo.isEmpty) const Text('No data read yet'),
        for (final entry in _basicInfo.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    _basicInfoLabels[entry.key] ??
                        'Attribute 0x${entry.key.toRadixString(16)}',
                  ),
                ),
                Expanded(child: Text(entry.value)),
              ],
            ),
          ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Live events & attribute reports',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton(
              onPressed: _toggleLiveFeed,
              child: Text(_liveFeedOn ? 'Stop' : 'Start'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_eventLog.isEmpty) const Text('No events received yet'),
        for (final line in _eventLog)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              line,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
      ],
    );
  }
}
