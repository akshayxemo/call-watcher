import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:call_watcher/core/widgets/call_logs/admin_log_view.dart';
import 'package:call_watcher/core/widgets/filters/filter_modal.dart';
import 'package:call_watcher/core/widgets/location/location_display.dart';
import 'package:call_watcher/core/widgets/pagination/pagination.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Admin? admin;
  // bool _isLoading = true;
  bool _isLogsLoading = false;
  String _currentAddress = "Fetching address...";
  int currentPageIndex = 0;
  List<CallLogRecord> logs = [];
  int totalCount = 0;
  int page = 1;
  int limit = 10;
  int? _startDate;
  int? _endDate;
  int? _totalFilters;
  Employee? _user;

  @override
  void initState() {
    super.initState();
    _totalFilters = 0;
    // _isLoading = true;
    currentPageIndex = 0;
    _requestPermissions();
    _getLogs();
  }

  Future<void> _requestPermissions() async {
    debugPrint("Requesting location and call log permissions...");

    // Request location permission
    PermissionStatus locationStatus = await Permission.location.request();
    if (!mounted) return; // <-- guard
    if (locationStatus.isGranted) {
      _getLocation(); // Fetch location
    } else {
      setState(() {
        _currentAddress = "Location Permission Denied!";
      });
    }
  }

  // Get the current location and reverse geocode it to get the address
  Future<void> _getLocation() async {
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

      if (!mounted) return; // <-- guard

      setState(() {
        _currentAddress = "${place.locality}, ${place.country}";
      });
    }
  }

  Future<void> _getLogs() async {
    if (mounted) {
      setState(() {
        _isLogsLoading = true;
      });
    }
    final PaginatedCallLogsResponse? response =
        await serviceLocator<CallLogRepository>().getCallLogsPaginated(
      page: page,
      pageSize: limit,
      endDate: _endDate,
      startDate: _startDate,
      userId: _user?.id,
    );
    if (!mounted) return; // <-- guard
    if (response == null) {
      print("response is null");
      setState(() {
        logs = [];
        totalCount = 0;
        _isLogsLoading = false;
      });
      return;
    }
    final List<CallLogRecord> records = response.logs;
    final int count = response.totalCount;

    // if (records.isNotEmpty && count > 0) {
    setState(() {
      logs = records;
      totalCount = count;
      _isLogsLoading = false;
    });
    // }
    // setState(() {
    //   _isLogsLoading = false;
    // });
  }

  Future<void> _getFilters(
      {int? startDate, int? endDate, Employee? user}) async {
    int totalFiltersApplied = 0;

    if ((startDate != null && endDate != null) &&
        (startDate != 0 && endDate != 0)) {
      totalFiltersApplied += 1;
    }

    if (user != null) {
      totalFiltersApplied += 1;
    }

    if (mounted) {
      setState(() {
        _startDate = startDate;
        _endDate = endDate;
        _totalFilters = totalFiltersApplied;
        _user = user;
        page = 1;
        limit = 10;
      });
    }
    await _getLogs();
  }

  void _onPageChanged(int newPage) {
    if (mounted) {
      setState(() {
        page = newPage;
      });
    }
    _getLogs(); // <-- fetch logs when page changes
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          if (mounted) {
            setState(() {
              _startDate = null;
              _endDate = null;
              _user = null;
              page = 1;
              limit = 10;
            });
            // Add your refresh logic here if needed
            await _getLogs();
            return;
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LocationDisplay(location: _currentAddress),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Call Logs",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$totalCount results found",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 45, // square size
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(8), // rounded square
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      backgroundColor: Colors.white,
                                      builder: (BuildContext context) {
                                        return FilterModal(
                                          getDataFn: _getFilters,
                                          startDate: _startDate,
                                          endDate: _endDate,
                                          user: _user,
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.filter_list),
                                ),
                              ),
                            ),
                          ),
                          if (_totalFilters != null && _totalFilters! > 0)
                            Positioned(
                              top: -10,
                              left: -10,
                              child: Container(
                                alignment: Alignment.center,
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: AppColors.accentColor,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  "${_totalFilters ?? 0}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_isLogsLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (totalCount <= 0 && !_isLogsLoading)
                  const Center(
                    child: Text("No Data Found"),
                  )
                else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    itemBuilder: (context, index) => AdminLogView(
                      callLog: logs[index],
                    ),
                  ),
                  PaginationView(
                    currentPage: page,
                    totalPage: (totalCount / limit).ceil(),
                    onFirst: () => _onPageChanged(1),
                    onLast: () => _onPageChanged((totalCount / limit).ceil()),
                    onNext: (i) => _onPageChanged(i + 1),
                    onPrevious: (i) => _onPageChanged(i - 1),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
