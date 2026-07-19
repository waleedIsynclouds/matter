import 'package:flutter/material.dart';
import 'package:flutter_matter_example/commissioning_page.dart';
import 'package:flutter_matter_example/control_page.dart';
import 'package:flutter_matter_example/uitls.dart';

import 'data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    _getDevices();
    deviceChangeNotifier.stream.listen((event) {
      _getDevices();
    });
  }

  void _getDevices() async {
    getDevices()
        .then((value) {
          setState(() {
            devices = value;
          });
        })
        .catchError((e) {
          showToast("Get devices error $e");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Matter Plugin Demo')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return const CommissioningPage();
              },
            ),
          );
        },
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final device = devices[index];
          final subtitleParts = <String>[
            'NodeId: ${device.nodeId}',
            if (device.vendorId != null)
              'VID: 0x${device.vendorId!.toRadixString(16)}',
            if (device.productId != null)
              'PID: 0x${device.productId!.toRadixString(16)}',
            if (device.pairedAt != null)
              'Paired: ${device.pairedAt!.toLocal().toString().split('.').first}',
          ];
          return ListTile(
            title: Text("Device ${device.nodeId}"),
            subtitle: Text(subtitleParts.join(' • ')),
            isThreeLine: true,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ControlPage(device: device);
                  },
                ),
              );
            },
          );
        },
        itemCount: devices.length,
      ),
    );
  }
}
