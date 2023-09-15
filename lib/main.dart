import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stom_club/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: MaterialApp(
          darkTheme: ThemeData(
            brightness: Brightness.light,
          ),
          themeMode: ThemeMode.light,
          home: const SplashScreenWidget(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
