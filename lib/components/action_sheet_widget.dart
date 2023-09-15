import 'package:flutter/material.dart';
import 'package:stom_club/components/device_detector.dart';
import 'package:stom_club/constants/hex_colors.dart';

class ActionSheetWidget extends StatefulWidget {
  final List<String> actions;
  final Function(int) onIndexTap;

  const ActionSheetWidget(
      {Key? key, required this.actions, required this.onIndexTap})
      : super(key: key);

  @override
  _ActionSheetState createState() => _ActionSheetState();
}

class _ActionSheetState extends State<ActionSheetWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget getItem(int index, String title) {
    return Container(
        margin: EdgeInsets.only(
            bottom: title == 'Cancel' || title == 'Отмена' ? 0.0 : 10.0),
        decoration: BoxDecoration(
            color: title == 'Cancel' || title == 'Отмена'
                ? HexColors.white.withOpacity(0.9)
                : HexColors.white,
            borderRadius: BorderRadius.circular(16.0)),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                highlightColor: Colors.black38,
                onTap: () => {
                      index == widget.actions.length
                          ? _animationController
                              .reverse()
                              .then((value) => Navigator.pop(context))
                          : _animationController.reverse().then((value) => {
                                Navigator.pop(context),
                                widget.onIndexTap(index)
                              })
                    },
                borderRadius: BorderRadius.circular(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(title,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: index == widget.actions.length
                                ? HexColors.rating
                                : HexColors.black)),
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _padding = MediaQuery.of(context).padding;
    final _sheetSize = ((widget.actions.length + 1) * 67.0) +
        (DeviceDetector().isLarge() ? _padding.bottom / 2 : 12.0);

    return Stack(children: [
      InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _animationController
                .reverse()
                .then((value) => Navigator.pop(context));
          },
          child: Opacity(
              opacity: _animationController.value,
              child: Container(
                width: _size.width,
                height: _size.height,
                color: const Color.fromRGBO(0, 0, 0, 0.55),
              ))),
      AnimatedBuilder(
          animation: _animationController,
          builder: (_, child) {
            return Column(
              children: [
                Container(
                    height: _size.height -
                        (_sheetSize * _animationController.value)),
                SizedBox(
                    height: _sheetSize,
                    child: ListView.builder(
                        physics: _sheetSize > _size.height
                            ? const ScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        itemCount: widget.actions.length + 1,
                        itemBuilder: (context, index) {
                          return index == widget.actions.length
                              ? getItem(index, 'Отмена')
                              : getItem(index, widget.actions[index]);
                        })),
              ],
            );
          })
    ]);
  }
}
