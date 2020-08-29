package com.example.bluetooth_sample

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.bluetooth_sample/bluetoothchannel"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getConnectedDevicesList") {
                result.success(getConnectedDevicesList())
            } else if (call.method == "showToast") {
                showToast(call.argument<String>("message").toString())
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getConnectedDevicesList(): List<Any> {
        val connectedDevicesList = mutableListOf<String>()
        val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter != null) {
            val pairedDevices: Set<BluetoothDevice>? = bluetoothAdapter.bondedDevices
            pairedDevices?.forEach { device ->
                val deviceName = device.name
                connectedDevicesList.add(deviceName)
            }
            return connectedDevicesList
        } else {
            showToast("Bluetooth not supported")
            return connectedDevicesList
        }
    }

    private fun showToast(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
    }
}
