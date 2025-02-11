import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oru/providers/brand_provider.dart';
import 'package:oru/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(create: (_) => BrandProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ORUphones',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white
          ),
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}