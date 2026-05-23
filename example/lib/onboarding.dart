import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_matter/flutter_matter.dart';
import 'package:flutter_matter_example/device_provisioning.dart';
import 'package:flutter_matter_example/wifi_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class OnboardingWidget extends StatefulWidget {
  const OnboardingWidget({super.key});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final _networkInfo = NetworkInfo();

  late TextEditingController _editingController;
  bool isParsing = false;

  _OnboardingWidgetState() {
    _editingController = TextEditingController()..text = "MT:-G7B4VSJ01C5MB73120";
  }  

  void onDetect(BarcodeCapture barcodes) {
    _editingController.text = barcodes.barcodes.firstOrNull?.displayValue ?? '';
    parserCode(_editingController.text);
  }

  Future<String?> _getCurrentIosSsid() async {
    if (!Platform.isIOS) {
      return null;
    }
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (!permissionStatus.isGranted) {
      return null;
    }
    final ssid = await _networkInfo.getWifiName();
    if (ssid == null) {
      return null;
    }
    final normalizedSsid = ssid.replaceAll('"', '').trim();
    if (normalizedSsid.isEmpty) {
      return null;
    }
    return normalizedSsid;
  }

  void parserCode(String code) async {
    if (isParsing) {
      return;
    }
    isParsing = true;
    late final OnboardingPayload payload;
    try {
      payload = await OnboardingPayloadParser().parse(_editingController.text);
    } catch (e) {
      Fluttertoast.showToast(msg: '无效Code');
      isParsing = false;
      return;
    }

    String? currentSsid;
    try {
      currentSsid = await _getCurrentIosSsid();
    } catch (_) {}

    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
      if (currentSsid != null) {
        return DeviceProvisioningPage(
          payload: payload,
          onboardingPayload: code,
          wiFiCredentials: WiFiCredentials(ssid: currentSsid!, password: ''),
        );
      }
      return WifiInputPage(
        onboardingPayload: payload,
        code: code,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body:  Stack(
        children: [
          MobileScanner(
            onDetect: onDetect,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.white38,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      parserCode(_editingController.text);
                    },
                    child: Text('Submit')
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
