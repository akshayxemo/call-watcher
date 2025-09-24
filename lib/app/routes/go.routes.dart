import 'package:call_watcher/app/providers/layout/admin_layout.dart';
import 'package:call_watcher/views/auth/login/login.employeer.dart';
import 'package:call_watcher/views/auth/signup.login.dart';
import 'package:call_watcher/views/auth/signup/signup.employee.dart';
import 'package:call_watcher/views/home/admin/admin_home.dart';
import 'package:call_watcher/views/home/admin/analytics/analytics_view.dart';
import 'package:call_watcher/views/home/admin/users/users_view.dart';
import 'package:call_watcher/views/home/employee/employee_home.dart';
import 'package:call_watcher/views/splash/splash.page.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // static const String home = '/home';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String loginEmployee = '/login/employee';
  static const String signupEmployee = '/signup/employee';
  static const String loginAdmin = '/login/admin';
  static const String employeeHome = '/home/employee';
  static const String adminHome = '/home/admin';
  static const String adminUsersView = '/home/admin/users';
  static const String adminAnalyticsView = '/home/admin/analytics';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
          path: auth,
          name: 'auth',
          builder: (context, state) => const SignUpLoginPage(),
          routes: [
            GoRoute(
              path: loginEmployee,
              name: 'login:employee',
              builder: (context, state) => const LoginEmployeePage(),
            ),
            GoRoute(
              path: signupEmployee,
              name: 'signup:employee',
              builder: (context, state) => const SignupEmployeePage(),
            ),
          ]),
      GoRoute(
        path: employeeHome,
        name: 'employee:home',
        builder: (context, state) => const EmployeeHomePage(),
      ),
      ShellRoute(
        // for layout and page
        // This builder runs once and persists
        builder: (context, state, child) {
          return AdminLayout(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: adminHome,
            name: 'admin:home',
            builder: (context, state) => const AdminHome(),
          ),
          GoRoute(
            path: adminUsersView,
            name: 'admin:view:users',
            builder: (context, state) => const UsersView(),
          ),
          GoRoute(
            path: adminAnalyticsView,
            name: 'admin:view:analytics',
            builder: (context, state) => const AnalyticsView(),
          ),
        ],
      ),
    ],
  );
}
