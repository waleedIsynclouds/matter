import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_matter/flutter_matter.dart';
import 'package:flutter_matter_example/data.dart';
import 'package:collection/collection.dart';

import 'uitls.dart';

class _ConnectedDeviceCallbackWarp extends ConnectedDeviceCallback {
  final Function(Object? context) onConnectedFun;
  final Function(Exception)? onConnectionFailureFun;

  _ConnectedDeviceCallbackWarp({required this.onConnectedFun, this.onConnectionFailureFun});

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
  @override
  void onError(int status, Object? connectContext) {
    print("OpenCommissioningCallbackWarp onError");
  }

  @override
  void onSuccess(Object? connectContext, String manualPairingCode, String qrCode) {
    print('OpenCommissioningCallbackWarp onSuccess $manualPairingCode $qrCode');
  }
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
  final tabs = [
    Tab(text: 'Info'),
    Tab(text: 'On/Off'),
    Tab(text: 'Read/Write'),
    // Tab(text: 'Subscribe'),
    Tab(text: 'OCW'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    createChipDeviceController().then((value) {
      this.chipDeviceController = value;
    });
  }

  void _changeConnectState() {
    if (this.chipDeviceController == null || connectting) {
      return;
    }
    connectting = true;
    if (connectContext == null) {
      chipDeviceController!.connectedDevice(
          widget.device.nodeId,
          _ConnectedDeviceCallbackWarp(onConnectionFailureFun: (_) {
            connectting = false;
          }, onConnectedFun: (context) {
            setState(() {
              connectting = false;
              this.connectContext = context;
            });
          }));
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
      new ReportCallbackWarp(
        onReportFun: (nodeState) {
          final tlvData = nodeState.endpoints[endpointId]?.clusters[clusterId]?.attributes[attributeId]?.tlv;
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
          chipDeviceController!.invoke(InvokeCallbackWarp(
            onResponseCB: (p0, p1) {
              showToast("delete success");
              deleteDevice(widget.device);
              Navigator.pop(context);
            },
            onErrorCB: (p1) {
              showToast("delete failed");
            },
          ), widget.device.nodeId, timedRequestTimeoutMs: 5000, connectContext: connectContext, InvokeElement.create(endpointId, clusterId, 0x0A, tlvWriter.getEncoded(), null));
        },
        onErrorFun: (_, __, ___) {
          showToast("delete failed");
        },
      ), 
      [ChipAttributePath(endpointId: ChipPathId.forId(endpointId), attributeId: ChipPathId.forId(attributeId), clusterId: ChipPathId.forId(clusterId),)],
      null, 
      null, 
      false, 
      5000, 
      0
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
              child: Text(connectContext == null ? "Connect" : "disConnect"))
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: tabs,
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _unPairDevice();
      }, child: Icon(Icons.delete), backgroundColor: Colors.red,),
      body: TabBarView(
        controller: tabController,
        children: tabs.mapIndexed((index, e) {
          return Builder(builder: (_) {
            if (connectContext == null) {
              return Center(child: Text("Device not connected"));
            } else {
              if (tabs[index].text == 'Info') {
                return DeviceInfoTabPage(
                    chipDeviceController: chipDeviceController!,
                    controlDevice: widget.device,
                    controlContext: connectContext);
              }
              if (tabs[index].text == 'OCW') {
                return OCWTabPage(
                    chipDeviceController: chipDeviceController!,
                    controlDevice: widget.device,
                    controlContext: connectContext);
              }
              if (tabs[index].text == 'Read/Write') {
                return Read_WritePage(
                    chipDeviceController: chipDeviceController!,
                    controlDevice: widget.device,
                    controlContext: connectContext);
              }
              return OnOffPage(
                  chipDeviceController: chipDeviceController!,
                  controlDevice: widget.device);
            }
          });
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
  const OnOffPage(
      {super.key,
      required this.chipDeviceController,
      required this.controlDevice,
      this.controlContext});

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
    final ele =
        InvokeElement.create(0x1, 0x6, commandId, writer.getEncoded(), null);
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
        ele);
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
          final tlvData = nodeState.endpoints[endpointId]?.clusters[clusterId]
              ?.attributes[attributeId]?.tlv;
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
        )
      ],
      null, // eventPaths
      null, // dataVersionFilters
      3,    // minInterval
      8,    // maxInterval
      true, // keepSubscriptions
      false, // isFabricFiltered
      6000, // imTimeoutMs
      0,    // eventMin
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscribedIds.forEach((element) {
      widget.chipDeviceController.getFabricIndex().then((value) {
        if (value == null) {
          return;
        }
        widget.chipDeviceController
            .unSubscription(value, widget.controlDevice.nodeId, element);
      });
    });
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

/// OCW Page
class OCWTabPage extends StatelessWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;

  const OCWTabPage(
      {super.key,
      required this.chipDeviceController,
      required this.controlDevice,
      this.controlContext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                final tlvWriter = TlvWriter();
                tlvWriter.startStructure(AnonymousTag.instance);
                tlvWriter.endStructure();
                final invokeElement = InvokeElement.create(
                    0, 0x0000003C, 0x00000002, tlvWriter.getEncoded(), null);
                chipDeviceController.invoke(
                    InvokeCallbackWarp(
                      onDoneCB: () {
                        chipDeviceController
                            .openPairingWindowWithPIN(
                                controlContext!,
                                180,
                                3850,
                                20202021,
                                new OpenCommissioningCallbackWarp())
                            .then((value) {
                          showToast("Success, code: ${value}");
                        }).catchError((e, s) {
                          print(s);
                          showToast("failed");
                        });
                      },
                      onResponseCB: (_, __) {},
                      onErrorCB: (p0) {},
                    ),
                    controlDevice.nodeId,
                    invokeElement,
                    connectContext: controlContext,
                    timedRequestTimeoutMs: 2000,
                    imTimeoutMs: 0);
              },
              child: Text('openPairingWindow'))
        ],
      ),
    );
  }
}


/// Read/Write Page
class Read_WritePage extends StatefulWidget {
  final ChipDeviceController chipDeviceController;
  final Device controlDevice;
  final Object? controlContext;
  const Read_WritePage({super.key, required this.chipDeviceController, required this.controlDevice, this.controlContext});

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
      [AttributeWriteRequest(endpointId: ChipPathId.forId(endpointId), clusterId: ChipPathId.forId(clusterId), attributeId: ChipPathId.forId(attributeId), dataVersion: 0, tlv: TlvWriter().putString(AnonymousTag.instance, writeValue).getEncoded())], 
      5000, 
      2000,
      connectContext: widget.controlContext
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
          final tlvData = nodeState.endpoints[endpointId]?.clusters[clusterId]?.attributes[attributeId]?.tlv;
          if (tlvData == null) {
            showToast("read failed");
            return;
          }
          TlvReader reader = TlvReader(tlvData);
          setState(() {
            this._readValue = reader.getString(AnonymousTag.instance).toString();
          });
        },
        onErrorFun: (_, __, ___) {
          showToast("read failed");
        },
      ), 
      [ChipAttributePath(endpointId: ChipPathId.forId(endpointId), attributeId: ChipPathId.forId(attributeId), clusterId: ChipPathId.forId(clusterId),)],
      null, 
      null, 
      false, 
      5000, 
      0
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
              SizedBox(width: 5,),
              Expanded(
                child: TextField(
                  controller: editingController,
                  decoration: InputDecoration(
                    hintText: "Enter a value"
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
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
          SizedBox(height: 32,),
          ElevatedButton(
            onPressed: () {
              _readNodeLabel();
            },
            child: Text("Read NodeLabel"),
          ),
          SizedBox(height: 12,),
          Text("Device NodeLabel Value: $_readValue")
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

  const DeviceInfoTabPage(
      {super.key,
      required this.chipDeviceController,
      required this.controlDevice,
      this.controlContext});

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
        widget.chipDeviceController
            .unSubscription(value, widget.controlDevice.nodeId, id);
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
              nodeState.endpoints[0]?.clusters[_basicInfoClusterId]?.attributes ??
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
          final ts = DateTime.now().toIso8601String().split('T').last.split('.').first;
          nodeState.endpoints.forEach((epId, endpoint) {
            endpoint.clusters.forEach((clusterId, cluster) {
              cluster.attributes.forEach((attrId, attr) {
                lines.add(
                    '[$ts] attr ep:$epId cluster:0x${clusterId.toRadixString(16)} attr:0x${attrId.toRadixString(16)} = ${_decodeAttribute(attrId, attr)}');
              });
              cluster.events.forEach((eventId, events) {
                for (final e in events) {
                  lines.add(
                      '[$ts] event ep:$epId cluster:0x${clusterId.toRadixString(16)} event:0x${eventId.toRadixString(16)} #${e.eventNumber} = ${_hex(e.tlv)}');
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
        )
      ],
      [
        ChipEventPath(
          endpointId: ChipPathId.forWildcard(),
          clusterId: ChipPathId.forWildcard(),
          eventId: ChipPathId.forWildcard(),
          isUrgent: false,
        )
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
            Text('Basic Information cluster',
                style: Theme.of(context).textTheme.titleMedium),
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
                  child: Text(_basicInfoLabels[entry.key] ??
                      'Attribute 0x${entry.key.toRadixString(16)}'),
                ),
                Expanded(child: Text(entry.value)),
              ],
            ),
          ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Live events & attribute reports',
                style: Theme.of(context).textTheme.titleMedium),
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
            child: Text(line,
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ),
      ],
    );
  }
}