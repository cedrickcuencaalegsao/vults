import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vults/core/constants/constant_string.dart';
import 'package:vults/model/device_model.dart';
import 'package:vults/viewmodels/bloc/device/device_bloc.dart';
import 'package:vults/views/widgets/mobile/app_bar.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  DevicesScreenState createState() => DevicesScreenState();
}

class DevicesScreenState extends State<DevicesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DeviceBloc>().add(LoadDevicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Devices",
        iconColor: ConstantString.darkBlue,
        fontColor: ConstantString.darkBlue,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: ConstantString.fontFredokaOne,
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DevicesLoaded) {
            return _buildDevicesList(state.devices);
          } else if (state is DeviceError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No devices found'));
        },
      ),
    );
  }

  Widget _buildDevicesList(List<DeviceModel> devices) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your devices",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return _buildDeviceItem(devices[index]);
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Implement sign out from all devices
                for (var device in devices) {
                  context.read<DeviceBloc>().add(
                    UpdateDeviceStatusRequested(
                      deviceId: device.id,
                      status: DeviceStatus.inactive,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                "Sign Out From All Devices",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(DeviceModel device) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getDeviceIcon(device.type),
              color: Colors.indigo[900],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[900],
                  ),
                ),
                Text(
                  _getLastActiveText(device.lastActive),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (device.status == DeviceStatus.active)
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon(DeviceType type) {
    switch (type) {
      case DeviceType.mobile:
        return Icons.phone_android;
      case DeviceType.tablet:
        return Icons.tablet_android;
      case DeviceType.desktop:
        return Icons.computer;
      case DeviceType.web:
        return Icons.web;
    }
  }

  String _getLastActiveText(DateTime lastActive) {
    final now = DateTime.now();
    final difference = now.difference(lastActive);

    if (difference.inMinutes < 1) {
      return 'Currently active';
    } else if (difference.inHours < 1) {
      return 'Last active ${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return 'Last active ${difference.inHours} hours ago';
    } else {
      return 'Last active ${difference.inDays} days ago';
    }
  }
}
