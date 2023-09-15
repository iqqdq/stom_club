import 'package:flutter/material.dart';
import 'package:stom_club/components/text_view_widget.dart';
import 'package:stom_club/constants/hex_colors.dart';

class TextContainerViewWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final String? placeholder;
  final VoidCallback onEditingComplete;

  const TextContainerViewWidget(
      {Key? key,
      required this.textEditingController,
      required this.focusNode,
      this.placeholder,
      required this.onEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 23.0, bottom: 23.0),
          child: TextViewWidget(
              textEditingController: textEditingController,
              focusNode: focusNode,
              textColor: HexColors.hint,
              placeholder: placeholder ?? '',
              onEditingComplete: () => onEditingComplete())),
    );
  }
}
