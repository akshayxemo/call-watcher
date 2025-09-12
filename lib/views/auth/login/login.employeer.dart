import 'package:call_watcher/core/util/persistance_storage.helper.dart';
import 'package:call_watcher/core/widgets/logo/logo_heading_auth.dart';
import 'package:call_watcher/domain/repository/auth.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginEmployeePage extends StatelessWidget {
  const LoginEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Use TextEditingController if you want to access field values
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> loginEmployee() async {
      final messenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);
      try {
        if (formKey.currentState!.validate()) {
          // If all fields validated, process registration
          // Access values: nameController.text, emailController.text, passwordController.text
          messenger.showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );

          final result = await serviceLocator<AuthRepository>()
              .employeeSignin(emailController.text, passwordController.text);
          if (result.isRight()) {
            final userData = result.getOrElse(() => {});
            await persistSession(
              userId: userData['id'] as int,
              name: userData['name'] as String,
              email: userData['email'] as String,
              role: 'employee',
            );
            await Future.delayed(const Duration(seconds: 2));
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(
              const SnackBar(
                content: Text('Login Successful'),
                duration: Duration(seconds: 2),
              ),
            );
            router.goNamed('employee:home');
          } else {
            messenger.showSnackBar(SnackBar(
                content: Text(result.leftMap((l) => l.toString()).toString())));
          }
        }
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        alignment: Alignment.center,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Login into Your Employee Account',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      children: [
                        // Email field
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            // Basic email validation
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Password field
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32.0),

                        // Submit button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(double.infinity, 50), // Full width
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 0,
                          ),
                          onPressed: loginEmployee,
                          child: const Text('Login'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              style: TextButton.styleFrom(
                                  // padding: const EdgeInsets.all(0),
                                  ),
                              onPressed: () {
                                // Navigate to signup page
                                context.goNamed('signup:employee');
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        const LogoHeadingAuth(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
