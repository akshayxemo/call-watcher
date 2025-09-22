import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/app_bar/admin_home.dart';
import 'package:call_watcher/core/widgets/bottom_nav/bottom_nav_admin.dart';
import 'package:call_watcher/data/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key, required this.child});
  final Widget child;

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  Admin? admin;
  // bool _isLoading = true;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // _isLoading = true;
    _loadAdminData();
  }

  Future<void> _loadAdminData() async {
    admin = await getCurrentEAdminFromSessionData();
    // if (mounted) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
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
      body: widget.child,
    );
  }
}
