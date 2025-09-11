import 'package:call_watcher_demo/core/widgets/call_analytics/today.dart';
import 'package:call_watcher_demo/core/widgets/call_analytics/weekly.dart';
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
  Iterable<CallLogEntry> _todayCallLogs = [];
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
        _todayCallLogs = [];
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
  Future<void> _getCallLog() async {
    // Immediately show loading
    setState(() {
      _isLoading = true;
    });

    try {
      final Iterable<CallLogEntry> entries = await CallLog.query(
        dateTimeFrom: DateTime.now().subtract(const Duration(days: 7)),
        dateTimeTo: DateTime.now(),
      );
      final DateTime now = DateTime.now().toLocal();

      final List<CallLogEntry> computedToday = entries.where((el) {
        if (el.timestamp == null) return false;
        final dt = DateTime.fromMillisecondsSinceEpoch(el.timestamp!).toLocal();
        return dt.year == now.year && dt.month == now.month && dt.day == now.day;
      }).toList();

      final List<CallLogEntry> computedOlder = entries.where((el) {
        if (el.timestamp == null) return false;
        final dt = DateTime.fromMillisecondsSinceEpoch(el.timestamp!).toLocal();
        return !(dt.year == now.year && dt.month == now.month && dt.day == now.day);
      }).toList();

      await Future.delayed(const Duration(seconds: 2));

      // Update the state to reflect the fetched logs
      setState(() {
        _todayCallLogs = computedToday;
        _callLogs = computedOlder;
        _isLoading = false; // Set loading to false once data is fetched
      });
    } catch (error) {
      // Handle errors if any
      debugPrint("Error fetching call logs: $error");
      setState(() {
        _isLoading = false; // Stop loading even if there's an error
      });
    }
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                size: 24,
              ),
              onPressed: () {
                // Handle notification action
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 24,
              ),
              onPressed: () {
                // Handle settings action
              },
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _getCallLog,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LocationDisplay(location: _currentAddress),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TodayAnalyticsWidget(
                          totalCount: _todayCallLogs.length,
                        ),
                        const SizedBox(width: 8),
                        WeeklyAnalyticsWidget(
                          totalCount: _todayCallLogs.length + _callLogs.length,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ), // Show progress indicator when loading
                    if (!_isLoading && _callLogs.isEmpty)
                      const Text('No call logs found.'),
                    if (!_isLoading && _todayCallLogs.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          "Today",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _todayCallLogs.length,
                        itemBuilder: (context, index) =>
                            LogView(callLog: _todayCallLogs.elementAt(index)),
                      ),
                    ],
                    if (!_isLoading && _callLogs.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          "Older",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _callLogs.length,
                        itemBuilder: (context, index) =>
                            LogView(callLog: _callLogs.elementAt(index)),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
