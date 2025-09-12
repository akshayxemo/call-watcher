import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/call_analytics/today.dart';
import 'package:call_watcher/core/widgets/call_analytics/weekly.dart';
import 'package:call_watcher/core/widgets/call_logs/employee_call_log_list.dart';
import 'package:call_watcher/core/widgets/location/location_display.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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
  Iterable<CallLogEntry> _yesterdayCallLogs = [];
  Iterable<CallLogEntry> _todayCallLogs = [];
  bool _isLoading = true;

  Employee? employee;

  @override
  void initState() {
    super.initState();
    _checkValidSessionOrRedirect();
    _isLoading = true;
    _requestPermissions();
    _loadEmployeeData();
  }

  Future<void> _checkValidSessionOrRedirect() async {
    bool validSession = await hasValidSession();
    if (!validSession && mounted) context.goNamed("auth");
  }

  Future<void> _loadEmployeeData() async {
    employee = await getCurrentEmployeeFromSessionData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
        return dt.year == now.year &&
            dt.month == now.month &&
            dt.day == now.day;
      }).toList();

      final List<CallLogEntry> computedYesterday = entries.where((el) {
        if (el.timestamp == null) return false;
        final dt = DateTime.fromMillisecondsSinceEpoch(el.timestamp!).toLocal();
        return dt.year == now.year &&
            dt.month == now.month &&
            dt.day == now.day - 1;
      }).toList();

      final List<CallLogEntry> computedOlder = entries.where((el) {
        if (el.timestamp == null) return false;
        final dt = DateTime.fromMillisecondsSinceEpoch(el.timestamp!).toLocal();
        return !(dt.year == now.year &&
            dt.month == now.month &&
            (dt.day == now.day || dt.day == now.day - 1));
      }).toList();

      await Future.delayed(const Duration(seconds: 2));

      // Update the state to reflect the fetched logs
      setState(() {
        _todayCallLogs = computedToday;
        _yesterdayCallLogs = computedYesterday;
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
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    employee?.name != null && employee!.name != ""
                        ? employee!.name
                        : 'John Doe',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    employee?.email != null && employee!.email != ""
                        ? employee!.email
                        : 'Employee',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 16.0), // Add padding to the right of the button
            // child: TextButton.icon(
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.black,
            //   ),
            //   onPressed: () {},
            //   icon: const Icon(
            //     Icons.logout,
            //     size: 24,
            //   ),
            //   label: const Text('Logout'),
            // ),
            child: IconButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                final navigator = GoRouter.of(context);
                final messenger = ScaffoldMessenger.of(context);
                await clearSession();
                if (mounted) {
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Logout Successfully.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  navigator.goNamed("auth");
                }
              },
              icon: const Icon(
                Icons.logout,
                size: 24,
              ),
            ),
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.notifications,
          //     size: 24,
          //   ),
          //   onPressed: () {
          //     // Handle notification action
          //   },
          // ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.settings,
          //     size: 24,
          //   ),
          //   onPressed: () {
          //     // Handle settings action
          //   },
          // ),
        ],
      ),
      body: _isLoading || employee == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
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
                              totalCount:
                                  _todayCallLogs.length + _callLogs.length,
                            ),
                          ],
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.fromLTRB(8.0, 12, 8.0, 12.0),
                        //   child: SizedBox(
                        //     width: double.infinity,
                        //     child: Text(
                        //       "Call Logs",
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //         fontSize: 20,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 8),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ), // Show progress indicator when loading
                        if (!_isLoading && _callLogs.isEmpty)
                          const Text('No call logs found.'),
                        if (!_isLoading && _todayCallLogs.isNotEmpty)
                          EmployeeCallLogList(
                            callLogs: _todayCallLogs.toList(),
                            label: "Today",
                          ),
                        if (!_isLoading && _yesterdayCallLogs.isNotEmpty)
                          EmployeeCallLogList(
                            callLogs: _yesterdayCallLogs.toList(),
                            label: "Yesterday",
                          ),
                        if (!_isLoading && _callLogs.isNotEmpty)
                          EmployeeCallLogList(
                            callLogs: _callLogs.toList(),
                            label: "Older",
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
