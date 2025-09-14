import 'package:call_watcher/core/widgets/logo/logo_heading_auth.dart';
import 'package:call_watcher/data/models/employee.dart';
import 'package:call_watcher/domain/usecases/auth/signup_employee.dart';
import 'package:call_watcher/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupEmployeePage extends StatelessWidget {
  const SignupEmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    // Use TextEditingController if you want to access field values
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Future<void> signupEmployee() async {
      try {
        if (formKey.currentState!.validate()) {
          // If all fields validated, process registration
          // Access values: nameController.text, emailController.text, passwordController.text
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          messenger.showSnackBar(
            const SnackBar(content: Text('Processing Data')),
          );

          final employee = Employee(
              name: nameController.text,
              email: emailController.text,
              password: passwordController.text);

          final result = await serviceLocator<SignupEmployeeUseCase>()
              .call(params: employee);

          if (result.isRight()) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Account created successfully')),
            );
            await Future.delayed(const Duration(seconds: 2));
            router.goNamed('login:employee');
          } else {
            final error = result.fold(
              (left) => left.toString(),
              (right) => 'Unknown error',
            );
            messenger.showSnackBar(SnackBar(content: Text(error)));
          }
        }
      } catch (e) {
        if (!context.mounted) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Register',
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
                        'Create Your Employee Account',
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
                          // Name field
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),

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
                          onPressed: signupEmployee,
                            child: const Text('Sign Up'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                style: TextButton.styleFrom(
                                    // padding: const EdgeInsets.all(0),
                                    ),
                                onPressed: () {
                                  // Navigate to login page
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                'Sign Up',
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
