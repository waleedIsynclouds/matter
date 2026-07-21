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

enum _ControlTabKind { info, ocw, device, advanced }

class _ControlTab {
  final _ControlTabKind kind;
  final String label;

  const _ControlTab(this.kind, this.label);
}

class ControlPage extends StatefulWidget {
  final Device device;
  const ControlPage({super.key, required this.device});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController;
  Object? connectContext;
  bool connectting = false;
  ChipDeviceController? chipDeviceController;
  late List<int> supportedClusters;
  final List<_ControlTab> tabs = const [
    _ControlTab(_ControlTabKind.info, 'Info'),
    _ControlTab(_ControlTabKind.ocw, 'OCW'),
    _ControlTab(_ControlTabKind.device, 'Device'),
    _ControlTab(_ControlTabKind.advanced, 'Advanced'),
  ];

  @override
  void initState() {
    super.initState();
    supportedClusters = widget.device.supportedClusters ?? const [];
    tabController = TabController(length: tabs.length, vsync: this);
    _initController();
  }

  Future<void> _initController() async {
    try {
      final controller = await createChipDeviceController();
      if (!mounted) {
        return;
      }
      setState(() {
        chipDeviceController = controller;
      });
      // Connect immediately so the user lands on a fully populated page
      // instead of having to press Connect manually.
      _changeConnectState();
    } catch (_) {
      if (!mounted) {
        return;
      }
      showToast('Failed to create Matter controller');
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _updateSupportedClusters(List<int> clusters) {
    final next = clusters.toSet().toList()..sort();
    if (_sameIntList(next, supportedClusters)) {
      return;
    }
    setState(() {
      supportedClusters = next;
    });
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
      _updateSupportedClusters(clusters);
      await updateDeviceSupportedClusters(widget.device.nodeId, clusters);
    } catch (e) {
      showToast('Failed to discover clusters');
    }
  }

  void _changeConnectState() {
    if (chipDeviceController == null || connectting) {
      return;
    }
    setState(() {
      connectting = true;
    });
    if (connectContext == null) {
      chipDeviceController!.connectedDevice(
        widget.device.nodeId,
        _ConnectedDeviceCallbackWarp(
          onConnectionFailureFun: (_) {
            if (!mounted) {
              return;
            }
            setState(() {
              connectting = false;
            });
            showToast('Failed to connect to device');
          },
          onConnectedFun: (context) {
            setState(() {
              connectting = false;
              connectContext = context;
            });
            showToast('Connected');
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
    final controller = chipDeviceController;
    final currentContext = connectContext;
    if (controller == null || currentContext == null) {
      showToast("Device not connected");
      return;
    }
    int endpointId = 0; // root endpoint
    int attributeId = 0x00000005;
    int clusterId = 0x0000003E;

    controller.read(
      widget.device.nodeId,
      connectContext: currentContext,
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
          controller.invoke(
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
            connectContext: currentContext,
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

  void _confirmUnpairDevice() {
    Navigator.pop(context); // close the drawer first
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove device'),
        content: const Text(
          'This will unpair the device from this controller. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _unPairDevice();
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final isConnected = chipDeviceController != null && connectContext != null;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.device.productName ??
                        widget.device.vendorName ??
                        'Device',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('Node ID: ${widget.device.nodeId}'),
                  const SizedBox(height: 4),
                  Text(isConnected ? 'Connected' : 'Not connected'),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                connectContext == null ? Icons.link : Icons.link_off,
              ),
              title: Text(connectContext == null ? 'Connect' : 'Disconnect'),
              onTap: () {
                Navigator.pop(context);
                _changeConnectState();
              },
            ),
            ListTile(
              enabled: isConnected,
              leading: const Icon(Icons.qr_code),
              title: const Text('Share this device'),
              subtitle: const Text('Invite another controller'),
              onTap: !isConnected
                  ? null
                  : () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Sharing')),
                            body: SharingTabPage(
                              chipDeviceController: chipDeviceController!,
                              controlDevice: widget.device,
                              controlContext: connectContext,
                            ),
                          ),
                        ),
                      );
                    },
            ),
            ListTile(
              enabled: isConnected,
              leading: const Icon(Icons.edit_note),
              title: const Text('Manual read/write'),
              subtitle: const Text('Send a custom read, write, or command'),
              onTap: !isConnected
                  ? null
                  : () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(
                              title: const Text('Manual read/write'),
                            ),
                            body: Read_WritePage(
                              chipDeviceController: chipDeviceController!,
                              controlDevice: widget.device,
                              controlContext: connectContext,
                            ),
                          ),
                        ),
                      );
                    },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Remove device',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _confirmUnpairDevice,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildDrawer(),
      appBar: AppBar(
        title: Text(
          widget.device.productName ?? widget.device.vendorName ?? 'Control',
        ),
        actions: [
          TextButton(
            onPressed: connectting ? null : _changeConnectState,
            child: connectting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(connectContext == null ? "Connect" : "Disconnect"),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs.map((e) => Tab(text: e.label)).toList(),
        ),
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
              if (tab.kind == _ControlTabKind.ocw) {
                if (connectContext == null || chipDeviceController == null) {
                  return const Center(child: Text("Device not connected"));
                }
                return OCWTabPage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                );
              }
              if (tab.kind == _ControlTabKind.advanced) {
                return AdvancedDevicePage(
                  chipDeviceController: chipDeviceController,
                  controlDevice: widget.device,
                  controlContext: connectContext,
                  supportedClusters: supportedClusters,
                );
              }
              return DeviceOverviewPage(
                chipDeviceController: chipDeviceController,
                controlDevice: widget.device,
                controlContext: connectContext,
                supportedClusters: supportedClusters,
              );
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

/// Device tab: quick controls, available commands the user can invoke, and
/// a live status/events feed. Full cluster/attribute browsing lives in the
/// Advanced tab instead.
class DeviceOverviewPage extends StatelessWidget {
  final ChipDeviceController? chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  final List<int> supportedClusters;

  const DeviceOverviewPage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    required this.controlContext,
    required this.supportedClusters,
  });

  static const int _descriptorClusterId = 0x0000001D;
  static const int _onOffClusterId = 0x00000006;

  bool get _isConnected =>
      chipDeviceController != null && controlContext != null;

  bool get _clusterDiscoveryPending => supportedClusters.isEmpty;

  bool get _supportsOnOff =>
      _clusterDiscoveryPending || supportedClusters.contains(_onOffClusterId);

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Device', style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 8),
          Text('Connect to the device to view its commands and features.'),
        ],
      );
    }

    final clusters =
        supportedClusters
            .where((id) => id != _descriptorClusterId)
            .toSet()
            .toList()
          ..sort();

    final commandEntries = <_CommandEntry>[];
    for (final clusterId in clusters) {
      final info = clusterInfoForId(clusterId);
      if (info == null) {
        continue;
      }
      info.commands.forEach((commandId, command) {
        commandEntries.add(
          _CommandEntry(
            clusterId: clusterId,
            clusterName: info.name,
            commandId: commandId,
            command: command,
          ),
        );
      });
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Device',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (_clusterDiscoveryPending)
              const Text(
                'Detecting features',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
        if (_supportsOnOff) ...[
          const SizedBox(height: 12),
          OnOffPage(
            chipDeviceController: chipDeviceController!,
            controlDevice: controlDevice,
            controlContext: controlContext,
          ),
        ],
        const SizedBox(height: 20),
        Text('Commands', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (commandEntries.isEmpty)
          const Text('No commands are available for this device yet.'),
        for (final entry in commandEntries)
          _CommandCard(
            chipDeviceController: chipDeviceController!,
            controlDevice: controlDevice,
            controlContext: controlContext,
            endpointId: 1,
            entry: entry,
          ),
        const Divider(height: 32),
        LiveStatusPanel(
          chipDeviceController: chipDeviceController!,
          controlDevice: controlDevice,
          controlContext: controlContext,
        ),
      ],
    );
  }
}

class _CommandEntry {
  final int clusterId;
  final String clusterName;
  final int commandId;
  final CommandInfo command;

  const _CommandEntry({
    required this.clusterId,
    required this.clusterName,
    required this.commandId,
    required this.command,
  });
}

/// A single available command shown as a card with a Send/Set-up button
/// instead of raw cluster/command IDs.
class _CommandCard extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  final int endpointId;
  final _CommandEntry entry;

  const _CommandCard({
    required this.chipDeviceController,
    required this.controlDevice,
    required this.controlContext,
    required this.endpointId,
    required this.entry,
  });

  @override
  State<_CommandCard> createState() => _CommandCardState();
}

class _CommandCardState extends State<_CommandCard> {
  bool _sending = false;

  void _send(Map<int, String>? fieldValues) {
    final tlvWriter = TlvWriter();
    tlvWriter.startStructure(AnonymousTag.instance);
    if (fieldValues != null) {
      for (final field in widget.entry.command.fields) {
        final raw = fieldValues[field.tag];
        if (raw == null || raw.isEmpty) {
          continue;
        }
        final tag = ContextSpecificTag(field.tag);
        switch (field.type) {
          case MatterValueType.uint:
            tlvWriter.putUnsigned(tag, num.tryParse(raw) ?? 0);
            break;
          case MatterValueType.int:
            tlvWriter.put(tag, int.tryParse(raw) ?? 0);
            break;
          case MatterValueType.bool:
            tlvWriter.putBool(tag, raw.toLowerCase() == 'true' || raw == '1');
            break;
          case MatterValueType.float:
          case MatterValueType.doubleValue:
            tlvWriter.putDouble(tag, double.tryParse(raw) ?? 0);
            break;
          case MatterValueType.string:
            tlvWriter.putString(tag, raw);
            break;
          default:
            break;
        }
      }
    }
    tlvWriter.endStructure();

    setState(() {
      _sending = true;
    });
    widget.chipDeviceController.invoke(
      InvokeCallbackWarp(
        onResponseCB: (_, __) {
          if (mounted) {
            setState(() => _sending = false);
          }
          showToast('${widget.entry.command.name} sent');
        },
        onErrorCB: (_) {
          if (mounted) {
            setState(() => _sending = false);
          }
          showToast('Failed to send ${widget.entry.command.name}');
        },
      ),
      widget.controlDevice.nodeId,
      InvokeElement.create(
        widget.endpointId,
        widget.entry.clusterId,
        widget.entry.commandId,
        tlvWriter.getEncoded(),
        null,
      ),
      connectContext: widget.controlContext,
      timedRequestTimeoutMs: 5000,
    );
  }

  Future<void> _onSendPressed() async {
    final fields = widget.entry.command.fields;
    if (fields.isEmpty) {
      _send(null);
      return;
    }
    final values = await showModalBottomSheet<Map<int, String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CommandFieldSheet(command: widget.entry.command),
    );
    if (values != null) {
      _send(values);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fieldCount = widget.entry.command.fields.length;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          widget.entry.command.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          fieldCount > 0
              ? '${widget.entry.clusterName} • $fieldCount field${fieldCount == 1 ? '' : 's'}'
              : widget.entry.clusterName,
        ),
        trailing: ElevatedButton.icon(
          onPressed: _sending ? null : _onSendPressed,
          icon: _sending
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(fieldCount > 0 ? Icons.tune : Icons.send),
          label: Text(fieldCount > 0 ? 'Set up' : 'Send'),
        ),
      ),
    );
  }
}

/// Bottom sheet used to collect command field values before invoking a
/// command that requires parameters.
class _CommandFieldSheet extends StatefulWidget {
  final CommandInfo command;

  const _CommandFieldSheet({required this.command});

  @override
  State<_CommandFieldSheet> createState() => _CommandFieldSheetState();
}

class _CommandFieldSheetState extends State<_CommandFieldSheet> {
  late final Map<int, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final field in widget.command.fields)
        field.tag: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _hintForType(MatterValueType type) {
    switch (type) {
      case MatterValueType.uint:
      case MatterValueType.int:
        return 'Number';
      case MatterValueType.bool:
        return 'true or false';
      case MatterValueType.float:
      case MatterValueType.doubleValue:
        return 'Decimal number';
      case MatterValueType.string:
        return 'Text';
      default:
        return '';
    }
  }

  TextInputType _keyboardTypeForType(MatterValueType type) {
    switch (type) {
      case MatterValueType.uint:
        return TextInputType.number;
      case MatterValueType.int:
        return const TextInputType.numberWithOptions(signed: true);
      case MatterValueType.float:
      case MatterValueType.doubleValue:
        return const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        );
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.command.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final field in widget.command.fields)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                controller: _controllers[field.tag],
                keyboardType: _keyboardTypeForType(field.type),
                decoration: InputDecoration(
                  labelText: field.name,
                  hintText: _hintForType(field.type),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final values = {
                      for (final entry in _controllers.entries)
                        entry.key: entry.value.text,
                    };
                    Navigator.pop(context, values);
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Power',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: _subscribe,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
              ],
            ),
            if (onoffState != null) ...[
              const SizedBox(height: 4),
              Text(onoffState!),
            ],
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _onoffControl(1),
                  icon: const Icon(Icons.lightbulb),
                  label: const Text('Turn on'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _onoffControl(0),
                  icon: const Icon(Icons.power_settings_new),
                  label: const Text('Turn off'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => _onoffControl(2),
                  icon: const Icon(Icons.sync),
                  label: const Text('Toggle'),
                ),
              ],
            ),
          ],
        ),
      ),
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
                matterClusterName(widget.clusterId),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _isConnected && !_loading ? _loadCluster : null,
            ),
          ],
        ),
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
              value: entry.value,
              isLastKnown: true,
            ),
        const Divider(height: 24),
        Text('Commands', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        if (commands.isEmpty) const Text('No known commands for this cluster'),
        if (_isConnected)
          for (final command in commands)
            _CommandCard(
              chipDeviceController: widget.chipDeviceController!,
              controlDevice: widget.controlDevice,
              controlContext: widget.controlContext,
              endpointId: widget.endpointId,
              entry: _CommandEntry(
                clusterId: widget.clusterId,
                clusterName: matterClusterName(widget.clusterId),
                commandId: command.key,
                command: command.value,
              ),
            )
        else
          for (final command in commands)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(command.value.name),
                subtitle: const Text('Connect to the device to send this'),
              ),
            ),
      ],
    );
  }

  int _cachedAttributeId(String key) {
    final id = key.split(':').last;
    return int.tryParse(id.replaceFirst('0x', ''), radix: 16) ?? 0;
  }
}

class _AttributeRow extends StatelessWidget {
  final String name;
  final String value;
  final bool isLastKnown;

  const _AttributeRow({
    required this.name,
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
          SizedBox(width: 180, child: Text(name)),
          Expanded(child: Text(isLastKnown ? 'last known: $value' : value)),
        ],
      ),
    );
  }
}

/// Advanced tab: every cluster the device supports, nothing filtered out —
/// for browsing raw attributes/commands beyond the curated Device tab.
class AdvancedDevicePage extends StatelessWidget {
  final ChipDeviceController? chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  final List<int> supportedClusters;

  const AdvancedDevicePage({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    required this.controlContext,
    required this.supportedClusters,
  });

  bool get _isConnected =>
      chipDeviceController != null && controlContext != null;

  @override
  Widget build(BuildContext context) {
    final clusters = supportedClusters.toSet().toList()..sort();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text('Advanced', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        if (!_isConnected)
          const Text('Device not connected. Showing last-known clusters.'),
        const SizedBox(height: 8),
        if (clusters.isEmpty)
          const Text('No device features were discovered yet.'),
        for (final clusterId in clusters)
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(matterClusterName(clusterId)),
              subtitle: Text(matterHex(clusterId, width: 8)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(title: Text(matterClusterName(clusterId))),
                      body: ClusterDetailPage(
                        chipDeviceController: chipDeviceController,
                        controlDevice: controlDevice,
                        controlContext: controlContext,
                        endpointId: 1,
                        clusterId: clusterId,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Reusable "current status" panel: a wildcard subscription the user can
/// start/stop to watch live attribute reports and events as they arrive.
class LiveStatusPanel extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;

  const LiveStatusPanel({
    super.key,
    required this.chipDeviceController,
    required this.controlDevice,
    this.controlContext,
  });

  @override
  State<LiveStatusPanel> createState() => _LiveStatusPanelState();
}

class _LiveStatusPanelState extends State<LiveStatusPanel> {
  bool _liveFeedOn = false;
  final Set<int> _subscriptionIds = {};
  final List<String> _eventLog = [];

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
      return TlvReader(tlv).getString(AnonymousTag.instance).toString();
    } catch (_) {
      return _hex(tlv);
    }
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
              final clusterName = matterClusterName(clusterId);
              cluster.attributes.forEach((attrId, attr) {
                lines.add(
                  '[$ts] $clusterName • ${matterAttributeName(clusterId, attrId)} = ${_decodeAttribute(attrId, attr)}',
                );
              });
              cluster.events.forEach((eventId, events) {
                for (final e in events) {
                  lines.add(
                    '[$ts] $clusterName • event #${e.eventNumber} = ${_hex(e.tlv)}',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Status & events',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ElevatedButton.icon(
              onPressed: _toggleLiveFeed,
              icon: Icon(_liveFeedOn ? Icons.stop : Icons.play_arrow),
              label: Text(_liveFeedOn ? 'Stop' : 'Start'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_eventLog.isEmpty)
          const Text('No live updates yet. Press Start to watch this device.'),
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
    final currentContext = widget.controlContext;
    if (currentContext == null) {
      showToast("Device not connected");
      return;
    }
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
                currentContext,
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
      connectContext: currentContext,
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
    final currentContext = widget.controlContext;
    if (currentContext == null) {
      showToast("Device not connected");
      return;
    }
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
            currentContext,
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
      connectContext: currentContext,
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
                'Share this device',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loading ? null : _loadFabrics,
            ),
          ],
        ),
        const Text(
          'Create a pairing code for another phone or app, or remove old controllers that can access this device.',
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _openWindow,
          child: const Text('Create sharing code'),
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
        Text(
          'Connected controllers',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (_loading) const LinearProgressIndicator(),
        if (!_loading && _fabrics.isEmpty)
          const Text('No connected controllers were read yet.'),
        for (final fabric in _fabrics)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              fabric.label?.isNotEmpty == true
                  ? fabric.label!
                  : 'Controller ${fabric.fabricIndex ?? '-'}',
            ),
            subtitle: Text(
              'Vendor ID: ${fabric.vendorId ?? '-'}  Node ID: ${fabric.nodeId ?? '-'}',
            ),
            trailing: fabric.fabricIndex == _currentFabricIndex
                ? const Text('Current')
                : TextButton(
                    onPressed: fabric.fabricIndex == null
                        ? null
                        : () => _revokeFabric(fabric.fabricIndex!),
                    child: const Text('Remove'),
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
  @override
  void initState() {
    super.initState();
    _loadBasicInfo();
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
      ],
    );
  }
}
