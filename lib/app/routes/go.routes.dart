import 'package:call_watcher/views/auth/signup.login.dart';
import 'package:call_watcher/views/auth/signup/signup.employee.dart';
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
              builder: (context, state) => const SignUpLoginPage(),
            ),
            GoRoute(
              path: signupEmployee,
              name: 'signup:employee',
              builder: (context, state) => const SignupEmployeePage(),
            ),
          ]
      ),
      GoRoute(
        path: employeeHome,
        name: 'employee:home',
        builder: (context, state) => const EmployeeHomePage(),
      ),
    ],
  );
}
