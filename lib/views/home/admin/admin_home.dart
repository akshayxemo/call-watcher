import 'package:call_watcher/core/config/theme/app.colors.dart';
import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/app_bar/admin_home.dart';
import 'package:call_watcher/core/widgets/bottom_nav/bottom_nav_admin.dart';
import 'package:call_watcher/core/widgets/call_logs/admin_log_view.dart';
import 'package:call_watcher/core/widgets/location/location_display.dart';
import 'package:call_watcher/core/widgets/pagination/pagination.dart';
import 'package:call_watcher/data/models/admin.dart';
import 'package:call_watcher/data/models/call_log.dart';
import 'package:call_watcher/domain/entity/call_log/call_log.dart';
import 'package:call_watcher/domain/repository/call_log.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Admin? admin;
  bool _isLoading = true;
  bool _isLogsLoading = false;
  String _currentAddress = "Fetching address...";
  int currentPageIndex = 0;
  List<CallLogRecord> logs = [];
  int totalCount = 0;
  int page = 1;
  int limit = 10;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    currentPageIndex = 0;
    _loadAdminData();
    _requestPermissions();
    _getLogs();
  }

  Future<void> _loadAdminData() async {
    admin = await getCurrentEAdminFromSessionData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_role');
  }

  Future<void> _getLogs() async {
    setState(() {
      _isLogsLoading = true;
    });
    final PaginatedCallLogsResponse? response =
        await serviceLocator<CallLogRepository>()
            .getCallLogsPaginated(page: page, pageSize: limit);

    if (response == null) return;
    final List<CallLogRecord> records = response.logs;
    final int count = response.totalCount;

    if (records.isNotEmpty && count > 0) {
      setState(() {
        logs = records;
        totalCount = count;
      });
    }
    setState(() {
      _isLogsLoading = false;
    });
  }

  void _onPageChanged(int newPage) {
    setState(() {
      page = newPage;
      _getLogs(); // <-- fetch logs when page changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdminHomeAppBarTitle(
          admin: admin,
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
      bottomNavigationBar: AdminBottomNavBar(
        pageIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: _isLoading || admin == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Add your refresh logic here if needed
                  return;
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              Container(
                                width: 45, // square size
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      8), // rounded square
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
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          builder: (BuildContext context) {
                                            return SafeArea(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                      "Filter Options",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.sort),
                                                      title:
                                                          const Text("Sort by"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        // handle action
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.category),
                                                      title: const Text(
                                                          "Category"),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                        // handle action
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(Icons.filter_list),
                                    ),
                                  ),
                                ),
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
                            onLast: () =>
                                _onPageChanged((totalCount / limit).ceil()),
                            onNext: (i) => _onPageChanged(i + 1),
                            onPrevious: (i) => _onPageChanged(i - 1),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
