package com.tyx.flutter_matter

import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.os.ParcelUuid
import android.util.Log
import chip.platform.AndroidBleManager
import chip.platform.BleCallback
import java.util.UUID
import kotlin.coroutines.resume
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.channels.ProducerScope
import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.callbackFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withTimeoutOrNull

@SuppressLint("MissingPermission")
/*
 * Matter BLE connection flow in this plugin:
 *
 * 1. Flutter parses the QR/manual onboarding payload and gets the discriminator.
 * 2. Flutter calls BLEManager.connect(), which reaches BLE.kt -> connectDevice().
 * 3. connectDevice() creates BluetoothManager and calls getBluetoothDevice().
 * 4. getBluetoothDevice() starts an Android BLE scan filtered by the Matter
 *    service UUID and discriminator from the onboarding payload.
 * 5. When a matching peripheral is found, connect() opens an Android
 *    BluetoothGatt connection to it.
 * 6. connect() registers that BluetoothGatt with AndroidChipPlatform.bleManager
 *    using addConnection(). The returned integer is the Matter BLE connId.
 * 7. Android GATT events are forwarded into Matter's wrapped BLE callback:
 *    connection state, service discovery, MTU changes, characteristic writes,
 *    descriptor writes, and incoming characteristic changes.
 * 8. After services are discovered, the code requests MTU 247. When MTU
 *    negotiation completes, connect() resumes and returns the connId to Flutter.
 * 9. Flutter passes this connId to ChipDeviceController.pairDevice().
 * 10. During commissioning, Matter's BLE layer asks ZGAndroidBleManager to:
 *     - subscribe to the device's Matter/BTP characteristic so responses arrive,
 *     - write BTP packets to the device with onSendWriteRequest(),
 *     - close/unsubscribe when commissioning or the BLE session ends.
 *
 * The app code does not manually build Matter commissioning packets here. This
 * file only discovers the BLE peripheral, registers the GATT connection with
 * Matter, and forwards Android BLE events/operations between Android and the
 * Matter SDK.
 */
class BluetoothManager : BleCallback {
  private val bluetoothAdapter = BluetoothAdapter.getDefaultAdapter()
  private var bleGatt: BluetoothGatt? = null
  // Matter's Android BLE manager assigns this handle when the Android GATT
  // connection is registered. Flutter later passes it into pairDevice().
  var connectionId = 0
    private set

  /**
   * Builds the Matter BLE advertisement service data used to match a device by
   * discriminator during commissioning discovery.
   */
  private fun getServiceData(discriminator: Int): ByteArray {
    val opcode = 0
    val version = 0
    val versionDiscriminator = ((version and 0xf) shl 12) or (discriminator and 0xfff)
    return intArrayOf(opcode, versionDiscriminator, versionDiscriminator shr 8)
      .map { it.toByte() }
      .toByteArray()
  }

  /**
   * Builds the scan mask for full vs short discriminator matching.
   */
  private fun getServiceDataMask(isShortDiscriminator: Boolean): ByteArray {
    val shortDiscriminatorMask =
      when (isShortDiscriminator) {
        true -> 0x00
        false -> 0xff
      }
    return intArrayOf(0xff, shortDiscriminatorMask, 0xff).map { it.toByte() }.toByteArray()
  }

  /**
   * Finds a Matter BLE device using a full discriminator.
   */
  suspend fun getBluetoothDevice(context: Context, discriminator: Int): BluetoothDevice? {
    return getBluetoothDevice(context, discriminator, false)
  }

  /**
   * Scans for Matter BLE advertisements that match the onboarding payload's
   * discriminator. Returns the first matching device or null after timeout.
   */
  suspend fun getBluetoothDevice(
    context: Context,
    discriminator: Int,
    isShortDiscriminator: Boolean
  ): BluetoothDevice? {
    if (!bluetoothAdapter.isEnabled) {
      bluetoothAdapter.enable()
    }

    val scanner =
      bluetoothAdapter.bluetoothLeScanner
        ?: run {
          Log.e(TAG, "No bluetooth scanner found")
          return null
        }

    return withTimeoutOrNull(10000) {
      callbackFlow {
          val scanCallback =
            object : ScanCallback() {
              override fun onScanResult(callbackType: Int, result: ScanResult) {
                val device = result.device
                Log.i(TAG, "Bluetooth Device Scanned Addr: ${device.address}, Name ${device.name}")

                val producerScope: ProducerScope<BluetoothDevice> = this@callbackFlow
                if (producerScope.channel.isClosedForSend) {
                  Log.w(TAG, "Bluetooth device was scanned, but channel is already closed")
                } else {
                  producerScope.trySend(device)
                }
              }

              override fun onScanFailed(errorCode: Int) {
                Log.e(TAG, "Scan failed $errorCode")
              }
            }

          val serviceData = getServiceData(discriminator)
          val serviceDataMask = getServiceDataMask(isShortDiscriminator)

          val scanFilter =
            ScanFilter.Builder()
              .setServiceData(ParcelUuid(UUID.fromString(CHIP_UUID)), serviceData, serviceDataMask)
              .build()

          val scanSettings =
            ScanSettings.Builder().setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY).build()

          Log.i(TAG, "Starting Bluetooth scan serviceData: ${serviceData.map { it.toString(16) }} serviceDataMask: ${serviceDataMask.map { it.toString(16) }}")
          scanner.startScan(listOf(scanFilter), scanSettings, scanCallback)
          awaitClose { scanner.stopScan(scanCallback) }
        }
        .first()
    }
  }

  /**
   * Connects to a [BluetoothDevice], registers the GATT connection with
   * Matter's BLE manager, and resumes once MTU negotiation completes.
   */
  suspend fun connect(context: Context, device: BluetoothDevice): BluetoothGatt? {
    return suspendCancellableCoroutine { continuation ->
      val bluetoothGattCallback = getBluetoothGattCallback(context, continuation)

      Log.i(TAG, "Connecting")
      bleGatt = device.connectGatt(context, false, bluetoothGattCallback)

      // Register the raw Android GATT connection with Matter's BLE layer. The
      // returned ID is Matter's connection handle, not a BluetoothGatt object.
      connectionId = ChipClient.getAndroidChipPlatform(context).bleManager.addConnection(bleGatt)
      ChipClient.getAndroidChipPlatform(context).bleManager.setBleCallback(this)

      continuation.invokeOnCancellation { bleGatt?.disconnect() }
    }
  }

  private fun getBluetoothGattCallback(
    context: Context,
    continuation: CancellableContinuation<BluetoothGatt?>
  ): BluetoothGattCallback {
    return object : BluetoothGattCallback() {
      private val wrappedCallback = ChipClient.getAndroidChipPlatform(context).bleManager.callback

      private val coroutineContinuation = continuation

      override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
        // Forward Android connection state changes into Matter's BLE manager so
        // it can drive the BTP connection lifecycle.
        super.onConnectionStateChange(gatt, status, newState)
        Log.i(
          TAG,
          "${gatt?.device?.name}.onConnectionStateChange status = $status, newState=$newState"
        )
        wrappedCallback.onConnectionStateChange(gatt, status, newState)

        if (newState == BluetoothProfile.STATE_CONNECTED && status == BluetoothGatt.GATT_SUCCESS) {
          Log.i("$TAG", "Discovering Services...")
          gatt?.discoverServices()
        }
      }

      override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
        // Matter's wrapped callback inspects the discovered CHIP BLE service and
        // characteristics. After that we request a larger MTU for BTP packets.
        Log.d(TAG, "${gatt?.device?.name}.onServicesDiscovered status = $status")
        wrappedCallback.onServicesDiscovered(gatt, status)

        Log.i("$TAG", "Services Discovered")
        gatt?.requestMtu(247)
      }

      override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
        // Once MTU negotiation finishes the BLE connection is ready for Matter
        // commissioning traffic, so the suspended connect() call can resume.
        Log.d(TAG, "${gatt?.device?.name}.onMtuChanged: connecting to CHIP device")
        super.onMtuChanged(gatt, mtu, status)
        wrappedCallback.onMtuChanged(gatt, mtu, status)
        if (coroutineContinuation.isActive) {
          coroutineContinuation.resume(gatt)
        }
      }

      override fun onCharacteristicChanged(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic
      ) {
        // Incoming indication/notification data from the device is forwarded to
        // Matter's BLE manager for BTP reassembly.
        Log.d(TAG, "${gatt.device.name}.onCharacteristicChanged: ${characteristic.uuid}")
        wrappedCallback.onCharacteristicChanged(gatt, characteristic)
      }

      override fun onCharacteristicRead(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        status: Int
      ) {
        // Keep Matter's BLE manager informed about read completions if it
        // requested any characteristic reads.
        Log.d(TAG, "${gatt.device.name}.onCharacteristicRead: ${characteristic.uuid} -> $status")
        wrappedCallback.onCharacteristicRead(gatt, characteristic, status)
      }

      override fun onCharacteristicWrite(
        gatt: BluetoothGatt,
        characteristic: BluetoothGattCharacteristic,
        status: Int
      ) {
        // Write confirmations let Matter know whether a BTP fragment was sent
        // successfully to the device.
        Log.d(TAG, "${gatt.device.name}.onCharacteristicWrite: ${characteristic.uuid} -> $status")
        wrappedCallback.onCharacteristicWrite(gatt, characteristic, status)
      }

      override fun onDescriptorRead(
        gatt: BluetoothGatt,
        descriptor: BluetoothGattDescriptor,
        status: Int
      ) {
        // Descriptor reads are forwarded for completeness to the wrapped Matter
        // BLE callback.
        Log.d(TAG, "${gatt.device.name}.onDescriptorRead: ${descriptor.uuid} -> $status")
        wrappedCallback.onDescriptorRead(gatt, descriptor, status)
      }

      override fun onDescriptorWrite(
        gatt: BluetoothGatt,
        descriptor: BluetoothGattDescriptor,
        status: Int
      ) {
        // Subscription setup normally writes the CCC descriptor; Matter needs
        // this completion to continue the BLE transport setup.
        Log.d(TAG, "${gatt.device.name}.onDescriptorWrite: ${descriptor.uuid} -> $status")
        wrappedCallback.onDescriptorWrite(gatt, descriptor, status)
      }

      override fun onReadRemoteRssi(gatt: BluetoothGatt, rssi: Int, status: Int) {
        // Forward RSSI reads if the underlying BLE stack requested them.
        Log.d(TAG, "${gatt.device.name}.onReadRemoteRssi: $rssi -> $status")
        wrappedCallback.onReadRemoteRssi(gatt, rssi, status)
      }

      override fun onReliableWriteCompleted(gatt: BluetoothGatt, status: Int) {
        // Forward reliable-write completion to keep the wrapped callback state
        // consistent with Android GATT.
        Log.d(TAG, "${gatt.device.name}.onReliableWriteCompleted: $status")
        wrappedCallback.onReliableWriteCompleted(gatt, status)
      }
    }
  }

  companion object {
    private const val TAG = "chip.BluetoothManager"
    private const val CHIP_UUID = "0000FFF6-0000-1000-8000-00805F9B34FB"
  }

  override fun onCloseBleComplete(connId: Int) {
    // Matter reports that BLE close finished; clear the stored connection ID.
    connectionId = 0
    Log.d(TAG, "onCloseBleComplete")
  }

  override fun onNotifyChipConnectionClosed(connId: Int) {
    // Matter reports that the CHIP BLE connection is closed; release the GATT
    // resource and clear the stored connection ID.
    bleGatt?.close()
    connectionId = 0
    Log.d(TAG, "onNotifyChipConnectionClosed")
  }
}

/**
 * Small wrapper around Matter's AndroidBleManager.
 *
 * By default the superclass performs the real Android GATT operations. When a
 * platformDelegate is installed, these callbacks are forwarded to Flutter so a
 * custom BLE implementation can handle the same Matter BLE transport requests.
 */
class ZGAndroidBleManager(context: Context) : AndroidBleManager(context) {

  var platformDelegate: BlePlatformDelegate? = null
    set(value) {
      if (value != null && field != null) {
        throw RuntimeException("Already set BlePlatformDelegate")
      }
      field = value
    }

  override fun onSubscribeCharacteristic(
    connId: Int,
    svcId: ByteArray?,
    charId: ByteArray?
  ): Boolean {
    // Matter asks the platform to subscribe to a GATT characteristic so the
    // phone can receive device responses as indications/notifications.
    if (platformDelegate != null) {
      return platformDelegate!!.onSubscribeCharacteristic(connId, svcId, charId)
    }
    return super.onSubscribeCharacteristic(connId, svcId, charId)
  }

  override fun onUnsubscribeCharacteristic(
    connId: Int,
    svcId: ByteArray?,
    charId: ByteArray?
  ): Boolean {
    // Matter asks the platform to cancel the previous subscription for this
    // service/characteristic on the given Matter BLE connection.
    if (platformDelegate != null) {
      return platformDelegate!!.onUnsubscribeCharacteristic(connId, svcId, charId)
    }
    return super.onUnsubscribeCharacteristic(connId, svcId, charId)
  }

  override fun onCloseConnection(connId: Int): Boolean {
    // Close the Matter BLE connection identified by connId.
    if (platformDelegate != null) {
      return platformDelegate!!.onCloseConnection(connId)
    }
    return super.onCloseConnection(connId)
  }

  override fun onSendWriteRequest(
    connId: Int,
    svcId: ByteArray?,
    charId: ByteArray?,
    characteristicData: ByteArray?
  ): Boolean {
    // Matter sends commissioning/BTP bytes to the device by writing this data
    // to the provided GATT service and characteristic.
    if (platformDelegate != null) {
      return platformDelegate!!.onSendWriteRequest(connId, svcId, charId, characteristicData)
    }
    return super.onSendWriteRequest(connId, svcId, charId, characteristicData)
  }

  override fun onGetMTU(connId: Int): Int {
    // Matter queries the negotiated BLE MTU so it can size BTP fragments.
    if (platformDelegate != null) {
      return platformDelegate!!.onGetMTU(connId)
    }
    return super.onGetMTU(connId)
  }

  interface BlePlatformDelegate {
    fun onSubscribeCharacteristic(connId: Int, svcId: ByteArray?, charId: ByteArray?): Boolean
    fun onUnsubscribeCharacteristic(connId: Int, svcId: ByteArray?, charId: ByteArray?): Boolean
    fun onCloseConnection(connId: Int): Boolean
    fun onSendWriteRequest(connId: Int, svcId: ByteArray?, charId: ByteArray?, characteristicData: ByteArray?): Boolean
    fun onGetMTU(connId: Int): Int
  }
}
