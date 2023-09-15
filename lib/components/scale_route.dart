import 'package:flutter/material.dart';

class ScaleRoute extends PageRouteBuilder {
  final Widget child;

  ScaleRoute({required this.child})
      : super(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) => child);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      ScaleTransition(scale: animation, child: child);
}
