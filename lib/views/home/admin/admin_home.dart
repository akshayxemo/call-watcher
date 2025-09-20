import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/app_bar/admin_home.dart';
import 'package:call_watcher/core/widgets/bottom_nav/bottom_nav_admin.dart';
import 'package:call_watcher/core/widgets/location/location_display.dart';
import 'package:call_watcher/data/models/admin.dart';
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
  String _currentAddress = "Fetching address...";
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    currentPageIndex = 0;
    _loadAdminData();
    _requestPermissions();
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
      bottomNavigationBar: AdminBottomNavBar(pageIndex: currentPageIndex, onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },),
      // bottomNavigationBar: NavigationBar(
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      //     NavigationDestination(icon: Icon(Icons.person), label: 'Users'),
      //     NavigationDestination(
      //         icon: Icon(Icons.leaderboard), label: 'Analytics'),
      //     NavigationDestination(icon: Icon(Icons.list), label: 'logs'),
      //   ],
      //   labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      //   selectedIndex: currentPageIndex,
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       currentPageIndex = index;
      //     });
      //   },
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Users'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.leaderboard), label: 'Analytics'),
      //     BottomNavigationBarItem(icon: Icon(Icons.list), label: 'logs'),
      //   ],
      //   currentIndex: 3,
      //   selectedItemColor: Colors.amber[800],
      //   unselectedItemColor: Colors.black,
      //   showUnselectedLabels: true,
      //   showSelectedLabels: true,

      //   onTap: (i) {},
      // ),
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
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
