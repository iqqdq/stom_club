import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stom_club/components/transparent_route.dart';
import 'package:stom_club/constants/hex_colors.dart';
import 'package:stom_club/screens/tab_controller/tab_controller_screen.dart';

class SplashScreenBodyWidget extends StatefulWidget {
  const SplashScreenBodyWidget({Key? key}) : super(key: key);

  @override
  _SplashScreenBodyState createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBodyWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.bounceIn,
  );

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.9,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 300));

    super.initState();

    animate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // MARK: -
  // MARK: - ACTIONS

  void animate() {
    _animationController.forward().then((value) => {
          _animationController.reverse().then((value) => Future.delayed(
              const Duration(milliseconds: 500),
              () => Navigator.pushAndRemoveUntil(
                  context,
                  TransparentRoute(
                      builder: (context) => const TabControllerScreenWidget()),
                  (route) => false)))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark),
            toolbarHeight: 0.0,
            elevation: 0.0,
            backgroundColor: Colors.transparent),
        backgroundColor: HexColors.background,
        body: Center(
            child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/ic_tooth.png',
                width: 184.0,
                height: 230.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 32.0),
              Image.asset(
                'assets/ic_stom_club.png',
                // width: 240.0,
                // height: 60.0,
                fit: BoxFit.cover,
              ),
            ],
          ),
        )));
  }
}
