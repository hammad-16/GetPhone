import 'package:flutter/material.dart';
import 'package:oru/screens/pre_login.dart';
import 'package:oru/screens/user_profile.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import 'package:oru/screens/login_screen.dart';
import 'package:oru/screens/otp_screen.dart';
import 'package:oru/screens/confirm_name_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String confirmName = '/confirm-name';
  static const String profile = '/profile';
  static const String preLogin = '/preLogin';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      otp: (context) => const OTPScreen(),
      confirmName: (context) => const ConfirmNameScreen(),
      profile : (context) => const ProfileScreen(),
      preLogin: (context) => const PreLogin()
    };
  }
}
