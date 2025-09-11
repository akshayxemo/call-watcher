import 'package:call_watcher_demo/core/widgets/call_logs/log_view.dart';
import 'package:call_watcher_demo/core/widgets/location/location_display.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  String _currentAddress = "Fetching address...";
  Iterable<CallLogEntry> _callLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _requestPermissions();
  }

  // Request both location and call log permissions
  _requestPermissions() async {
    debugPrint("Requesting location and call log permissions...");

    // Request location permission
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      _getLocation(); // Fetch location
    } else {
      setState(() {
        _currentAddress = "Location Permission Denied!";
      });
    }

    // Request call log permission
    PermissionStatus callLogStatus = await Permission.phone.request();
    if (callLogStatus.isGranted) {
      _getCallLog(); // Fetch call logs
    } else {
      debugPrint("Call log Permission denied.");
      setState(() {
        _callLogs = [];
      });
    }
  }

  // Get the current location and reverse geocode it to get the address
  _getLocation() async {
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      // Reverse geocode the coordinates to get the location name
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first; // Get the first result

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    }
  }

  // Fetch call logs
  _getCallLog() async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    setState(() {
      _callLogs = entries;
      _isLoading = false; // Set loading to false once data is fetched
    });

    debugPrint("Fetched ${entries.length} call log entries.");
    // for (var entry in entries) {
    //   debugPrint("Call Log Entry: $entry");
    //   debugPrint(
    //       'Number: ${entry.number}, Type: ${entry.callType}, Date: ${DateTime.fromMillisecondsSinceEpoch(entry.timestamp ?? 0)}, Duration: ${entry.duration}s');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              radius: 20,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 150, // set desired max width
                  child: Text(
                    'John Doe',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  'Employee',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
            onPressed: () {
              // Handle notification action
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                LocationDisplay(location: _currentAddress),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : _callLogs.isEmpty
                        ? const Text('No call logs found.')
                        : Column(
                            children: _callLogs
                                .map((log) => LogView(callLog: log))
                                .toList(),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
