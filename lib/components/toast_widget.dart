import 'package:flutter/material.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ToastWidget extends StatefulWidget {
  final AnimationController animationController;
  final double? height;
  final String text;

  const ToastWidget(
      {Key? key,
      required this.animationController,
      this.height,
      required this.text})
      : super(key: key);

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<ToastWidget> with TickerProviderStateMixin {
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animation = CurvedAnimation(
      parent: widget.animationController,
      curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return AnimatedOpacity(
              opacity: widget.animationController.value,
              duration: const Duration(milliseconds: 150),
              child: Container(
                  width: double.infinity,
                  height: 48.0,
                  decoration: BoxDecoration(
                      color: HexColors.selected,
                      borderRadius: BorderRadius.circular(22.0)),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 15.0),
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              color: HexColors.white,
                            ),
                          )))));
        });
  }
}
