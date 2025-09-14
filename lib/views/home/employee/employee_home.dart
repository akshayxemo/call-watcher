import 'package:call_watcher/core/util/helper.dart';
import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/app_bar/employee_home.dart';
import 'package:call_watcher/core/widgets/call_analytics/today.dart';
import 'package:call_watcher/core/widgets/call_analytics/weekly.dart';
import 'package:call_watcher/core/widgets/call_logs/employee_call_log_list.dart';
import 'package:call_watcher/core/widgets/location/location_display.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';
import 'package:call_watcher/domain/entity/call_log/update_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/domain/usecases/call_log/get_last_call_log.dart';
import 'package:call_watcher/domain/usecases/call_log/get_past_seven_day_logs.dart';
import 'package:call_watcher/domain/usecases/call_log/update_log.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  final ScrollController _controller = ScrollController();
  String _currentAddress = "Fetching address...";
  Iterable<CallLogRecord> _callLogs = [];
  Iterable<CallLogRecord> _yesterdayCallLogs = [];
  Iterable<CallLogRecord> _todayCallLogs = [];
  int _weeklyLogCount = 0;
  bool _isLoading = true;
  int page = 1;
  int limit = 10;
  bool _hasMore = true;
  bool _isMoreDataLoading = false;
  String _loadMoreMessage = "";

  Employee? employee;

  @override
  void initState() {
    super.initState();
    _checkValidSessionOrRedirect();
    _isLoading = true;
    _loadEmployeeData();
    _requestPermissions();
    _controller.addListener(() {
      if (_controller.position.pixels >=
              _controller.position.maxScrollExtent - 200 &&
          !_isMoreDataLoading &&
          !_isLoading &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Future<void> _loadMore() async {
    setState(() {
      _isMoreDataLoading = true;
      _loadMoreMessage = "";
    });
    await Future.delayed(const Duration(seconds: 2)); // simulate API
    int nextPage = page + 1;
    int result = await fetchCallLogsByPage(nextPage, limit);
    if (result != -1) {
      if (result == 0) {
        setState(() {
          _isMoreDataLoading = false;
          _loadMoreMessage = "No more data available";
        });
      } else {
        setState(() {
          page = nextPage;
          _hasMore = result >= limit ? true : false;
          _isMoreDataLoading = false;
          _loadMoreMessage = "";
        });
      }
    } else {
      setState(() {
        _isMoreDataLoading = false;
        _loadMoreMessage = "Something Went Wrong!";
      });
    }
  }

  Future<int> fetchCallLogsByPage(int page, int limit) async {
    int? id = employee?.id;
    final messenger = ScaffoldMessenger.of(context);
    if (id == null) return -1;
    try {
      final List<CallLogRecord>? data =
          await serviceLocator<CallLogRepository>()
              .getCallLogEntriesByEmployeeId(id, page, limit);
      dev.log(">>>>>>>> ${data?.length}");

      if (data == null || data.isEmpty) {
        setState(() {
          _todayCallLogs = [];
          _yesterdayCallLogs = [];
          _callLogs = [];
          _isLoading = false; // Stop loading even if there's an error
        });
        messenger.showSnackBar(
          const SnackBar(
            content: Text('No Data Found'),
          ),
        );
        return 0;
      } else {
        final FormattedLogs logs = getFormattedLogs(data);
        setState(() {
          _todayCallLogs = [
            if (page != 1) ..._todayCallLogs,
            ...logs.todayLogs
          ];
          _yesterdayCallLogs = [
            if (page != 1) ..._yesterdayCallLogs,
            ...logs.yesterdayLogs
          ];
          _callLogs = [
            if (page != 1) ..._callLogs,
            ...logs.olderLogs,
          ];
          _isLoading = false; // Stop loading even if there's an error
        });
        final allLogs = [
          ...logs.todayLogs,
          ...logs.yesterdayLogs,
          ...logs.olderLogs,
        ];
        dev.log(">>>>>>>> Log : ${allLogs.length}");
        return allLogs.length;
      }
    } catch (error) {
      dev.log(">>>>>>>> Error:  ${error.toString()}");
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Failed to load the data'),
        ),
      );
      return -1;
    }
  }

  Future<void> _setWeeklyLogs() async {
    final FormattedLogs? logs =
        await serviceLocator<GetPastSevenDayLogs>().call();
    setState(() {
      _weeklyLogCount = (logs?.todayLogs.length ?? 0) +
          (logs?.yesterdayLogs.length ?? 0) +
          (logs?.olderLogs.length ?? 0);
    });
  }

  // Fetch call logs
  Future<void> _getCallLog() async {
    int? id = employee?.id;
    final messenger = ScaffoldMessenger.of(context);
    if (id == null) return;
    // Immediately show loading
    setState(() {
      _isLoading = true;
    });
    //in milisecond
    final lastRecordDateInMiliSecond =
        await serviceLocator<GetLastCallLogUseCase>().call(params: id);

    if (lastRecordDateInMiliSecond == 0) {
      // await _getPastSevenDayLogs();
      print("From Call Log");
      final FormattedLogs? logs =
          await serviceLocator<GetPastSevenDayLogs>().call();
      if (logs == null) {
        setState(() {
          _todayCallLogs = [];
          _yesterdayCallLogs = [];
          _callLogs = [];
          _isLoading = false; // Stop loading even if there's an error
        });
        return;
      }
      setState(() {
        _todayCallLogs = logs.todayLogs;
        _yesterdayCallLogs = logs.yesterdayLogs;
        _callLogs = logs.olderLogs;
        _isLoading = false; // Stop loading even if there's an error
      });
      final List<CallLogRecord> combinedLogs = [
        ...logs.todayLogs,
        ...logs.yesterdayLogs,
        ...logs.olderLogs,
      ];
      print("Updating...");
      final updatedRows = await serviceLocator<UpdateCallLogsUseCase>().call(
        params: UpdateLogParams(
          userId: id,
          callLogs: combinedLogs,
        ),
      );
      updatedRows.fold(
        (left) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error: ${left.toString()}')),
          );
        },
        (right) {
          messenger.showSnackBar(
            const SnackBar(content: Text('Successfully updated call logs')),
          );
        },
      );
      return;
    } else {
      print("From DB");
      final DateTime lastRecordDate =
          DateTime.fromMillisecondsSinceEpoch(lastRecordDateInMiliSecond)
              .toLocal();
      final FormattedLogs? logs = await serviceLocator<GetPastSevenDayLogs>()
          .call(params: lastRecordDate);
      // final List<CallLogRecord> combinedCurrentLogs = [
      //   ..._todayCallLogs,
      //   ..._yesterdayCallLogs,
      //   ..._callLogs,
      // ];
      final List<CallLogRecord> combinedLogs = [
        if (logs != null) ...logs.todayLogs,
        if (logs != null) ...logs.yesterdayLogs,
        if (logs != null) ...logs.olderLogs,
      ];

      if (combinedLogs.isNotEmpty) {
        print("Updating...");
        final updatedRows = await serviceLocator<UpdateCallLogsUseCase>().call(
          params: UpdateLogParams(
            userId: id,
            callLogs: combinedLogs,
          ),
        );
        updatedRows.fold(
          (left) {
            messenger.showSnackBar(
              SnackBar(content: Text('Error: ${left.toString()}')),
            );
          },
          (right) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Successfully updated call logs')),
            );
          },
        );
      }

      await fetchCallLogsByPage(1, 10);
      setState(() {
        page = 1;
        limit = 10;
        _hasMore = true;
        _isMoreDataLoading = false;
        _loadMoreMessage = "";
      });
      await _setWeeklyLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: EmployeeHomeAppBarTitle(
          employee: employee,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ), // Add padding to the right of the button
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
                  controller: _controller,
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
                              totalCount: _weeklyLogCount,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (_isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ), // Show progress indicator when loading
                        if (!_isLoading &&
                            _callLogs.isEmpty &&
                            _todayCallLogs.isEmpty &&
                            _yesterdayCallLogs.isEmpty)
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
                        if (_isMoreDataLoading && !_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        if (_loadMoreMessage.isNotEmpty &&
                            !_isMoreDataLoading &&
                            !_isLoading)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(_loadMoreMessage),
                            ),
                          ),
                        if (!_hasMore && !_isMoreDataLoading && !_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                "No More Data",
                                textAlign: TextAlign.center,
                              ),
                            ),
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
