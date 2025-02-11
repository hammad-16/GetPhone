import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Navigator.pushReplacementNamed(context, AppRoutes.home);
    // switch (authProvider.status) {
    //   case AuthStatus.authenticated:
    //     Navigator.pushReplacementNamed(context, AppRoutes.home);
    //     break;
    //   case AuthStatus.newUser:
    //     Navigator.pushReplacementNamed(context, AppRoutes.confirmName);
    //     break;
    //   case AuthStatus.unauthenticated:
    //     Navigator.pushReplacementNamed(context, AppRoutes.login);
    //     break;
    //   default:
    //     Navigator.pushReplacementNamed(context, AppRoutes.login);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}