import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shuffle_native/app.dart';
import 'package:shuffle_native/pages/home.dart';
// import 'package:shuffle_native/pages/auth/forgot_password.dart';
import 'package:shuffle_native/providers/auth_provider.dart';
import 'package:shuffle_native/widgets/buttons/primary_button.dart';
import 'package:shuffle_native/widgets/dialogs/alert_dialog.dart';
import 'package:shuffle_native/widgets/indicators/pacman_loading_indicator.dart';
// import 'package:shuffle_native/widgets/inputs/email_input.dart';
// import 'package:shuffle_native/widgets/inputs/password_input.dart';
import 'package:shuffle_native/widgets/logos/app_logo.dart';
import 'package:shuffle_native/widgets/main_scaffold.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        "54371413496-g25uv3joic8dp85fs3bhp36efmplb951.apps.googleusercontent.com",
  );
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    // Dispose controllers to free up resources
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Close the keyboard
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email and password are required')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Call the login method from AuthProvider
    final success = await Provider.of<AuthProvider>(
      context,
      listen: false,
    ).login(email, password);

    if (!mounted) return; // Ensure context is still valid

    setState(() {
      isLoading = false; // Hide loading indicator
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => App()),
      );
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap button to dismiss
        builder:
            (BuildContext context) => CustomAlertDialog(
              icon: Icons.error,
              iconColor: Colors.green,
              title: 'Login Failed',
              message: 'Invalid email or password.',
              buttonText: 'Try Again',
              onButtonPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
      );
    }
  }

  Future<void> _googleLogin() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (context) => CustomAlertDialog(
              icon: Icons.error,
              iconColor: Colors.red,
              title: 'Google Sign-Out Failed',
              message: 'Please try again later.',
              buttonText: 'OK',
              onButtonPressed: () {
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final result = await _googleSignIn.signIn();
      if (result == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final googleKey = await result.authentication;

      final success = await Provider.of<AuthProvider>(
        context,
        listen: false,
      ).googleLogin(googleKey.idToken!);

      setState(() {
        isLoading = false;
      });

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScaffold()),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => CustomAlertDialog(
                icon: Icons.error,
                iconColor: Colors.green,
                title: 'Login Failed',
                message: 'Invalid email or password.',
                buttonText: 'Try Again',
                onButtonPressed: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
        );
      }
    } catch (error) {
      debugPrint('Google Sign-In error: $error');
      if (mounted && context.mounted) {
        setState(() {
          isLoading = false;
        });

        String errorMessage = 'Please try again later.';
        String errorTitle = 'Google Sign-In Failed';

        if (error is Exception) {
          if (error.toString().contains('PlatformException')) {
            if (error.toString().contains('10:')) {
              errorMessage = 'Developer configuration error. Please make sure:\n\n'
                  '1. SHA-1 fingerprint is added to Firebase Console\n'
                  '2. Google Sign-In is enabled in Google Cloud Console\n'
                  '3. Package name matches Firebase configuration';
              errorTitle = 'Configuration Error';
            } else if (error.toString().contains('12501')) {
              errorMessage = 'Sign-in was cancelled by user';
              errorTitle = 'Sign-In Cancelled';
            } else if (error.toString().contains('network_error')) {
              errorMessage = 'Please check your internet connection and try again';
              errorTitle = 'Network Error';
            } else if (error.toString().contains('sign_in_failed')) {
              errorMessage = 'Sign-in failed. Please verify your Google Account is working properly';
              errorTitle = 'Authentication Error';
            }
          }
        }

        showDialog(
          context: context,
          builder:
              (context) => CustomAlertDialog(
                icon: Icons.error,
                iconColor: Colors.red,
                title: errorTitle,
                message: errorMessage,
                buttonText: 'OK',
                onButtonPressed: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  // Logo
                  AppLogo(height: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // EmailField(controller: emailController),
                  // const SizedBox(height: 16),

                  // PasswordField(controller: passwordController),
                  // const SizedBox(height: 8),

                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (_) => const ForgotPasswordUI(),
                  //         ),
                  //       );
                  //     },
                  //     child: const Text(
                  //       'Forgot password?',
                  //       style: TextStyle(color: Colors.grey),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  // PrimaryButton(text: "Sign in", onPressed: _login),
                  PrimaryButton(
                    text: "Sign in with Google",
                    onPressed: _googleLogin,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (isLoading) const PacmanLoadingIndicator(),
        ],
      ),
    );
  }
}
